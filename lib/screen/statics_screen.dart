import 'package:expenses_tracker/database/app_database.dart'; 
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StaticsScreen extends StatelessWidget {
  const StaticsScreen({super.key});

  static const Color backgroundColor = Color(0xFFFAF8EF);
  static const Color primaryColor = Color(0xFF064E3B);

  static const List<Color> _chartColors = [
    Color(0xFFFF9800),
    Color(0xFF36A875),
    Color(0xFFFF4D4F),
    Color(0xFF999184),
    Color(0xFF5578FF),
    Color(0xFF9960CF),
    Color(0xFF00A6A6),
    Color(0xFFE879A9),
  ];

  String _formatAmount(double amount) => '₹ ${amount.toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentMonthStart = DateTime(now.year, now.month);
    final nextMonthStart = DateTime(now.year, now.month + 1);
    final previousMonthStart = DateTime(now.year, now.month - 1);

    return StreamBuilder<List<ExpenseData>>(
      stream: appDatabase.watchAllExpenses(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: backgroundColor,
            body: const Center(
              child: Text('Unable to load statistics. Please try again.'),
            ),
          );
        }

        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: backgroundColor,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final allExpenses = snapshot.data!;

        final currentMonthExpenses = allExpenses.where((expense) {
          return !expense.date.isBefore(currentMonthStart) &&
              expense.date.isBefore(nextMonthStart);
        }).toList();

        final previousMonthExpenses = allExpenses.where((expense) {
          return !expense.date.isBefore(previousMonthStart) &&
              expense.date.isBefore(currentMonthStart);
        }).toList();

        final currentTotal = currentMonthExpenses.fold<double>(
          0,
          (sum, expense) => sum + expense.amount,
        );
        final previousTotal = previousMonthExpenses.fold<double>(
          0,
          (sum, expense) => sum + expense.amount,
        );

        final transactionCount = currentMonthExpenses.length;
        final dailyAverage = now.day == 0 ? 0.0 : currentTotal / now.day;

        final Map<String, double> categoryTotals = {};
        for (final expense in currentMonthExpenses) {
          final category = expense.category.trim().isEmpty
              ? 'Others'
              : expense.category.trim();
          categoryTotals.update(
            category,
            (total) => total + expense.amount,
            ifAbsent: () => expense.amount,
          );
        }

        final categoryEntries = categoryTotals.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        final comparisonDifference = currentTotal - previousTotal;
        final double comparisonPercent = previousTotal > 0
            ? (comparisonDifference.abs() / previousTotal) * 100
            : 0;

        return Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Statistics',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Monthly summary cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          title: 'Total Expenses',
                          amount: _formatAmount(currentTotal),
                          subtitle: 'This Month',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildSummaryCard(
                          title: 'Transactions',
                          amount: '$transactionCount',
                          subtitle: 'This Month',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildSummaryCard(
                          title: 'Daily Average',
                          amount: _formatAmount(dailyAverage),
                          subtitle: 'This Month',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Category-wise spending chart and legend
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFCF5),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFEDE9DF)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Category-wise Spending',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 5,
                              child: SizedBox(
                                height: 220,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    PieChart(
                                      PieChartData(
                                        sectionsSpace: 2,
                                        centerSpaceRadius: 52,
                                        startDegreeOffset: -90,
                                        sections: categoryEntries.isEmpty
                                            ? [
                                                _chartSection(
                                                  1,
                                                  const Color(0xFFE5E7EB),
                                                ),
                                              ]
                                            : categoryEntries
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                                  return _chartSection(
                                                    entry.value.value,
                                                    _chartColors[
                                                        entry.key %
                                                            _chartColors.length],
                                                  );
                                                }).toList(),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            _formatAmount(currentTotal),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF111827),
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          'Total',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 4,
                              child: categoryEntries.isEmpty
                                  ? const Text(
                                      'No expenses this month',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF64748B),
                                      ),
                                    )
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: categoryEntries
                                          .take(8)
                                          .toList()
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                            final categoryEntry = entry.value;
                                            final percentage = currentTotal > 0
                                                ? categoryEntry.value /
                                                    currentTotal *
                                                    100
                                                : 0.0;
                                            return _categoryLegend(
                                              categoryEntry.key,
                                              '${percentage.toStringAsFixed(0)}%',
                                              _chartColors[
                                                  entry.key %
                                                      _chartColors.length],
                                            );
                                          })
                                          .toList(),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Monthly Comparison',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildMonthCard(
                          title: _monthLabel(previousMonthStart),
                          amount: previousTotal,
                          isCurrent: false,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMonthCard(
                          title: _monthLabel(currentMonthStart),
                          amount: currentTotal,
                          isCurrent: true,
                          comparisonText: previousTotal == 0
                              ? 'No previous-month data'
                              : '${comparisonPercent.toStringAsFixed(1)}% '
                                  '${comparisonDifference > 0 ? 'more' : comparisonDifference < 0 ? 'less' : 'same'} spent',
                          comparisonWentUp: comparisonDifference > 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _monthLabel(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  Widget _buildMonthCard({
    required String title,
    required double amount,
    required bool isCurrent,
    String? comparisonText,
    bool comparisonWentUp = false,
  }) {
    final background = isCurrent
        ? const Color(0xFFEAF2E1)
        : const Color(0xFFFFE3DF);
    final titleColor = isCurrent
        ? const Color(0xFF52735B)
        : const Color(0xFFB83B46);
    final amountColor = isCurrent
        ? primaryColor
        : const Color(0xFFB91C1C);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 13, color: titleColor),
          ),
          const SizedBox(height: 5),
          Text(
            _formatAmount(amount),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: amountColor,
            ),
          ),
          if (comparisonText != null) ...[
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  comparisonWentUp
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  size: 15,
                  color: comparisonWentUp
                      ? const Color(0xFFB91C1C)
                      : const Color(0xFF047857),
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    comparisonText,
                    style: TextStyle(
                      fontSize: 12,
                      color: comparisonWentUp
                          ? const Color(0xFFB91C1C)
                          : const Color(0xFF047857),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String amount,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDE9DF), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              amount,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 9, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  PieChartSectionData _chartSection(double value, Color color) {
    return PieChartSectionData(
      value: value,
      color: color,
      radius: 24,
      showTitle: false,
    );
  }

  Widget _categoryLegend(String title, String percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, color: Color(0xFF111827)),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            percentage,
            style: const TextStyle(fontSize: 12, color: Color(0xFF111827)),
          ),
        ],
      ),
    );
  }
}