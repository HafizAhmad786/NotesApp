import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<Map<dynamic,dynamic>> login(Map<String, dynamic> data) async {
    try {
      var response = await auth.signInWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );
      if (response.user != null) {
        return {"status" : true,"uid": response.user!.uid};
      }

      return {"status" : false,"message" : "something went wrong"};
    } on FirebaseAuthException catch (e) {
      return {"status" : false,"message": e.message!};
    }
  }

  Future<Map<dynamic,dynamic>> registerUser(Map<String, dynamic> data) async {
    try {
      var user = await auth.createUserWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );
      data.addAll({"id": user.user!.uid});
      await fireStore.collection("users").add(data);
      return {"status" : true};
    } on FirebaseAuthException catch (e) {
      return {"status" : false,"message": e.message!};
    }
  }

}
