import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:blaundry_registlogin/dashboard.dart'; // Import DashboardPage

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;

  String username = "Khidir Julian";
  String password = "************";
  String phoneNumber = "+62 812-3456-7890";
  String address = "Jl. Telekomunikasi No.1, Bandung";

  Future<void> _pickImageFromGallery() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = pickedImage;
      });
    }
  }

  Future<void> _takePhoto() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _profileImage = pickedImage;
      });
    }
  }

  void _editField(String title, String currentValue, Function(String) onSave) {
    final TextEditingController controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit $title"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Enter new $title",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // New method to handle password change
  void _editPassword(String currentPassword) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Input for old password
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Current Password",
                ),
              ),
              const SizedBox(height: 10),
              // Input for new password
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "New Password",
                ),
              ),
              const SizedBox(height: 10),
              // Input for confirming the new password
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirm New Password",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Validating the password change
                final oldPassword = oldPasswordController.text;
                final newPassword = newPasswordController.text;
                final confirmPassword = confirmPasswordController.text;

                if (oldPassword != currentPassword) {
                  _showSnackbar("Incorrect current password.", Colors.red);
                } else if (newPassword.isEmpty || newPassword.length < 8) {
                  _showSnackbar(
                      "Password must be at least 8 characters.", Colors.red);
                } else if (newPassword != confirmPassword) {
                  _showSnackbar("Passwords do not match.", Colors.red);
                } else if (newPassword == currentPassword) {
                  _showSnackbar(
                      "New password cannot be the same as the old password.",
                      Colors.red);
                } else {
                  setState(() {
                    password = newPassword; // Save new password
                  });
                  Navigator.of(context).pop();
                  _showSnackbar("Password updated successfully.", Colors.green);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const appBarColor = Colors.blue;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text(
          "My Account",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to DashboardPage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          },
        ),
      ),
      body: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with rounded bottom container for profile photo
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.20,
                decoration: BoxDecoration(
                  color: appBarColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showImagePickerOptions(context);
                      },
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage: _profileImage != null
                            ? FileImage(File(_profileImage!.path))
                            : const AssetImage('default_profile.jpg')
                                as ImageProvider,
                        child: _profileImage == null
                            ? const Icon(Icons.camera_alt,
                                size: 40, color: Colors.grey)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Details
              _buildProfileDetail("Username", username, () {
                _editField("Username", username,
                    (val) => setState(() => username = val));
              }),
              _buildProfileDetail("Password", password, () {
                _editPassword(password); // Call the method to edit password
              }),
              _buildProfileDetail("Phone Number", phoneNumber, () {
                _editField("Phone Number", phoneNumber,
                    (val) => setState(() => phoneNumber = val));
              }),
              _buildProfileDetail("Address", address, () {
                _editField(
                    "Address", address, (val) => setState(() => address = val));
              }),

              const SizedBox(height: 20),

              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _showSnackbar(
                            "Changes saved successfully!", Colors.green);
                      },
                      icon: const Icon(Icons.save),
                      label: const Text("Save Changes"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        _showSnackbar("Account deleted (mock).", Colors.red);
                      },
                      icon: const Icon(Icons.delete_forever),
                      label: const Text("Delete Account"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String title, String value, VoidCallback onEdit) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.edit, color: Colors.grey),
        onTap: onEdit,
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take a Photo"),
                onTap: () {
                  Navigator.of(context).pop();
                  _takePhoto();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
