import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:blaundry_registlogin/login_customer.dart'; // Import login page
import 'package:blaundry_registlogin/dashboard.dart';
import 'package:blaundry_registlogin/button_navbar_user.dart';
import 'package:blaundry_registlogin/myorder.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;

  String username = "Khidir Julian";
  String password = "••••••••••••";
  String phoneNumber = "+62 812-3456-7890";
  String address = "Jl. Telekomunikasi No.1, Bandung";

  // Colors
  static const _primaryColor = Color(0xFF05588A);
  static const _backgroundColor = Color(0xFFF8F9FA);
  static const _errorColor = Color(0xFFE63946);
  static const _successColor = Color(0xFF2A9D8F);
  static const _textColor = Color(0xFF333333);
  static const _subtextColor = Color(0xFF666666);

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() => _profileImage = pickedImage);
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: _primaryColor),
              title: const Text("Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: _primaryColor),
              title: const Text("Camera"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editField(
      String title, String currentValue, ValueChanged<String> onSave) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $title"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: "Enter new $title",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: _primaryColor)),
          ),
          ElevatedButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
              _showSnackbar("$title updated", _successColor);
            },
            style: ElevatedButton.styleFrom(backgroundColor: _primaryColor),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _editPassword() {
    final oldController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Current Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "New Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Confirm Password",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: _primaryColor)),
          ),
          ElevatedButton(
            onPressed: () {
              if (newController.text != confirmController.text) {
                _showSnackbar("Passwords don't match", _errorColor);
              } else if (newController.text.length < 8) {
                _showSnackbar("Password too short", _errorColor);
              } else {
                setState(() => password = "••••••••••••");
                Navigator.pop(context);
                _showSnackbar("Password updated", _successColor);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: _primaryColor),
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text("Profile",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            )),
        centerTitle: true,
        backgroundColor: _primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _showLogoutConfirmation(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _showImagePickerOptions,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: _profileImage != null
                              ? FileImage(File(_profileImage!.path))
                              : null,
                          child: _profileImage == null
                              ? const Icon(Icons.person,
                                  size: 40, color: Colors.grey)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: _primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Profile Details
            _buildProfileCard(
              children: [
                _buildProfileTile(
                  icon: Icons.person_outline,
                  title: "Username",
                  value: username,
                  onTap: () => _editField("Username", username,
                      (val) => setState(() => username = val)),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _buildProfileTile(
                  icon: Icons.lock_outline,
                  title: "Password",
                  value: password,
                  onTap: _editPassword,
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _buildProfileTile(
                  icon: Icons.phone_android_outlined,
                  title: "Phone",
                  value: phoneNumber,
                  onTap: () => _editField("Phone", phoneNumber,
                      (val) => setState(() => phoneNumber = val)),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _buildProfileTile(
                  icon: Icons.home_outlined,
                  title: "Address",
                  value: address,
                  onTap: () => _editField("Address", address,
                      (val) => setState(() => address = val)),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showSnackbar("Profile saved", _successColor),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Save Changes",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),

            const SizedBox(height: 12),

            TextButton(
              onPressed: () => _showDeleteConfirmation(),
              child: const Text("Delete Account",
                  style: TextStyle(color: _errorColor, fontSize: 14)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBaruser(
        selectedIndex: 2, // Profile is selected
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyOrderPage()),
            );
          }
        },
      ),
    );
  }

  // Add this new method for logout confirmation
  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout Confirmation"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child:
                  const Text("Cancel", style: TextStyle(color: _primaryColor)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginCustomerPage()),
                );
              },
              child: const Text("Logout", style: TextStyle(color: _errorColor)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileCard({required List<Widget> children}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: _primaryColor, size: 22),
      title: Text(title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: _textColor,
          )),
      subtitle: Text(value,
          style: const TextStyle(
            fontSize: 13,
            color: _subtextColor,
          )),
      trailing: const Icon(Icons.edit, size: 18, color: Colors.grey),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      minLeadingWidth: 24,
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account?",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("This action cannot be undone. Are you sure?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: _primaryColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackbar("Account deleted", _errorColor);
            },
            child: const Text("Delete",
                style:
                    TextStyle(color: _errorColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
