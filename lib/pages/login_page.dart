import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import '../pages/pages.dart';
import '../database/current_user.dart';
class MyFirstPage extends StatelessWidget {
  MyFirstPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Management for Part Delivery Personnel"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
           Padding(
            padding: EdgeInsets.only(top: 20),
            child: SimpleText(
              text: CurrentUser().userID ?? "Guest",
              fontSize: 25,
              textFamily: "Times New Roman",
              isBold: true,
              isItalic: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
            child: SimpleTextField(
              labelText: "Username",
              fontSize: 15,
              textFamily: "Times New Roman",
              isBold: true,
              isItalic: false,
              inputKeyboardType: "n",
              controller: usernameController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
            child: SimpleTextField(
              labelText: "Password",
              fontSize: 15,
              textFamily: "Times New Roman",
              isBold: true,
              isItalic: false,
              inputKeyboardType: "n",
              controller: passwordController,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondPage()),
              );
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}