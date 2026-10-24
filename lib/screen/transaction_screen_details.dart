
import 'package:flutter/material.dart';
import 'package:expenses_tracker/database/app_database.dart';

class TransactionDetailScreen extends StatelessWidget {
  final ExpenseData expense;

  const TransactionDetailScreen({
    super.key,
    required this.expense,
  });

  IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'travel':
        return Icons.directions_car_filled;
      case 'shopping':
        return Icons.shopping_bag_rounded;
      case 'bills':
        return Icons.lightbulb_outline;
      case 'entertainment':
        return Icons.movie;
      case 'health':
        return Icons.medical_services;
      case 'education':
        return Icons.school;
      default:
        return Icons.receipt_long;
    }
  }

  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'travel':
        return Colors.blue;
      case 'shopping':
        return Colors.redAccent;
      case 'bills':
        return Colors.teal;
      case 'entertainment':
        return Colors.purple;
      case 'health':
        return Colors.red;
      case 'education':
        return Colors.indigo;
      default:
        return const Color(0xFF047857);
    }
  }

  String formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = getCategoryColor(expense.category);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF8EF),
        foregroundColor: const Color(0xFF111827),
        elevation: 0,
        title: const Text(
          'Transaction Detail',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Edit functionality will be added next.'),
                  ),
                );
              } else if (value == 'delete') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Delete functionality will be added next.'),
                  ),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // Category icon
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9E7FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  getCategoryIcon(expense.category),
                  size: 34,
                  color: categoryColor,
                ),
              ),

              const SizedBox(height: 10),

              // Expense title
              Text(
                expense.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),

              const SizedBox(height: 6),

              // Amount
              Text(
                '₹ ${expense.amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),

              const SizedBox(height: 5),

              // Date
              Text(
                formatDate(expense.date),
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 16),

              // Details card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: const Color(0xFFECE9DF),
                  ),
                ),
                child: Column(
                  children: [
                    _detailRow(
                      label: 'Category',
                      icon: getCategoryIcon(expense.category),
                      iconColor: categoryColor,
                      value: expense.category,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.shade200,
                    ),
                    _detailRow(
                      label: 'Date',
                      icon: Icons.calendar_month_outlined,
                      iconColor: const Color(0xFF334155),
                      value: formatDate(expense.date),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.shade200,
                    ),
                    _detailRow(
                      label: 'Notes',
                      icon: null,
                      iconColor: Colors.grey,
                      value: expense.note?.trim().isNotEmpty == true
                          ? expense.note!.trim()
                          : 'No notes added',
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Edit and Delete buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Edit functionality will be added next.',
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF111827),
                          side: const BorderSide(
                            color: Color(0xFF9CA3AF),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                        child: const Text('Edit'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Delete functionality will be added next.',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF3038),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow({
    required String label,
    required IconData? icon,
    required Color iconColor,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 76,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          if (icon != null) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFFE5EDFF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 17,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF111827),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
