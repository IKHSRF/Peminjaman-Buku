import 'package:book_store/models/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Firestore {
  CollectionReference book = FirebaseFirestore.instance.collection('book');
  CollectionReference pinjam = FirebaseFirestore.instance.collection('pinjam');

  // Stream untuk ambil list buku dari database
  // lalu di masukan ke model untuk diolah datanya
  Stream<List<Book>> getBookList() => book.snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList(),
      );

  // funtion add buku
  // menggunakan model buku sebagai parameternya
  // Jika berhasil return string "ok",
  // Jika gagal return message errornya
  // hasil return di oleh di provider
  Future<String> addBook(Book books) async {
    try {
      await book.add(books.toFirestore());
      return 'ok';
    } catch (error) {
      print(error);
      return error.toString();
    }
  }

  // funtion update buku
  // menggunakan model buku, dan juga id dari buku sebagai parameternya
  // Jika berhasil return string "ok",
  // Jika gagal return message errornya
  // hasil return di oleh di provider
  Future<String> updateBook(String id, Book books) async {
    try {
      await book.doc(id).set(books.toFirestore(), SetOptions(merge: true));
      return 'ok';
    } catch (error) {
      print(error);
      return error.toString();
    }
  }

  // funtion remove buku
  // menghapus data buku dari database
  // menggunakan String id dari buku sebagai parameternya
  // Jika berhasil return string "ok",
  // Jika gagal return message errornya
  // hasil return di oleh di provider
  Future<String> removeBook(String id) async {
    try {
      await book.doc(id).delete();
      return 'ok';
    } catch (error) {
      print(error);
      return error.toString();
    }
  }

  // funtion remove buku pinjaman
  // menghapus data buku pinjaman dari database
  // menggunakan String id dari pinjaman sebagai parameternya
  // Jika berhasil return string "ok",
  // Jika gagal return message errornya
  // hasil return di oleh di provider
  Future<String> removeBukuPinjaman(String id) async {
    try {
      await pinjam.doc(id).delete();
      return 'ok';
    } catch (error) {
      print(error);
      return error.toString();
    }
  }

  // funtion pinjam buku
  // menggunakan String idBuku dari buku dan string Id dari user sebagai parameternya
  // masukan buku ke dalam collection pinjam dengan nama document berasal dari gabungan id user dan id buku
  // Jika berhasil return string "ok",
  // Jika gagal return message errornya
  // hasil return di oleh di provider
  Future<String> pinjamBuku(String id, String idBuku) async {
    try {
      await pinjam.doc('$id$idBuku').set({
        "idBuku": idBuku,
        "idUser": id,
      });
      return 'ok';
    } catch (error) {
      return error.toString();
    }
  }

  Stream<QuerySnapshot> getBukuPinjamanUser() {
    var result = pinjam
        .where('idUser', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return result;
  }
}
