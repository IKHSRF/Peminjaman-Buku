import 'package:book_store/common/utils.dart';
import 'package:book_store/providers/book_provider.dart';
import 'package:book_store/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final idBuku = ModalRoute.of(context)!.settings.arguments.toString();
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('book').doc(idBuku).get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  color: color1,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child: Image.network(
                            snapshot.data['image'],
                            height: 200,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 30,
                        left: 20,
                        child: InkWell(
                          onTap: () {
                            Navigator.popAndPushNamed(context, '/home');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 24.0, right: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data['title'],
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Text(
                          snapshot.data['detail'],
                          overflow: TextOverflow.fade,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                FutureBuilder(
                  future: Auth.getUserRole(
                    FirebaseAuth.instance.currentUser!.uid,
                  ),
                  builder: (context, AsyncSnapshot userRole) {
                    if (!userRole.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (userRole.data['role'] == "Petugas") {
                      return Container();
                    }
                    return Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          bookProvider.pinjamBuku(context, idBuku);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.0,
                            vertical: 8.0,
                          ),
                          child: Text(
                            "Pinjam Buku",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
