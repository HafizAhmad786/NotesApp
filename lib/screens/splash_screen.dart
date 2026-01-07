import 'package:flutter/material.dart';
import 'package:notes_app/data/services/storage_service.dart';
import 'package:notes_app/screens/auth/login_screen.dart';
import 'package:notes_app/screens/note/notes_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StorageService storageService = StorageService();

  Future<void> userLoggedIn(BuildContext context) async {
    String userId = await storageService.getUserId();
    Future.delayed(const Duration(seconds: 1),(){
      if (context.mounted && userId.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NotesScreen()),
        );
      }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });

  }

  @override
  void initState() {
    super.initState();
    userLoggedIn(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: FlutterLogo(size: 140,)));
  }
}
