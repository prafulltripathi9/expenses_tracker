import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expenses_tracker/database/app_database.dart';

class MonthlyExpensesScreen extends StatefulWidget {
  const MonthlyExpensesScreen({super.key});

  @override
  State<MonthlyExpensesScreen> createState() =>
      _MonthlyExpensesScreenState();
}

class _MonthlyExpensesScreenState extends State<MonthlyExpensesScreen> {
  static const Color backgroundColor = Color(0xFFFAF8EF);
  static const Color primaryColor = Color(0xFF064E3B);
  static const Color lightGreen = Color(0xFF98CBA5);
  static const Color textColor = Color(0xFF111827);
  static const Color secondaryTextColor = Color(0xFF6B7280);

  DateTime selectedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );

  List<ExpenseData> allExpenses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    try {
      final expenses = await appDatabase.getAllExpenses();

      if (!mounted) return;

      setState(() {
        allExpenses = expenses;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to load expenses. Please try again.'),
        ),
      );
    }
  }

  final List<String> monthNames = const [
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

  String get selectedMonthName => monthNames[selectedMonth.month - 1];

  DateTime get currentMonth {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  bool get canGoNext {
    return selectedMonth.isBefore(currentMonth);
  }

  List<ExpenseData> get selectedMonthExpenses {
    return allExpenses.where((expense) {
      return expense.date.year == selectedMonth.year &&
          expense.date.month == selectedMonth.month;
    }).toList();
  }

  double get selectedMonthTotal {
    return selectedMonthExpenses.fold(
      0.0,
      (sum, expense) => sum + expense.amount,
    );
  }

  List<double> get monthlyTotals {
    return List.generate(selectedMonth.month, (index) {
      final month = index + 1;

      return allExpenses
          .where(
            (expense) =>
                expense.date.year == selectedMonth.year &&
                expense.date.month == month,
          )
          .fold(0.0, (sum, expense) => sum + expense.amount);
    });
  }

  Map<String, double> get categoryTotals {
    final Map<String, double> totals = {};

    for (final expense in selectedMonthExpenses) {
      totals.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    return totals;
  }

  void changeMonth(int difference) {
    final newMonth = DateTime(
      selectedMonth.year,
      selectedMonth.month + difference,
    );

    if (newMonth.isAfter(currentMonth)) return;

    setState(() {
      selectedMonth = newMonth;
    });
  }

  String formatAmount(double amount) {
    return '₹ ${amount.toStringAsFixed(0)}';
  }

  String formatCompactAmount(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    }

    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }

    return amount.toStringAsFixed(0);
  }

  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return const Color(0xFFFFA726);
      case 'travel':
        return const Color(0xFF5795E8);
      case 'shopping':
        return const Color(0xFFFF6474);
      case 'bills':
        return const Color(0xFF4CA3A8);
      case 'entertainment':
        return const Color(0xFFA56AE0);
      case 'health':
        return const Color(0xFFEF5350);
      case 'education':
        return const Color(0xFF26A69A);
      default:
        return const Color(0xFF8B9299);
    }
  }

  IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'travel':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag_rounded;
      case 'bills':
        return Icons.receipt_long;
      case 'entertainment':
        return Icons.movie;
      case 'health':
        return Icons.favorite;
      case 'education':
        return Icons.school;
      default:
        return Icons.category;
    }
  }

  Widget buildMonthSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => changeMonth(-1),
          icon: const Icon(Icons.arrow_back_ios_new, size: 19),
          color: primaryColor,
          tooltip: 'Previous month',
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                selectedMonthName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '${selectedMonth.year}',
                style: const TextStyle(
                  fontSize: 14,
                  color: secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: canGoNext ? () => changeMonth(1) : null,
          icon: const Icon(Icons.arrow_forward_ios, size: 19),
          color: primaryColor,
          disabledColor: Colors.black26,
          tooltip: 'Next month',
        ),
      ],
    );
  }

  Widget buildMonthlyChart(double chartHeight) {
    final totals = monthlyTotals;
    final maxExpense = totals.fold<double>(
      0,
      (max, value) => value > max ? value : max,
    );

    final chartMaxY = maxExpense == 0 ? 100.0 : maxExpense * 1.3;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        height: chartHeight,
        child: BarChart(
          BarChartData(
            maxY: chartMaxY,
            minY: 0,
            alignment: BarChartAlignment.spaceAround,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final month = group.x + 1;

                  return BarTooltipItem(
                    '${monthNames[month - 1]}\n${formatAmount(rod.toY)}',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  );
                },
              ),
            ),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 25,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();

                    if (index < 0 || index >= totals.length) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Text(
                        [
                          'Jan',
                          'Feb',
                          'Mar',
                          'Apr',
                          'May',
                          'Jun',
                          'Jul',
                          'Aug',
                          'Sep',
                          'Oct',
                          'Nov',
                          'Dec',
                        ][index],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              index == selectedMonth.month - 1
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                          color:
                              index == selectedMonth.month - 1
                                  ? primaryColor
                                  : secondaryTextColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            barGroups: List.generate(totals.length, (index) {
              final isSelected = index == selectedMonth.month - 1;

              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: totals[index],
                    width: totals.length > 9 ? 13 : 19,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(5),
                    ),
                    color: isSelected ? primaryColor : lightGreen,
                  ),
                ],
                showingTooltipIndicators: const [],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget buildCategorySummary() {
    final totals = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Category Summary',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                Text(
                  '${selectedMonthName} ${selectedMonth.year}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEAE8DF)),
          if (totals.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 28,
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 35,
                    color: Color(0xFF9CA3AF),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'No expenses for this month',
                    style: TextStyle(
                      fontSize: 13,
                      color: secondaryTextColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Your category summary will appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            )
          else
            ...List.generate(totals.length, (index) {
              final entry = totals[index];
              final percentage = selectedMonthTotal == 0
                  ? 0.0
                  : entry.value / selectedMonthTotal * 100;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: getCategoryColor(
                              entry.key,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            getCategoryIcon(entry.key),
                            color: getCategoryColor(entry.key),
                            size: 17,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            entry.key,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: textColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          formatAmount(entry.value),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 37,
                          child: Text(
                            '${percentage.toStringAsFixed(0)}%',
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontSize: 11,
                              color: secondaryTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index != totals.length - 1)
                    const Divider(
                      height: 1,
                      indent: 14,
                      endIndent: 14,
                      color: Color(0xFFEAE8DF),
                    ),
                ],
              );
            }),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Expenses',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                Text(
                  formatAmount(selectedMonthTotal),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Monthly Expenses',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : LayoutBuilder(
                builder: (context, constraints) {
                  final isSmallScreen = constraints.maxHeight < 650;
                  final pagePadding = isSmallScreen ? 12.0 : 16.0;
                  final sectionSpacing = isSmallScreen ? 10.0 : 16.0;

                  final chartHeight = (
                    constraints.maxHeight * 0.24
                  ).clamp(125.0, 190.0).toDouble();

                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      pagePadding,
                      0,
                      pagePadding,
                      20,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          buildMonthSelector(),
                          SizedBox(height: sectionSpacing),
                          buildMonthlyChart(chartHeight),
                          SizedBox(height: sectionSpacing),
                          buildCategorySummary(),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}