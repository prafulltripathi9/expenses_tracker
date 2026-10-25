import 'package:expenses_tracker/database/app_database.dart';
import 'package:expenses_tracker/screen/transaction_screen_details.dart';
import 'package:flutter/material.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final TextEditingController searchController = TextEditingController();

  String selectedCategory = "All";
  List<ExpenseData> allExpenses = [];
  String selectedDateRange = "All Time";
  DateTime? customSelectedDate;

  String appliedCategory = "All";
  String appliedDateRange = "All Time";
  DateTime? appliedCustomDate;
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

  List<ExpenseData> get filteredExpenses {
    final query = searchController.text.trim().toLowerCase();
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));

    final startOfMonth = DateTime(now.year, now.month, 1);

    final filtered = allExpenses.where((expense) {
      final matchesCategory =
          selectedCategory == "All" ||
          expense.category.toLowerCase() == selectedCategory.toLowerCase();

      final matchesSearch =
          expense.title.toLowerCase().contains(query) ||
          expense.category.toLowerCase().contains(query) ||
          (expense.note ?? "").toLowerCase().contains(query);

      final expenseDate = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );

      bool matchesDate = true;

      switch (selectedDateRange) {
        case "Today":
          matchesDate = expenseDate == today;
          break;

        case "This Week":
          matchesDate =
              !expenseDate.isBefore(startOfWeek) && !expenseDate.isAfter(today);
          break;

        case "This Month":
          matchesDate =
              expenseDate.year == now.year && expenseDate.month == now.month;
          break;

        case "Custom Date":
          if (customSelectedDate != null) {
            matchesDate =
                expenseDate.year == customSelectedDate!.year &&
                expenseDate.month == customSelectedDate!.month &&
                expenseDate.day == customSelectedDate!.day;
          }
          break;

        case "All Time":
        default:
          matchesDate = true;
      }

      return matchesCategory && matchesSearch && matchesDate;
    }).toList();

    filtered.sort((a, b) {
      final dateComparison = b.date.compareTo(a.date);

      if (dateComparison != 0) {
        return dateComparison;
      }

      return b.id.compareTo(a.id);
    });

    return filtered;
  }

  final List<String> categories = [
    "All",
    "Food",
    "Travel",
    "Shopping",
    "Bills",
    "Entertainment",
    "Health",
    "Education",
    "Other",
  ];

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

  Future<void> showTransactionFilters() async {
    String tempCategory = selectedCategory;
    String tempDateRange = selectedDateRange;
    DateTime? tempCustomDate = customSelectedDate;

    const dateRanges = [
      "All Time",
      "Today",
      "This Week",
      "This Month",
      "Custom Date",
    ];

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final screenHeight = MediaQuery.of(context).size.height;

            Widget optionChip({
              required String label,
              required bool selected,
              required VoidCallback onTap,
              IconData? icon,
            }) {
              return InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF047857)
                        : const Color(0xFFF0F0EB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF047857)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          size: 15,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF047857),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final categoryIcons = <String, IconData>{
              "All": Icons.apps,
              "Food": Icons.restaurant,
              "Travel": Icons.directions_car,
              "Shopping": Icons.shopping_bag,
              "Bills": Icons.receipt_long,
              "Entertainment": Icons.movie,
              "Health": Icons.favorite,
              "Education": Icons.school,
              "Other": Icons.category,
            };

            return SafeArea(
              top: false,
              child: Container(
                constraints: BoxConstraints(maxHeight: screenHeight * 0.88),
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFCF5),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Filter Transactions",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          icon: const Icon(Icons.close, size: 21),
                        ),
                      ],
                    ),

                    const SizedBox(height: 2),

                    const Text(
                      "Category",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: categories.map((category) {
                        return optionChip(
                          label: category,
                          selected: tempCategory == category,
                          icon: categoryIcons[category],
                          onTap: () {
                            setSheetState(() {
                              tempCategory = category;
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Date Range",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: dateRanges.map((range) {
                        return optionChip(
                          label: range,
                          selected: tempDateRange == range,
                          onTap: () async {
                            if (range == "Custom Date") {
                              final now = DateTime.now();

                              final picked = await showDatePicker(
                                context: context,
                                initialDate: tempCustomDate ?? now,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(now.year + 5),
                              );

                              if (picked != null) {
                                setSheetState(() {
                                  tempDateRange = range;
                                  tempCustomDate = picked;
                                });
                              }
                            } else {
                              setSheetState(() {
                                tempDateRange = range;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),

                    if (tempDateRange == "Custom Date" &&
                        tempCustomDate != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        "Selected: ${tempCustomDate!.day}/"
                        "${tempCustomDate!.month}/"
                        "${tempCustomDate!.year}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF047857),
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: OutlinedButton(
                              onPressed: () {
                                setSheetState(() {
                                  tempCategory = "All";
                                  tempDateRange = "All Time";
                                  tempCustomDate = null;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF064E3B),
                                side: const BorderSide(
                                  color: Color(0xFF064E3B),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                              ),
                              child: const Text("Reset"),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(sheetContext, true);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF047857),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                              ),
                              child: const Text(
                                "Apply Filter",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result == true && mounted) {
      setState(() {
        selectedCategory = tempCategory;
        selectedDateRange = tempDateRange;
        customSelectedDate = tempCustomDate;
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              // Heading and Filter Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      "All Transactions",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: showTransactionFilters,
                    icon: const Icon(
                      Icons.filter_list,
                      size: 28,
                      color: Color(0xFF064E3B),
                    ),
                    tooltip: 'Filter transactions',
                  ),
                ],
              ),

              const SizedBox(height: 8),
              const SizedBox(height: 8),

              // Transaction count
              Text(
                "${allExpenses.length} transactions",
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),

              const SizedBox(height: 22),

              // Search bar
              TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: "Search transactions...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Horizontal category options
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = selectedCategory == category;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Colors.green
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Transactions area
              Expanded(
                child: filteredExpenses.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 60,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 12),
                            Text(
                              "No transactions found",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Try another search or category.",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: filteredExpenses.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final expense = filteredExpenses[index];

                          return InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () async {
                              final result = await Navigator.push<bool>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TransactionDetailScreen(expense: expense),
                                ),
                              );

                              if (result == true) {
                                await loadExpenses();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: getCategoryColor(
                                      expense.category,
                                    ).withValues(alpha: 0.15),
                                    child: Icon(
                                      getCategoryIcon(expense.category),
                                      color: getCategoryColor(expense.category),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          expense.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "${expense.category} • ${expense.date.day}/${expense.date.month}/${expense.date.year}",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        if (expense.note != null &&
                                            expense.note!.isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            expense.note!,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  Text(
                                    "₹ ${expense.amount.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF064E3B),
                                    ),
                                  ),

                                  const SizedBox(width: 4),

                                  const Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
