//Importing the necessary packages
import 'package:flutter/material.dart';

//The entry point of the Flutter application.
void main() {
  //A function that takes a Widget as an argument and renders it on the screen.
  runApp(const MainApp());
}

//Declaring a stateless widget class that does not change its state over time
class MainApp extends StatelessWidget {
  const MainApp({super.key}); //Constructor of this widget

  //The build function is responsible for building the widget's UI
  @override
  Widget build(BuildContext context) {
    //It returns a MaterialApp widget
    return MaterialApp(
      //A basic layout structure consisting an app bar, a body and drawers
      home: Scaffold(
        appBar: AppBar(
          title:const Text('Job Management for Part Delivery Personnel'),
          backgroundColor: Colors.blue,

        ),
        //A layout widget that centres its child within its available space
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                  child:
                  Text('Login',
                  style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),  textAlign: TextAlign.left),
                  ),
          ],

              ),
              const SizedBox(height: 10), // Adds spacing between rows
              Row(
                children: [
                 Expanded(
                  child: TextField(
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  ),
                ],
              ),
              const SizedBox(height: 10), // Adds spacing between rows
              Row(
                children: [
                  Expanded(
                  child: TextField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  ),
                ],
              ),
              const SizedBox(height: 10), // Adds spacing between rows
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: (){},
                    child:const Text('Register for new user'),
                  ),

                ],
              ),
              const SizedBox(height: 10), // Adds spacing between rows
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: (){},
                    child:Text('Login'),
                  ),
                ],
              ),
            ],

          ), //A text widget
        ),
      ),
    );
  }
}

