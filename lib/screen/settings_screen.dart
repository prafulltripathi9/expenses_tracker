import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expenses_tracker/main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const Color backgroundColor = Color(0xFFFAF8EF);
  static const Color primaryColor = Color(0xFF064E3B);
  static const Color sectionColor = Color(0xFFEAF0DF);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();

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
          fontSize: 15,
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
            Icon(icon, color: iconColor, size: 22),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111827),
                ),
              ),
            ),

            const SizedBox(width: 8),

            Flexible(
              child: Text(
                trailingText,
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
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

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = false;
  bool budgetAlertsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;

      budgetAlertsEnabled = prefs.getBool('budgetAlertsEnabled') ?? false;
    });
  }

  //Widget _buildSwitchTile
  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF111827),
              ),
            ),
          ),

          Switch(
            value: value,
            activeThumbColor: const Color(0xFF064E3B),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
  // _showThemeDialog method for theme settings
void _showThemeDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AnimatedBuilder(
        animation: themeService,
        builder: (context, child) {
          return AlertDialog(
            title: const Text('Choose Theme'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('Light'),
                  value: ThemeMode.light,
                  groupValue: themeService.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      themeService.setTheme(value);
                      Navigator.pop(dialogContext);
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Dark'),
                  value: ThemeMode.dark,
                  groupValue: themeService.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      themeService.setTheme(value);
                      Navigator.pop(dialogContext);
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('System Default'),
                  value: ThemeMode.system,
                  groupValue: themeService.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      themeService.setTheme(value);
                      Navigator.pop(dialogContext);
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SettingsScreen.backgroundColor,
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

            // Remaining Screen Space
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const double maxContentWidth = 700;

                  final double contentWidth =
                      constraints.maxWidth > maxContentWidth
                      ? maxContentWidth
                      : constraints.maxWidth;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                    child: Center(
                      child: SizedBox(
                        width: contentWidth,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // App Settings Section
                              SettingsScreen._buildSectionHeading(
                                'App Settings',
                              ),

                              const SizedBox(height: 8),

                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  children: [
                                    SettingsScreen._buildSettingTile(
                                      icon: Icons.wb_sunny,
                                      iconColor: const Color(0xFFFF9800),
                                      title: 'Theme',
                                      trailingText: switch (themeService
                                          .themeMode) {
                                        ThemeMode.light => 'Light',
                                        ThemeMode.dark => 'Dark',
                                        ThemeMode.system => 'System Default',
                                      },
                                      onTap: () {
                                         _showThemeDialog(context);
                                      },
                                    ),

                                    SettingsScreen._buildDivider(),

                                    SettingsScreen._buildSettingTile(
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
                                    // Divider
                                    SettingsScreen._buildDivider(),

                                    // Notifications
                                    _buildSwitchTile(
                                      icon: Icons.notifications_active,
                                      iconColor: const Color(0xFF4CAF50),
                                      title: 'Notifications',
                                      value: notificationsEnabled,
                                      onChanged: (value) async {
                                        final prefs =
                                            await SharedPreferences.getInstance();

                                        await prefs.setBool(
                                          'notificationsEnabled',
                                          value,
                                        );

                                        if (!mounted) return;

                                        setState(() {
                                          notificationsEnabled = value;
                                        });
                                      },
                                    ),

                                    SettingsScreen._buildDivider(),

                                    // Budget Alerts
                                    _buildSwitchTile(
                                      icon: Icons.account_balance_wallet,
                                      iconColor: const Color(0xFF064E3B),
                                      title: 'Budget Alerts',
                                      value: budgetAlertsEnabled,
                                      onChanged: (value) async {
                                        final prefs =
                                            await SharedPreferences.getInstance();

                                        await prefs.setBool(
                                          'budgetAlertsEnabled',
                                          value,
                                        );

                                        if (!mounted) return;

                                        setState(() {
                                          budgetAlertsEnabled = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 22),

                              // About Section
                              SettingsScreen._buildSectionHeading('About'),

                              const SizedBox(height: 8),

                              // Expanded About Container
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SettingsScreen._buildSettingTile(
                                      icon: Icons.access_time_filled,
                                      iconColor: const Color(0xFF616161),
                                      title: 'App Version',
                                      trailingText: '1.0.0',
                                      showArrow: false,
                                      onTap: () {},
                                    ),

                                    SettingsScreen._buildDivider(),

                                    SettingsScreen._buildSettingTile(
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
                                            color: SettingsScreen.primaryColor,
                                          ),
                                          children: const [
                                            Text(
                                              'Track your expenses and manage '
                                              'your daily spending in one place.',
                                            ),
                                          ],
                                        );
                                      },
                                    ),

                                    SettingsScreen._buildDivider(),

                                    SettingsScreen._buildSettingTile(
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
                                              title: const Text(
                                                'Help & Support',
                                              ),
                                              content: const Text(
                                                'Need help using Personal '
                                                'Expense Tracker? Support '
                                                'functionality will be '
                                                'available soon.',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                      dialogContext,
                                                    );
                                                  },
                                                  child: const Text('Close'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),

                                    SettingsScreen._buildDivider(),

                                    SettingsScreen._buildSettingTile(
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
                                              'Play Store rating will be '
                                              'available after publishing '
                                              'the app.',
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
}
