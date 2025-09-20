import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'pages.dart'; // <-- you can add DriverPage, UserPage, etc.
import '../database/current_user.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<String> _generateUserID() async {
    final counterRef = FirebaseFirestore.instance.collection('counters').doc('users');

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(counterRef);
      int lastID = snapshot.exists ? snapshot.get('lastID') as int : 0;
      int newID = lastID + 1;

      transaction.update(counterRef, {'lastID': newID});

      return 'u${newID.toString().padLeft(4, '0')}'; // u0001, u0002, etc.
    });
  }

  Future<void> _createUserProfileIfNeeded(User user) async {
    final docRef = FirebaseFirestore.instance.collection("users").doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      final phone = user.phoneNumber;
      final userID = await _generateUserID(); // generate sequential userID

      await docRef.set({
        "userID": userID,               // custom sequential ID
        "name": user.displayName ?? "New User",
        "email": user.email,
        "phone": phone ?? "",
        "role": "driver",
        "status": "available",
        "profileComplete": false,
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }


  Future<Map<String, dynamic>?> _getUserProfile(User user) async {
    final docRef = FirebaseFirestore.instance.collection("users").doc(user.uid);
    final doc = await docRef.get();
    return doc.data();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [EmailAuthProvider()],
            // This is where you add custom input fields
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  _createUserProfileIfNeeded(user); // still create default
                }
              }),
            ],
            // Add custom sign-up fields

          );
        }


        // Logged in
        final user = snapshot.data!;
        _createUserProfileIfNeeded(user); // make sure profile exists

        // Check role & status before routing
        return FutureBuilder<Map<String, dynamic>?>(
          future: _getUserProfile(user),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!profileSnapshot.hasData) {
              // New user → show CompleteProfilePage
              return CompleteProfilePage(user: user);
              //return const Scaffold(
                //body: Center(child: Text("No profile found")),
              //);
            }

            final profile = profileSnapshot.data!;
            CurrentUser().setFromMap(profile, user.uid);
            final role = profile['role'] ?? 'user';
            final status = profile['status'] ?? 'inactive';
            final profileComplete = profile['profileComplete'] ?? false;

            //  If profile is incomplete → force user to CompleteProfilePage
            if (!profileComplete) {
              return CompleteProfilePage(user: user);
            }


            // Route based on role
            if (role == 'driver') {
              return MyFirstPage(); // Replace with DriverPage if you make one
            } else if (role == 'admin') {
              return const Scaffold(
                body: Center(child: Text("Admin Page Placeholder")),
              );
            } else {
              return const Scaffold(
                body: Center(child: Text("User Page Placeholder")),
              );
            }
          },
        );
      },
    );
  }
}
