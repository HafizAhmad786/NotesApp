import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes_app/data/services/auth_services.dart';
import 'package:notes_app/data/services/storage_service.dart';
import 'package:notes_app/screens/auth/login_screen.dart';
import 'package:notes_app/screens/note/notes_screen.dart';

class AuthProvider extends ChangeNotifier {
  var authServices = FirebaseAuthServices();
  StorageService storageService = StorageService();
  var name = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();

  bool _loading = false;

  bool get isLoading => _loading;

  bool _showPassword = false;

  bool get isShowing => _showPassword;


  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    _loading = true;
    notifyListeners();

    var isLogin = await authServices.login({
      "email": email,
      "password": password,
    });

    if (isLogin['status']) {
      await storageService.storeUserId(isLogin['uid']);
      Fluttertoast.showToast(msg: "User LoggedIn Successfully");
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NotesScreen()),
        );
      }
    } else {
      Fluttertoast.showToast(msg: isLogin['message']);
    }

    _loading = false;
    notifyListeners();
  }

  void showPassword() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

  Future<void> signUp(BuildContext context,Map<dynamic, String> data) async {
    _loading = true;
    notifyListeners();

    var result = await authServices.registerUser({
      "name": data['name'],
      "email": data['email'],
      "password": data['password'],
    });

    if (result["status"]) {
      Fluttertoast.showToast(msg: "Registration successful!");
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                LoginScreen(),
          ),
        );
      }
    } else {
      Fluttertoast.showToast(msg: result['message']);
      _loading = false;
      notifyListeners();
      return;
    }

    _loading = false;
    notifyListeners();
  }

}
