import 'package:expenses_tracker/screen/add_expenses_screen.dart';
import 'package:expenses_tracker/widgets/expense_summary_card.dart';
import 'package:expenses_tracker/widgets/today_expense_card.dart';
import 'package:expenses_tracker/widgets/transaction_card.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F2E8),
      body: Container(
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
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.filter_list,
                        color: Color(0xFF064E3B),
                        size: 28,
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
                        amount: "₹ 8,450",
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
                        amount: "₹ 3,200",
                        subtitle: "December",
                        color: Color(0xFFDC2626),
                        iconBackgroundColor: Color(0xFFFEE2E2),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TodayExpenseCard(
                        amount: "₹ 450",
                        transaction: "3 transactions",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TransactionCard(
                        icon: Icons.shopping_bag_rounded,
                        color: Color(0xFF047857),
                        iconBackgroundColor: Color(0xFFD1FAE5),
                        title: "Groceries",
                        category: "Shopping",
                        date: "Today",
                        amount: "₹ 600",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpensesScreen()),
          );
        },
        backgroundColor: Color(0xFF064E3B),
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        elevation: 4,
        child: Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF064E3B),
        unselectedItemColor: Colors.grey,

        items: [
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
