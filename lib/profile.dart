import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blaundry_registlogin/welcome.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String email = "";
  String username = "";
  String phoneNumber = "";
  String address = "";
  String password = "";
  bool _isLoading = true;
  bool _isPasswordVisible = false;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late String userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    userId = user.uid;

    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        setState(() {
          email = user.email!;
          username = userDoc.get('name') ?? "";
          phoneNumber = userDoc.get('phone') ?? "";
          address = userDoc.get('address') ?? "";
          password = userDoc.get('password') ?? "";
          _isLoading = false;
        });
      }
    } catch (e) {
      _showSnackbar("Error loading profile data", Colors.red);
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateUserData(String field, String value) async {
    try {
      await _firestore.collection('users').doc(userId).update({field: value});
      setState(() {
        if (field == "email") email = value;
        if (field == "name") username = value;
        if (field == "phone") phoneNumber = value;
        if (field == "address") address = value;
        if (field == "password") password = value;
      });
      _showSnackbar("$field updated successfully", Colors.green);
    } catch (e) {
      _showSnackbar("Failed to update $field", Colors.red);
    }
  }

  void _editField(String title, String currentValue, String fieldKey) {
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
            child: const Text("Cancel", style: TextStyle(color: Colors.blue)),
          ),
          ElevatedButton(
            onPressed: () {
              _updateUserData(fieldKey, controller.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _editPassword() {
    final newController = TextEditingController();
    final confirmController = TextEditingController();
    final oldController = TextEditingController();

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
            child: const Text("Cancel", style: TextStyle(color: Colors.blue)),
          ),
          ElevatedButton(
            onPressed: () => _updatePassword(
              oldController.text,
              newController.text,
              confirmController.text,
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  Future<void> _updatePassword(
      String oldPassword, String newPassword, String confirmPassword) async {
    if (newPassword != confirmPassword) {
      _showSnackbar("Passwords do not match", Colors.red);
      return;
    }
    if (newPassword.length < 6) {
      _showSnackbar("Password must be at least 6 characters", Colors.red);
      return;
    }

    try {
      User? user = _auth.currentUser;
      if (user == null) {
        _showSnackbar("User not found", Colors.red);
        return;
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      await _updateUserData("password", newPassword);

      _showSnackbar("Password updated successfully", Colors.green);
      Navigator.pop(context);
    } catch (e) {
      _showSnackbar("Failed to update password: ${e.toString()}", Colors.red);
    }
  }

  Future<void> _deleteUserDocument() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid;

      if (uid == null) {
        _showSnackbar("No user is currently signed in", Colors.red);
        return;
      }

      await _firestore.collection('users').doc(userId).delete();
      await user!.delete();
      _showSnackbar("Profile data deleted successfully", Colors.green);

      setState(() {
        username = "";
        phoneNumber = "";
        address = "";
        password = "";
      });

      // Navigate to WelcomePage and clear navigation stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
        (route) => false,
      );
    } catch (e) {
      _showSnackbar("Failed to delete profile data", Colors.red);
    }
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Profile Data"),
        content: const Text(
          "Are you sure you want to delete your profile data from the database?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.blue)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteUserDocument();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildProfileTile("Username", username, "name"),
                  _buildProfileTile("Email", email, "email"),
                  _buildProfileTile("Phone Number", phoneNumber, "phone"),
                  _buildProfileTile("Address", address, "address"),
                  _buildMaskedTile("Password", password, _isPasswordVisible, () {
                    setState(() => _isPasswordVisible = !_isPasswordVisible);
                  }),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _confirmDeleteAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    icon: const Icon(Icons.delete),
                    label: const Text("Delete Profile Data"),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileTile(String title, String value, String fieldKey) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: const Icon(Icons.edit),
      onTap: () => _editField(title, value, fieldKey),
    );
  }

  Widget _buildMaskedTile(
      String title, String value, bool isVisible, VoidCallback toggleVisibility) {
    return ListTile(
      title: Text(title),
      subtitle: Text(isVisible ? value : "********"),
      trailing: IconButton(
        icon: Icon(
          isVisible ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: toggleVisibility,
      ),
      onTap: () => title == "Password" ? _editPassword() : null,
    );
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }
}
