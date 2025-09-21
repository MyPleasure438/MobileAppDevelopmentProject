class CurrentUser {
  static final CurrentUser _instance = CurrentUser._internal();
  factory CurrentUser() => _instance;
  CurrentUser._internal();

  late String uid;
  late String userID ;
  late String name ;
  late String email ;
  late String phone ;
  late String role ;
  late String status ;
  bool profileComplete = false;

  void setFromMap(Map<String, dynamic> data, String uid) {
    this.uid = uid;
    userID = data['userID'];
    name = data['name'];
    email = data['email'];
    phone = data['phone'];
    role = data['role'];
    status = data['status'];
    profileComplete = data['profileComplete'] ?? false;
  }
}
