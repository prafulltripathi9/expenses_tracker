class Expenses {
  final String id;
  final String title;
  final String amount;
  final String category;
  final DateTime date;
  final String? note;

  Expenses({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
  });
}