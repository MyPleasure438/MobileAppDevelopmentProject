class CurrentUser {
  static final CurrentUser _instance = CurrentUser._internal();
  factory CurrentUser() => _instance;
  CurrentUser._internal();

  String? uid;
  String? userID;
  String? name;
  String? email;
  String? phone;
  String? role;
  String? status;
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
