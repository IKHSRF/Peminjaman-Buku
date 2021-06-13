import 'package:book_store/models/book.dart';
import 'package:book_store/services/auth.dart';
import 'package:book_store/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookProvider with ChangeNotifier {
  // Ini untuk panggil kelas firestore dan juga auth
  final firestore = Firestore();
  final auth = Auth();

  // ini variable yang digunakan dalam aplikasi
  // cara merubahnya dengan menggunakan provider dengan melalui setter
  late String _title = "";
  late String _image =
      "https://firebasestorage.googleapis.com/v0/b/book-store-flutter.appspot.com/o/drawerImage.png?alt=media&token=689b5d69-298c-44cf-917a-2c7d3b573d56";
  late String _detail = "";
  late String _email = "";
  late String _password = "";
  late String _role = "User";
  late bool _isDark = false;

  // getter untuk ambil value dari variable di atas
  // Getter
  bool get isDark => _isDark;
  Brightness get brigthness => (_isDark) ? Brightness.dark : Brightness.light;
  String get title => _title;
  String get image => _image;
  String get detail => _detail;
  String get email => _email;
  String get password => _password;
  String get role => _role;
  Color get color => (_isDark) ? Colors.white : Colors.black;

  // ini stream untuk ambil list buku
  Stream<List<Book>> get getBooks => firestore.getBookList();
  // ini stream untuk ambil list buku pinjaman
  Stream<QuerySnapshot> get bukuPinjaman => firestore.getBukuPinjamanUser();

  // Untuk mengubah nilai variable di atas
  // Setter
  set isDark(bool value) {
    _isDark = value;
    notifyListeners();
  }

  set role(String value) {
    _role = value;
    notifyListeners();
  }

  set title(String value) {
    _title = value;
    notifyListeners();
  }

  set image(String value) {
    _image = value;
    notifyListeners();
  }

  set detail(String value) {
    _detail = value;
    notifyListeners();
  }

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  // Function
  // function login, jika user email dan password kosong, maka akan muncul snackbar ("Data Kosong")
  // jika berhasil di arahkan ke halaman dashboard
  login(BuildContext context) async {
    if (_email == "" || _password == "") {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Ada Data Yang Kosong"),
        ),
      );
    } else {
      var result = await auth.login(_email, _password);
      if (result == 'ok') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Berhasil Login"),
          ),
        );
        return Navigator.popAndPushNamed(context, '/home');
      } else {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result),
          ),
        );
      }
    }
  }

  // function register, jika user email dan password kosong, maka akan muncul snackbar ("Data Kosong")
  // jika ada data yang sama atau password lemah akan muncuk snackbar sesuai dengan kesalahan
  // jika berhasil di arahkan ke halaman dashboard
  register(BuildContext context) async {
    if (_email == "" || _password == "" || _role == "") {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Ada Data Yang Kosong"),
        ),
      );
    } else {
      var result = await auth.register(_email, _password, _role);
      if (result == 'ok') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Berhasil Register"),
          ),
        );
        return Navigator.popAndPushNamed(context, '/home');
      } else {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result),
          ),
        );
      }
    }
  }

  // Function logout, jika ada error akan muncul snackbar
  // jika berhasil langsung diarahkan ke halaman login kembali
  logout(BuildContext context) {
    auth.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Logout Berhasil"),
      ),
    );
    return Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  // Funtion tambah buku, jika ada data yang kosong, maka akan muncul snackbar ("Data ksong"),
  // jika berhasil maka akan diarahkan ke halaman dashboard
  // function ini hanya bisa dijalankan oleh role petugas
  addBook(BuildContext context) async {
    if (_title == "" || _detail == "") {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Ada Data Yang Kosong"),
        ),
      );
    } else {
      var books = Book(title: _title, detail: _detail, image: _image);
      _title = "";
      _detail = "";
      _image = "";

      var result = await firestore.addBook(books);
      if (result == 'ok') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Berhasil Menambahkan Note"),
          ),
        );
        return Navigator.popAndPushNamed(context, '/home');
      } else {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result),
          ),
        );
      }
    }
  }

  // function update buku
  // update buku di dalam database berdasarkan id
  // Jika data tidak diisi, maka data buku tidak akan berubah
  // jika ada kesalahan akan muncul snackbar
  // jika berhasil maka akan diarahkan ke halaman dashboard
  // function ini hanya bisa dijalankan oleh role petugas
  updateBook(
    String id,
    BuildContext context,
    DocumentSnapshot snapshot,
  ) async {
    var books = Book(
      title: _title == "" ? snapshot['title'] : _title,
      detail: _detail == "" ? snapshot['detail'] : _detail,
      image: _image == "" ? snapshot['image'] : _image,
    );
    var result = await firestore.updateBook(id, books);
    if (result == 'ok') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Data berhasil diubah!"),
        ),
      );
      return Navigator.popAndPushNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
        ),
      );
    }
  }

  // Function delete,
  // jika ada kesalahan akan muncul snackbar dengan message kesalahannya
  // jika berhasil muncul snackbar ("Data sudah dihapus") lalu diarahkan ke halaman dashboard
  // function ini hanya bisa dijalankan oleh role petugas
  deleteBook(String id, BuildContext context) async {
    firestore.removeBook(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Data Sudah Dihapus")),
    );
  }

  // Funtion pinjam buku
  // menambahkan data buku ke dalam daftar pinjaman user
  // jika berhasil maka akan diarahkan ke halaman dashboard
  // function ini hanya bisa dijalankan oleh role User
  pinjamBuku(BuildContext context, String idBuku) async {
    var result = await firestore.pinjamBuku(
      FirebaseAuth.instance.currentUser!.uid,
      idBuku,
    );
    if (result == 'ok') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Berhasil Meminjam Buku"),
        ),
      );
      return Navigator.popAndPushNamed(context, '/home');
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
        ),
      );
    }
  }

  // Funtion remove buku pinjaman
  // jika berhasil maka akan diarahkan ke halaman dashboard
  // function ini hanya bisa dijalankan oleh role User
  removeBukuPinjaman(String id, BuildContext context) async {
    firestore.removeBukuPinjaman(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Buku Berhasil Dikembalikan")),
    );
  }
}
