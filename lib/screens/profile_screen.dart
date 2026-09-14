import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            // =========================================
            // PROFILE HEADER
            // =========================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                16,
                15,
                16,
                18,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF1976D2),
              ),

              child: Row(
                children: [

                  // PROFILE IMAGE
                  Container(
                    width: 55,
                    height: 55,

                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Color(0xFF90CAF9),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // USER INFORMATION
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        Text(
                          'Naveed Iqbal',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          'naveed@example.com',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // EDIT BUTTON
                  IconButton(
                    onPressed: () {
                      // Edit profile
                    },

                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 19,
                    ),
                  ),
                ],
              ),
            ),

            // =========================================
            // MENU OPTIONS
            // =========================================

            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(
                  top: 5,
                ),

                children: [

                  _profileOption(
                    icon: Icons.shopping_bag_outlined,
                    title: 'My Orders',
                    onTap: () {
                      // Open orders
                    },
                  ),

                  _profileOption(
                    icon: Icons.location_on_outlined,
                    title: 'My Addresses',
                    onTap: () {
                      // Open addresses
                    },
                  ),

                  _profileOption(
                    icon: Icons.credit_card_outlined,
                    title: 'Payment Methods',
                    onTap: () {
                      // Open payment methods
                    },
                  ),

                  _profileOption(
                    icon: Icons.favorite_border,
                    title: 'Wishlist',
                    onTap: () {
                      // Open wishlist
                    },
                  ),

                  _profileOption(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {
                      // Open help
                    },
                  ),

                  _profileOption(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {
                      // Open settings
                    },
                  ),

                  const SizedBox(height: 10),

                  // =====================================
                  // LOGOUT BUTTON
                  // =====================================

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),

                    child: SizedBox(
                      height: 45,
                      width: double.infinity,

                      child: ElevatedButton(
                        onPressed: () async {
                          final prefs =
                          await SharedPreferences
                              .getInstance();

                          // Turn Remember Me off
                          await prefs.setBool(
                            'remember_me_status',
                            false,
                          );

                          await prefs.remove(
                            'cached_user_email',
                          );

                          if (!context.mounted) return;

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const WelcomeScreen(),
                            ),
                                (route) => false,
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xFFFF3030),

                          foregroundColor: Colors.white,

                          elevation: 0,

                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(7),
                          ),
                        ),

                        child: const Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================
  // PROFILE OPTION
  // ===========================================

  Widget _profileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      child: Container(
        height: 39,

        padding: const EdgeInsets.symmetric(
          horizontal: 17,
        ),

        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),
        ),

        child: Row(
          children: [

            // ICON
            Icon(
              icon,
              size: 18,
              color: Colors.grey.shade700,
            ),

            const SizedBox(width: 12),

            // TITLE
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            ),

            // ARROW
            Icon(
              Icons.chevron_right,
              size: 19,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }
}