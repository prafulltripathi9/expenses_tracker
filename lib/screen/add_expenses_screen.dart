import 'package:flutter/material.dart';

class AddExpensesScreen extends StatefulWidget {
  const AddExpensesScreen({super.key});

  @override
  State<AddExpensesScreen> createState() => _AddExpensesScreenState();
}

class _AddExpensesScreenState extends State<AddExpensesScreen> {
  @override
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  String selectedCategory = "Food";
  DateTime selectedDate = DateTime.now();
  Future<void> pickDdate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2026),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  final List<String> categories = [
    "Food",
    "Travel",
    "Shopping",
    "Bills",
    "Entertainment",
    "Health",
    "Education",
    "Other",
  ];

  //Category icon and color
  IconData getCategoryIcon(String category) {
    switch (category) {
      case "Food":
        return Icons.restaurant;
      case "Travel":
        return Icons.directions_car;
      case "Shopping":
        return Icons.shopping_bag;
      case "Bills":
        return Icons.receipt_long;
      case "Entertainment":
        return Icons.movie;
      case "Health":
        return Icons.favorite;
      case "Education":
        return Icons.school;
      default:
        return Icons.category;
    }
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case "Food":
        return const Color(0xFFFF9800);
      case "Travel":
        return const Color(0xFF448AFF);
      case "Shopping":
        return const Color(0xFFFF5252);
      case "Bills":
        return const Color(0xFF9575CD);
      case "Entertainment":
        return const Color(0xFFAB47BC);
      case "Health":
        return const Color(0xFFEF5350);
      case "Education":
        return const Color(0xFF00897B);
      default:
        return const Color(0xFF78909C);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Expenses", style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Color(0xFFF5F2E8),
        // foregroundColor: Color(0xFF064E3B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title*",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF064E3B),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Enter expenses title(e.g. Lunch)",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Amount*",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF064E3B),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                hintText: "₹ 0.00",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Category",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF064E3B),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.all(12),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: getCategoryColor(
                      selectedCategory,
                    ).withValues(alpha: 0.15),
                    child: Icon(
                      getCategoryIcon(selectedCategory),
                      color: getCategoryColor(selectedCategory),
                      size: 18,
                    ),
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value;
                  });
                }
              },
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((category) {
                final Color categoryColor = getCategoryColor(category);
                final bool isSelected = selectedCategory == category;

                return SizedBox(
                  width: (MediaQuery.of(context).size.width - 72) / 4,
                  height: 76,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? categoryColor.withValues(alpha: 0.25)
                          : Colors.white,
                      // : categoryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? categoryColor : Color(0xFFE5E7EB),
                        // : categoryColor.withValues(alpha: 0.15),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: categoryColor.withValues(alpha: 0.15),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: categoryColor.withValues(
                            alpha: 0.15,
                          ),
                          child: Icon(
                            getCategoryIcon(category),
                            color: categoryColor,
                            size: 18,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          category,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: const Color(0xFF374151),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 10),
            Text(
              "Date*",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF064E3B),
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: pickDdate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      color: Color(0xFF064E3B),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${selectedDate.day.toString().padLeft(2, '0')}/'
                        '${selectedDate.month.toString().padLeft(2, '0')}/'
                        '${selectedDate.year}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, color: Color(0xFF064E3B)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Note (Optional)",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF064E3B),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: noteController,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: "Filled Petrol at pump",
                alignLabelWithHint: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }
}
