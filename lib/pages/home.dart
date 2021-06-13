import 'package:book_store/common/utils.dart';
import 'package:book_store/providers/book_provider.dart';
import 'package:book_store/services/auth.dart';
import 'package:book_store/widgets/book_widget.dart';
import 'package:book_store/widgets/custom_app_bar.dart';
import 'package:book_store/widgets/custom_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart ';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();
    return SafeArea(
      child: FutureBuilder(
          future: Auth.getUserRole(FirebaseAuth.instance.currentUser!.uid),
          builder: (context, AsyncSnapshot userRole) {
            if (!userRole.hasData) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Scaffold(
              key: _drawerKey,
              drawer: CustomDrawer(),
              appBar: AppBarDrawer(
                title: "Home Page",
                drawerKey: _drawerKey,
              ),
              floatingActionButton: (userRole.data['role'] == "Petugas")
                  ? FloatingActionButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/add');
                      },
                      child: Icon(
                        Icons.add,
                      ),
                    )
                  : Container(),
              body: Container(
                margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Hi,",
                      style: TextStyle(color: Colors.grey),
                    ),

                    Text(
                      "Discover Latest Book",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(height: 40.0),
                    // Search Box
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(Radius.circular(10))),
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
                        stream: bookProvider.getBooks,
                        builder: (context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Expanded(
                            child: Container(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return BookWidget(
                                    snapshot: snapshot,
                                    index: index,
                                    role: userRole.data['role'],
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
            );
          }),
    );
  }
}
