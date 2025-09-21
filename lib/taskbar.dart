
import 'package:flutter/material.dart';
import 'package:practical_assignment_project/pages/delivery_request_page.dart';
import 'package:practical_assignment_project/pages/delivery_status_update.dart';
import 'database/current_user.dart';

import 'pages/pages.dart';


class Taskbar extends StatefulWidget {
  const Taskbar({super.key});

  @override
  State<Taskbar> createState() => _TaskbarState();
}

class _TaskbarState extends State<Taskbar> {
  int _currentIndex = 0;
  String userId = CurrentUser().userID;

  // 🔹 Put your pages here
  late List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    _pages = [
      SecondPage(), // your delivery schedule view
      DeliveryRequestPage(userId: userId),
      DeliveryUpdatePage(userId: userId),
      //ProfilePage(userId: userId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: "Deliveries"),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: "Requests"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Confirm"),
        ],
      ),
    );
  }
}

 */