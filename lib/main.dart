//Importing the necessary packages
import 'package:flutter/material.dart';

//The entry point of the Flutter application.
void main() {
  //A function that takes a Widget as an argument and renders it on the screen.
  //runApp(const MainApp());
  runApp(MaterialApp(home: MyFirstPage()));
  //runApp(const MainApp());
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

                  Text('Login',
                      style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),  textAlign: TextAlign.left),

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

class SimpleText extends StatelessWidget {
  const SimpleText({super.key, required this.text, required this.fontSize, required this.textFamily, required this.isBold, required this.isItalic,}); //Constructor of this widget
  final String text;
  final double fontSize;
  final String textFamily;
  final bool isBold;
  final bool isItalic;

  //The build function is responsible for building the widget's UI
  @override
  Widget build(BuildContext context) {
    //It returns a MaterialApp widget
    return Text(text, style: TextStyle(fontSize: fontSize,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        fontFamily: textFamily),
    );
  }
}

class SimpleTextField extends StatefulWidget {
  const SimpleTextField({super.key, required this.labelText, required this.fontSize, required this.textFamily, required this.isBold, required this.isItalic, required this.inputKeyboardType});
  final String labelText;
  final double fontSize;
  final String textFamily;
  final bool isBold;
  final bool isItalic;
  final String inputKeyboardType;


  @override
  State<SimpleTextField> createState() => _SimpleTextFieldState();
}

class _SimpleTextFieldState extends State<SimpleTextField> {
  final textCtrl = TextEditingController();


  String getTextContent(){
    return textCtrl.text;
  }

  double getTextNumbersContent(){
    double textNumbers = double.parse(textCtrl.text);
    return textNumbers;
  }

  @override

  Widget build(BuildContext context) {
    final keyboardType = widget.inputKeyboardType == "n"
        ? TextInputType.number
        : widget.inputKeyboardType == "t"
        ? TextInputType.text
        : null;

    return TextField(controller: textCtrl,decoration: InputDecoration(labelText: widget.labelText,),
    style: TextStyle(fontSize: widget.fontSize,
    fontWeight: widget.isBold ? FontWeight.bold : FontWeight.normal,
    fontStyle: widget.isItalic ? FontStyle.italic : FontStyle.normal,
    fontFamily: widget.textFamily),
      keyboardType: keyboardType,
    );
  }
}



class MyFirstPage extends StatelessWidget {
  final textField1 = GlobalKey<_SimpleTextFieldState>();
  final textField2 = GlobalKey<_SimpleTextFieldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),child: (
            SimpleText(text: "Login Page", fontSize: 25, textFamily: "Times New Roman", isBold: true, isItalic:  true))),

          Padding(
            padding: const EdgeInsets.only(top: 20, left: 16, right: 16),child: (
            SimpleTextField(key: textField1, labelText: "Username", fontSize: 15, textFamily: "Times New Roman", isBold: true, isItalic: false, inputKeyboardType: "n"))),

          Padding(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16),child: (
              SimpleTextField(key: textField2, labelText: "Password", fontSize: 15, textFamily: "Times New Roman", isBold: true, isItalic: false, inputKeyboardType: "n"))),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecondPage()),
              );
            },
            child: const Text('Login'),
          ),
          //FirstStatelessWidget(),
          //SecondStatefulWidget(),
          //ThirdStatelessWidget(),
          //FourthStatefulWidget(),
        ],
      ),
      appBar: AppBar (title: const Text("Job Management for Part Delivery Personnel"), backgroundColor: Colors.blue,),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Second Page")),
      body: const Center(
        child: Text("Welcome to Page 2!"),
      ),
    );
  }
}