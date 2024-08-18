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

  const query = 'SELECT * FROM Users WHERE email = ?';
  db.query(query, [email], (err, results) => {
    if (err) {
      console.error('Error fetching user:', err);
      return res.status(500).json({ error: err.message });
    }
    if (results.length === 0) {
      return res.status(400).json({ message: 'User not found' });
    }

    const user = results[0];
    const isMatch = bcrypt.compareSync(password, user.password);

    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    const token = jwt.sign({ id: user.user_id }, process.env.JWT_SECRET, { expiresIn: '1h' });
    res.json({ token, user_id: user.user_id }); // Return user_id along with the token
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