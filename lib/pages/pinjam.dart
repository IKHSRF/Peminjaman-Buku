import 'package:book_store/common/utils.dart';
import 'package:book_store/providers/book_provider.dart';
import 'package:book_store/widgets/buku_pinjaman.dart';
import 'package:book_store/widgets/custom_app_bar.dart';
import 'package:book_store/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PinjamPage extends StatefulWidget {
  @override
  _PinjamPageState createState() => _PinjamPageState();
}

class _PinjamPageState extends State<PinjamPage> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);

    return SafeArea(
      child: Scaffold(
        key: _drawerKey,
        drawer: CustomDrawer(),
        appBar: AppBarDrawer(
          title: "Buku Pinjaman",
          drawerKey: _drawerKey,
        ),
        body: Container(
          margin: EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Hi, Ini",
                style: TextStyle(color: Colors.grey),
              ),

              Text(
                "Buku Yang Kamu Pinjam",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 40.0),
              // Search Box
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Maaf fitur belum tersedia"),
                            ),
                          );
                        },
                        decoration: InputDecoration(
                          hintText: "Search book..",
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 20),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: btnColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 25,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),

              Container(
                child: StreamBuilder(
                  stream: bookProvider.bukuPinjaman,
                  builder: (context, AsyncSnapshot pinjaman) {
                    if (!pinjaman.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Expanded(
                      child: Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: pinjaman.data.docs.length,
                          itemBuilder: (context, index) {
                            return StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('book')
                                  .doc(pinjaman.data.docs[index]['idBuku'])
                                  .snapshots(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return BukuPinjaman(
                                  snapshot: snapshot,
                                  index: index,
                                  idPinjam: pinjaman.data.docs[index].id,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
