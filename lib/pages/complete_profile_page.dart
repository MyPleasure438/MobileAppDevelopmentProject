import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pages.dart';

class CompleteProfilePage extends StatefulWidget {
  final User user;
  const CompleteProfilePage({super.key, required this.user});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection("users")
          .doc(widget.user.uid)
          .update({
        "name": _nameController.text,
        "phone": _phoneController.text,
        "profileComplete": true, // 🚨 Mark as complete
      });

      // After saving → go back to AuthGate, it will route properly
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AuthGate()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Your Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (value) =>
                value == null || value.isEmpty ? "Enter your name" : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                validator: (value) =>
                value == null || value.isEmpty ? "Enter your phone number" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}