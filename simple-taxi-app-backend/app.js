const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql');
const dotenv = require('dotenv');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

dotenv.config();

const app = express();
app.use(bodyParser.json());

// MySQL connection
const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

db.connect(err => {
  if (err) {
    console.error('Error connecting to MySQL:', err);
    return;
  }
  console.log('Connected to MySQL');
});

// Root route
// Root route
app.get('/', (req, res) => {
  res.send('Welcome to the API');
});

// Register endpoint
app.post('/api/users/register', (req, res) => {
  const { username, email, password } = req.body;
  const hashedPassword = bcrypt.hashSync(password, 10);

  const query = 'INSERT INTO Users (username, email, password) VALUES (?, ?, ?)';
  db.query(query, [username, email, hashedPassword], (err, result) => {
    if (err) {
      console.error('Error inserting user:', err);
      return res.status(500).json({ error: err.message });
    }
    res.json({ id: result.insertId, username, email });
  });
});

// Login endpoint
app.post('/api/users/login', (req, res) => {
  const { email, password } = req.body;

  console.log('Login attempt:', email, password);

  const query = 'SELECT * FROM Users WHERE email = ?';
  db.query(query, [email], (err, results) => {
    if (err) {
      console.error('Error fetching user:', err);
      return res.status(500).json({ error: err.message });
    }
    if (results.length === 0) {
      console.log('User not found');
      return res.status(400).json({ message: 'User not found' });
    }

    const user = results[0];
    console.log('User found:', user);

    const isMatch = bcrypt.compareSync(password, user.password);  // Compare hashed password
    console.log('Password match:', isMatch);

    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    const token = jwt.sign(
      { id: user.user_id, role: user.role }, // Include role in the token payload
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );
    
    // Include role in the response
    res.json({ token, user_id: user.user_id, role: user.role });
  });
});





const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => console.log(`Server running on port ${PORT}`));

//Fetch ride history for a user
app.get('/api/rides/history', (req, res) => {
  const userId = req.query.userId;
  const role = req.query.role; // role can be 'Passenger' or 'Driver'

  let query = `
    SELECT Rides.*, Users.username as driver_name 
    FROM Rides 
    JOIN Users ON Rides.driver_id = Users.user_id
    WHERE passenger_id = ?
  `;

  if (role === 'Driver') {
    query = `
      SELECT Rides.*, Users.username as passenger_name 
      FROM Rides 
      JOIN Users ON Rides.passenger_id = Users.user_id
      WHERE driver_id = ?
    `;
  }

  db.query(query, [userId], (err, results) => {
    if (err) {
      console.error('Error fetching ride history:', err);
      return res.status(500).json({ error: err.message });
    }
    res.json(results);
  });
});

// Sumbit a review for a ride
app.post('/api/reviews', (req, res) => {
  const { rideId, reviewerId, revieweeId, rating, comments } = req.body;

  const query = `
    INSERT INTO Reviews (ride_id, reviewer_id, reviewee_id, rating, comments, created_at)
    VALUES (?, ?, ?, ?, ?, NOW())
  `;

  db.query(query, [rideId, reviewerId, revieweeId, rating, comments], (err, result) => {
    if (err) {
      console.error('Error submitting review:', err);
      return res.status(500).json({ error: err.message });
    }
    res.json({ id: result.insertId, message: 'Review submitted successfully' });
  });
});

// Fetch user profile
app.get('/api/users/profile', (req, res) => {
  const userId = req.query.userId;

  const query = 'SELECT user_id, username, email, role FROM Users WHERE user_id = ?';
  db.query(query, [userId], (err, results) => {
    if (err) {
      console.error('Error fetching user profile:', err);
      return res.status(500).json({ error: err.message });
    }
    if (results.length === 0) {
      return res.status(404).json({ message: 'User not found' });
    }
    res.json(results[0]); // Return the first result (there should only be one)
  });
});

