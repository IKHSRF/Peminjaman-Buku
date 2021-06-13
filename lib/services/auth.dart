import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  FirebaseAuth _auth = FirebaseAuth.instance;

  // Function login,
  // jika berhasil return string 'ok' ke provider
  // jika gagal return message kesalahannya ke provider
  Future<String> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'ok';
    } catch (error) {
      print(error);
      return error.toString();
    }
  }

  // Function register,
  // jika berhasil return string 'ok' ke provider
  // jika gagal return message kesalahannya ke provider

  // setelah berhasil membuat email dan password,
  // lalu sistem secara otomtis membuat document baru berdasarkan uid di collection user
  // dengan role yang sudah dipilih
  Future<String> register(String email, String password, String role) async {
    try {
      User? user = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      // masukan data role ke firebase
      FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        "role": role,
      });

      return 'ok';
    } catch (error) {
      print(error);
      return error.toString();
    }
  }

  // Function get user role
  // function ini berguna untuk mengambil role dari user yang login
  // function static, langsung dipakai tidak melalui provider
  static Future<dynamic> getUserRole(String id) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    return snapshot.data();
  }

  // Function SignOut
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
