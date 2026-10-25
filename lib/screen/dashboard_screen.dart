import 'package:expenses_tracker/screen/add_expenses_screen.dart';
import 'package:expenses_tracker/screen/monthly_expenses_screen.dart';
import 'package:expenses_tracker/screen/settings_screen.dart';
import 'package:expenses_tracker/screen/statics_screen.dart';
import 'package:expenses_tracker/screen/transcation_screen.dart';
import 'package:expenses_tracker/widgets/expense_summary_card.dart';
import 'package:expenses_tracker/widgets/today_expense_card.dart';
import 'package:expenses_tracker/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:expenses_tracker/database/app_database.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  List<ExpenseData> allExpenses = [];

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    final expenses = await appDatabase.getAllExpenses();

    if (!mounted) return;

    setState(() {
      allExpenses = expenses;
    });
  }

  double get totalExpenses {
    return allExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  DateTime get currentDate => DateTime.now();

  double get thisMonthExpenses {
    return allExpenses
        .where(
          (expense) =>
              expense.date.year == currentDate.year &&
              expense.date.month == currentDate.month,
        )
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  List<ExpenseData> get todayExpenses {
    return allExpenses.where((expense) {
      return expense.date.year == currentDate.year &&
          expense.date.month == currentDate.month &&
          expense.date.day == currentDate.day;
    }).toList();
  }

  double get todayTotal {
    return todayExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  List<ExpenseData> get recentExpenses {
    final expenses = List<ExpenseData>.from(allExpenses);

    expenses.sort((a, b) {
      final dateComparison = b.date.compareTo(a.date);

      if (dateComparison != 0) {
        return dateComparison;
      }

      return b.id.compareTo(a.id);
    });

    return expenses.take(4).toList();
  }

  String _getCurrentMonth() {
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

    return months[DateTime.now().month - 1];
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
        return Colors.deepPurple;
      case 'shopping':
        return Colors.redAccent;
      case 'bills':
        return Colors.teal;
      case 'entertainment':
        return Colors.pink;
      case 'health':
        return Colors.red;
      case 'education':
        return Colors.indigo;
      default:
        return const Color(0xFF047857);
    }
  }

  String _getMonthName(int month) {
    const months = [
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
    ];

    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    //Start Scfolld
    return Scaffold(
      backgroundColor: Color(0xFFF5F2E8),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFE5EEDB), Color(0xFFF5F2E8)],
                stops: [0.0, 0.65],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Expense Tracker",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF064E3B),
                                ),
                              ),
                              SizedBox(height: 6),
                              InkWell(
                                onTap: () async {
                                  DateTime? selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2026),
                                    lastDate: DateTime(2035),
                                  );
                                  //TODO work later
                                  // if (selectedDate != null) {}
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month_outlined,
                                      color: Color(0xFF064E3B),
                                      size: 20,
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      "Select Date",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF374151),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Color(0xFF374151),
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ExpenseSummaryCard(
                            icon: Icons.account_balance_wallet_outlined,
                            title: "Tottal Expenses",
                            amount: "₹ ${totalExpenses.toStringAsFixed(2)}",
                            subtitle: "All Time",
                            color: Color(0xFF047857),
                            iconBackgroundColor: Color(0xFFD1FAE5),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ExpenseSummaryCard(
                            icon: Icons.calendar_month_outlined,
                            title: "This Month",
                            amount: "₹ ${thisMonthExpenses.toStringAsFixed(2)}",
                            subtitle: _getCurrentMonth(),
                            color: Color(0xFFDC2626),
                            iconBackgroundColor: Color(0xFFFEE2E2),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MonthlyExpensesScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TodayExpenseCard(
                            amount: "₹ ${todayTotal.toStringAsFixed(2)}",
                            transaction: "${todayExpenses.length} transactions",
                          ),
                        ),
                      ],
                    ),
                    // Recent Transactions heading
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Recent Transactions",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF064E3B),
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 1;
                            });
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "View All",
                                style: TextStyle(
                                  color: Color(0xFF047857),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 13,
                                color: Color(0xFF047857),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: recentExpenses.length,
                        itemBuilder: (context, index) {
                          final expense = recentExpenses[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: TransactionCard(
                              icon: getCategoryIcon(expense.category),
                              color: getCategoryColor(expense.category),
                              iconBackgroundColor: getCategoryColor(
                                expense.category,
                              ).withValues(alpha: 0.15),
                              title: expense.title,
                              category: expense.category,
                              date:
                                  "${expense.date.day} ${_getMonthName(expense.date.month)} ${expense.date.year}",
                              amount: "₹ ${expense.amount.toStringAsFixed(2)}",
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const TransactionScreen(),
          const StaticsScreen(),
          const SettingsScreen(),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpensesScreen()),
          );

          if (result == true) {
            await loadExpenses();
          }
        },

        backgroundColor: Color(0xFF064E3B),
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        elevation: 4,
        child: Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF064E3B),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: "Transaction",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: "Statistics",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
