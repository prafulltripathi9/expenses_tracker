import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StaticsScreen extends StatelessWidget {
  const StaticsScreen({super.key});

  static const Color backgroundColor = Color(0xFFFAF8EF);
  static const Color primaryColor = Color(0xFF064E3B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Heading
              const Text(
                'Statistics',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),

              const SizedBox(height: 16),

              // Three Summary Boxes
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Total Expenses',
                      amount: '₹ 3,200',
                      subtitle: 'This Month',
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Transactions',
                      amount: '18',
                      subtitle: 'This Month',
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Daily Average',
                      amount: '₹ 103',
                      subtitle: 'This Month',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Category-wise Spending
              Container(
                width: double.infinity,
                height: 300,
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
                      children: [
                        // Donut Chart
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
                                    centerSpaceRadius: 60,
                                    startDegreeOffset: -90,
                                    sections: [
                                      _chartSection(
                                        37,
                                        const Color(0xFFFF9800),
                                      ),
                                      _chartSection(
                                        25,
                                        const Color(0xFF36A875),
                                      ),
                                      _chartSection(
                                        15,
                                        const Color(0xFFFF4D4F),
                                      ),
                                      _chartSection(
                                        10,
                                        const Color(0xFF999184),
                                      ),
                                      _chartSection(8, const Color(0xFF5578FF)),
                                      _chartSection(5, const Color(0xFF9960CF)),
                                    ],
                                  ),
                                ),

                                const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '₹ 3,200',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF111827),
                                      ),
                                    ),
                                    Text(
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

                        // Category Legend
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              _categoryLegend(
                                'Food',
                                '37%',
                                const Color(0xFFFF9800),
                              ),
                              _categoryLegend(
                                'Travel',
                                '25%',
                                const Color(0xFF36A875),
                              ),
                              _categoryLegend(
                                'Shopping',
                                '15%',
                                const Color(0xFFFF4D4F),
                              ),
                              _categoryLegend(
                                'Bills',
                                '10%',
                                const Color(0xFF999184),
                              ),
                              _categoryLegend(
                                'Entertainment',
                                '8%',
                                const Color(0xFF5578FF),
                              ),
                              _categoryLegend(
                                'Others',
                                '5%',
                                const Color(0xFF9960CF),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Monthly Comparison Heading
              const Text(
                'Monthly Comparison',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),

              const SizedBox(height: 10),

              // Monthly Comparison Cards
              Row(
                children: [
                  // Previous Month
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE3DF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'September 2024',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFFB83B46),
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Text(
                            '₹ 4,500',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB91C1C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Current Month
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF2E1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'October 2024',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF52735B),
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Text(
                            '₹ 3,200',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF064E3B),
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Row(
                            children: [
                              Icon(
                                Icons.arrow_downward,
                                size: 15,
                                color: Color(0xFF047857),
                              ),
                              SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  '28.9% less spent',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF047857),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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

  PieChartSectionData _chartSection(double percentage, Color color) {
    return PieChartSectionData(
      value: percentage,
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
              style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(width: 4),

          Text(
            percentage,
            style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
          ),
        ],
      ),
    );
  }
}