// Update Profile Endpoint
app.put('/api/users/profile/update', (req, res) => {
  const { user_id, username, email, role } = req.body;

  // Check if all required fields are present
  if (!user_id || !username || !email) {
    return res.status(400).json({ error: 'Missing required fields' });
  }

  // SQL query to update the user's profile
  const query = 'UPDATE Users SET username = ?, email = ?, role = ? WHERE user_id = ?';

  // Execute the query with the provided data
  db.query(query, [username, email, role, user_id], (err, result) => {
    if (err) {
      console.error('Error updating profile:', err);
      return res.status(500).json({ error: 'Failed to update profile' });
    }

    // Check if any rows were affected (i.e., updated)
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Return a success message if the update was successful
    res.status(200).json({ message: 'Profile updated successfully' });
  });
});

// Update Driver Registration Endpoint
app.post('/api/drivers/register', (req, res) => {
  const { username, email, password, vehicle_type, vehicle_registration_number } = req.body;
  const hashedPassword = bcrypt.hashSync(password, 10);

  const queryUser = 'INSERT INTO Users (username, email, password, role) VALUES (?, ?, ?, ?)';
  db.query(queryUser, [username, email, hashedPassword, 'driver'], (err, result) => {
    if (err) {
      console.error('Error inserting user:', err);
      return res.status(500).json({ error: err.message });
    }
    const userId = result.insertId;
    const queryDriver = 'INSERT INTO Drivers (user_id, vehicle_type, vehicle_registration_number, availability_status) VALUES (?, ?, ?, ?)';
    db.query(queryDriver, [userId, vehicle_type, vehicle_registration_number, 'available'], (err) => {
      if (err) {
        console.error('Error inserting driver:', err);
        return res.status(500).json({ error: err.message });
      }
      const token = jwt.sign({ user_id: userId, role: 'driver' }, process.env.JWT_SECRET, { expiresIn: '1h' });
      res.status(201).json({ token, message: 'Driver registered successfully.' });
    });
  });
});

//Driver Login Endpoint
app.post('/api/drivers/login', (req, res) => {
  const { email, password } = req.body;
  const query = 'SELECT * FROM Users WHERE email = ? AND role = "driver"';
  
  db.query(query, [email], (err, results) => {
    if (err) {
      console.error('Error fetching driver:', err);
      return res.status(500).json({ error: err.message });
    }
    if (results.length === 0) {
      return res.status(400).json({ message: 'Driver not found' });
    }
    
    const user = results[0];
    const isMatch = bcrypt.compareSync(password, user.password);
    
    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }
    
    const token = jwt.sign({ user_id: user.user_id, role: user.role }, process.env.JWT_SECRET, { expiresIn: '1h' });
    res.json({ token, user_id: user.user_id });
  });
});

//Fetch available Ride Requests
app.get('/api/drivers/ride-requests', (req, res) => {
  const query = `
    SELECT RideRequests.*, Users.username AS passenger_name 
    FROM RideRequests 
    JOIN Users ON RideRequests.passenger_id = Users.user_id 
    WHERE RideRequests.status = 'pending'
  `;
  
  db.query(query, (err, results) => {
    if (err) {
      console.error('Error fetching ride requests:', err);
      return res.status(500).json({ error: err.message });
    }
    res.json(results);
  });
});

//Accept Ride Request
app.post('/api/drivers/ride-requests/:request_id/accept', (req, res) => {
  const driverId = req.body.driver_id;
  const requestId = req.params.request_id;

  const query = 'UPDATE RideRequests SET driver_id = ?, status = "accepted" WHERE request_id = ? AND status = "pending"';
  db.query(query, [driverId, requestId], (err, result) => {
    if (err) {
      console.error('Error accepting ride request:', err);
      return res.status(500).json({ error: err.message });
    }

    if (result.affectedRows === 0) {
      return res.status(400).json({ message: 'Ride request not available or already accepted' });
    }

    res.status(200).json({ message: 'Ride request accepted successfully' });
  });
});

