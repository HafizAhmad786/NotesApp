import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  StorageService._internal();
  static final StorageService _instance = StorageService._internal();

  final storage = FlutterSecureStorage();

  factory StorageService() {
    return _instance;
  }

  Future<void> storeUserId(String uid) async {
    await storage.write(key: "uid", value: uid);
  }

  Future<String> getUserId() async {
    return await storage.read(key: "uid") ?? "";
  }

  Future<void> removeUserId() async{
    await storage.delete(key: "uid");
  }
}
