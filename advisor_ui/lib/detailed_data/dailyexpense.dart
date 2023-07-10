class expense {
  final String date;
  final String category;
  final double amount;

  expense({
    required this.date,
    required this.category, 
    required this.amount,
  });

  factory expense.fromJson(Map<String, dynamic> json) {
    return expense(
      date:json['Date'].toString(),
      category: json['exCategory'],
      amount: json['amount'],
    );
  }
}
