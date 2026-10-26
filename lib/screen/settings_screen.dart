import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const Color backgroundColor = Color(0xFFFAF8EF);
  static const Color primaryColor = Color(0xFF064E3B);
  static const Color sectionColor = Color(0xFFEAF0DF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Heading
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
            ),

            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const double maxContentWidth = 700;

                  final double contentWidth =
                      constraints.maxWidth > maxContentWidth
                      ? maxContentWidth
                      : constraints.maxWidth;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
                    child: Center(
                      child: SizedBox(
                        width: contentWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // App Settings Section
                            _buildSectionHeading('App Settings'),

                            const SizedBox(height: 8),

                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                children: [
                                  _buildSettingTile(
                                    icon: Icons.wb_sunny,
                                    iconColor: const Color(0xFFFF9800),
                                    title: 'Theme',
                                    trailingText: 'Light',
                                    onTap: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Theme settings coming soon.',
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                  _buildDivider(),

                                  _buildSettingTile(
                                    icon: Icons.currency_exchange,
                                    iconColor: const Color(0xFFFFB52E),
                                    title: 'Currency',
                                    trailingText: 'INR (₹)',
                                    onTap: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Currency settings coming soon.',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 22),

                            // About Section
                            _buildSectionHeading('About'),

                            const SizedBox(height: 8),

                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                children: [
                                  _buildSettingTile(
                                    icon: Icons.access_time_filled,
                                    iconColor: const Color(0xFF616161),
                                    title: 'App Version',
                                    trailingText: '1.0.0',
                                    showArrow: false,
                                    onTap: () {},
                                  ),

                                  _buildDivider(),

                                  _buildSettingTile(
                                    icon: Icons.info,
                                    iconColor: const Color(0xFF616161),
                                    title: 'About App',
                                    trailingText: 'Personal Expense Tracker',
                                    showArrow: false,
                                    onTap: () {
                                      showAboutDialog(
                                        context: context,
                                        applicationName:
                                            'Personal Expense Tracker',
                                        applicationVersion: '1.0.0',
                                        applicationIcon: const Icon(
                                          Icons.account_balance_wallet,
                                          size: 40,
                                          color: primaryColor,
                                        ),
                                        children: const [
                                          Text(
                                            'Track your expenses and manage your '
                                            'daily spending in one place.',
                                          ),
                                        ],
                                      );
                                    },
                                  ),

                                  _buildDivider(),

                                  _buildSettingTile(
                                    icon: Icons.help,
                                    iconColor: const Color(0xFF616161),
                                    title: 'Help & Support',
                                    trailingText: 'Get Help',
                                    showArrow: false,
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (dialogContext) {
                                          return AlertDialog(
                                            title: const Text('Help & Support'),
                                            content: const Text(
                                              'Need help using Personal Expense '
                                              'Tracker? Support functionality '
                                              'will be available soon.',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(dialogContext);
                                                },
                                                child: const Text('Close'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),

                                  _buildDivider(),

                                  _buildSettingTile(
                                    icon: Icons.star,
                                    iconColor: const Color(0xFFFF9800),
                                    title: 'Rate Us',
                                    trailingText: 'On Play Store',
                                    showArrow: false,
                                    onTap: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Play Store rating will be available '
                                            'after publishing the app.',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section Heading
  static Widget _buildSectionHeading(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: sectionColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF111827),
        ),
      ),
    );
  }

  // Individual Setting Row
  static Widget _buildSettingTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String trailingText,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 21),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111827),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      trailingText,
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (showArrow) ...[
              const SizedBox(width: 5),
              const Icon(
                Icons.chevron_right,
                size: 19,
                color: Color(0xFF64748B),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Divider Between Rows
  static Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 46),
      child: Divider(height: 1, thickness: 0.5, color: Color(0xFFE5E7EB)),
    );
  }
}