//Update Ride Status
app.put('/api/drivers/rides/:ride_id/status', (req, res) => {
  const { status } = req.body;
  const rideId = req.params.ride_id;

  const query = 'UPDATE Rides SET status = ? WHERE ride_id = ?';
  db.query(query, [status, rideId], (err) => {
    if (err) {
      console.error('Error updating ride status:', err);
      return res.status(500).json({ error: err.message });
    }
    res.status(200).json({ message: 'Ride status updated successfully' });
  });
});

// Driver Registration Endpoint
// Update Driver Registration Endpoint
app.post('/api/drivers/register', (req, res) => {
  const { username, email, password, vehicle_type, vehicle_registration_number } = req.body;
  const hashedPassword = bcrypt.hashSync(password, 10);

  const queryUser = 'INSERT INTO Users (username, email, password, role) VALUES (?, ?, ?, ?)';
  db.query(queryUser, [username, email, hashedPassword, 'Driver'], (err, result) => {
    if (err) {
      console.error('Error inserting user:', err);
      return res.status(500).json({ error: err.message });
    }
    const userId = result.insertId;
    const queryDriver = 'INSERT INTO Drivers (user_id, vehicle_type, vehicle_registration_number, availability_status) VALUES (?, ?, ?, ?)';
    db.query(queryDriver, [userId, vehicle_type, vehicle_registration_number, 'available'], (err) => {
      if (err) {
        console.error('Error inserting driver:', err);
        return res.status(500).json({ error: err.message });
      }
      const token = jwt.sign({ user_id: userId, role: 'Driver' }, process.env.JWT_SECRET, { expiresIn: '1h' });
      res.status(201).json({ token, message: 'Driver registered successfully.' });
    });
  });
});


// Fetch Driver Details Endpoint
app.get('/api/drivers/:id', (req, res) => {
  const driverId = req.params.id;
  const query = 'SELECT * FROM Drivers WHERE driver_id = ?';
  db.query(query, [driverId], (err, result) => {
    if (err) {
      console.error('Error fetching driver:', err);
      return res.status(500).json({ error: err.message });
    }
    if (result.length === 0) {
      return res.status(404).json({ message: 'Driver not found' });
    }
    res.json(result[0]);
  });
});

// Handle Ride Request Endpoint
app.post('/api/rides/request', (req, res) => {
  const { passenger_id, pickup_location, destination, vehicle_type } = req.body;
  const query = 'INSERT INTO RideRequests (passenger_id, pickup_location, destination, vehicle_type) VALUES (?, ?, ?, ?)';
  db.query(query, [passenger_id, pickup_location, destination, vehicle_type], (err, result) => {
    if (err) {
      console.error('Error creating ride request:', err);
      return res.status(500).json({ error: err.message });
    }
    res.json({ request_id: result.insertId });
  });
});

// Fetch Earnings Summary for a Driver
app.get('/api/drivers/earnings', (req, res) => {
  const driverId = req.query.driverId;
  const query = `
    SELECT 
      SUM(CASE WHEN DATE(ride_date) = CURDATE() THEN cost ELSE 0 END) AS today,
      SUM(CASE WHEN WEEK(ride_date) = WEEK(CURDATE()) THEN cost ELSE 0 END) AS thisWeek,
      SUM(CASE WHEN MONTH(ride_date) = MONTH(CURDATE()) THEN cost ELSE 0 END) AS thisMonth
    FROM Rides
    WHERE driver_id = ?`;
  db.query(query, [driverId], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(results[0]);
  });
});



// Fetch Current Ride Details
app.get('/api/drivers/current-ride', (req, res) => {
  const driverId = req.query.driverId; // Assuming driverId is passed as a query param

  const query = `
    SELECT Rides.*, Users.username AS passenger 
    FROM Rides 
    JOIN Users ON Rides.passenger_id = Users.user_id 
    WHERE driver_id = ? AND status = 'ongoing'
  `;

  db.query(query, [driverId], (err, results) => {
    if (err) {
      console.error('Error fetching current ride:', err);
      return res.status(500).json({ error: err.message });
    }
    if (results.length === 0) {
      return res.status(404).json({ message: 'No ongoing ride found' });
    }
    res.json(results[0]);
  });
});
