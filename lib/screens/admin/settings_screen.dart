
// lib/screens/admin/settings_screen.dart
import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../models/user_model.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_indicator.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../auth/change_password_screen.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Future<User> _adminSettingsFuture;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAdminSettings();
  }

  Future<void> _loadAdminSettings() async {
    setState(() {
      _adminSettingsFuture = AdminService().getAdminSettings();
    });
    try {
      final admin = await _adminSettingsFuture;
      _usernameController.text = admin.username;
      _emailController.text = admin.email;
    } catch (e) {
       print("Error loading settings: $e");
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Failed to load settings: $e'), backgroundColor: AppColors.error),
         );
       }
    }
  }

   Future<void> _updateSettings() async {
     if (_formKey.currentState!.validate()) {
       setState(() => _isLoading = true);
       try {
          await AdminService().updateAdminSettings(
             _usernameController.text,
             _emailController.text,
          );
           if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text('Settings updated successfully'), backgroundColor: AppColors.success),
              );
              // Optionally reload data after update
              _loadAdminSettings();
           }
       } catch (e) {
          if (mounted) {
             ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to update settings: $e'), backgroundColor: AppColors.error),
             );
          }
       } finally {
          if (mounted) {
             setState(() => _isLoading = false);
          }
       }
     }
   }


  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadAdminSettings,
      color: AppColors.primary,
      child: FutureBuilder<User>(
        future: _adminSettingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && _usernameController.text.isEmpty) {
            // Show loader only on initial load
            return const LoadingIndicator(message: 'Loading settings...');
          } else if (snapshot.hasError && _usernameController.text.isEmpty) {
             return Center(child: Text('Error loading settings: ${snapshot.error}', style: AppTextStyles.bodyText1));
          } else if (!snapshot.hasData && _usernameController.text.isEmpty) {
             return Center(child: Text('Could not load admin settings.', style: AppTextStyles.bodyText1));
          }

          // Even if future completes with error after initial load, show the form with old data
          return ListView( // Use ListView for scrollability
            padding: const EdgeInsets.all(16.0),
            children: [
              Text('Admin Profile', style: AppTextStyles.headline3),
              const SizedBox(height: 12),
              CustomCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                         validator: (value) => value == null || value.isEmpty ? 'Username required' : null,
                         enabled: !_isLoading, // Disable during loading
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                           prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                           if (value == null || value.isEmpty) return 'Email required';
                           if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) return 'Enter a valid email';
                           return null;
                         },
                          enabled: !_isLoading, // Disable during loading
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (_isLoading)
                             const Padding(
                               padding: EdgeInsets.only(right: 16.0),
                               child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 3)),
                             ),
                          CustomButton(
                            text: 'Save Changes',
                            icon: Icons.save_outlined,
                            onPressed: _isLoading ? () {} : _updateSettings, // Disable button when loading
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Security', style: AppTextStyles.headline3),
              const SizedBox(height: 12),
                CustomCard(
                 child: ListTile(
                    leading: const Icon(Icons.lock_outline, color: AppColors.primary),
                    title: Text('Change Password', style: AppTextStyles.bodyText1),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to the new Change Password screen
                       Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                       );
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Change Password screen not implemented yet.')),
                      // );
                    },
                 )
               ),
              // Add other settings sections as needed (e.g., Platform Settings)
            ],
          );
        },
      ),
    );
  }
}