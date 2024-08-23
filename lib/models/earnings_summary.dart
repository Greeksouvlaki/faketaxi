class EarningsSummary {
  final double today;
  final double thisWeek;
  final double thisMonth;

  EarningsSummary({
    required this.today,
    required this.thisWeek,
    required this.thisMonth,
  });

  factory EarningsSummary.fromJson(Map<String, dynamic> json) {
    return EarningsSummary(
      today: json['today'],
      thisWeek: json['thisWeek'],
      thisMonth: json['thisMonth'],
    );
  }
}
