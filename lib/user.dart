import 'package:flutter/material.dart';
import 'delivery_part.dart';

class User extends ChangeNotifier{
  final List<DeliveryPart> itemList = [];

  int id;
  String name;
//Constructor with initializing formal parameters
  User(this.id, this.name);
  int get userID => id;
  String get userName => name;
  @override
  String toString() {
    return '$id: $name';
  }
}