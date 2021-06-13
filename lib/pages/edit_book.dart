import 'package:book_store/providers/book_provider.dart';
import 'package:book_store/services/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditBookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('book')
                .doc(ModalRoute.of(context)!.settings.arguments.toString())
                .get(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              bookProvider.image = snapshot.data['image'];
              return SizedBox.expand(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Container(
                        color: Colors.grey.shade300,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Stack(
                          children: <Widget>[
                            InkWell(
                              onTap: () async {
                                bookProvider.image =
                                    await StorageServices.getImage(context);
                              },
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  child: Image.network(
                                    bookProvider.image,
                                    height: 150,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 30,
                              left: 20,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
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
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                  hintText: snapshot.data['title']),
                              onChanged: (value) {
                                bookProvider.title = value;
                              },
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            TextField(
                              maxLines: 20,
                              onChanged: (value) {
                                bookProvider.detail = value;
                              },
                              decoration: InputDecoration(
                                  hintText: snapshot.data['detail']),
                            ),
                            SizedBox(height: 20.0),
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () {
                                  bookProvider.updateBook(
                                    snapshot.data.id,
                                    context,
                                    snapshot.data,
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.blue),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 60.0,
                                    vertical: 8.0,
                                  ),
                                  child: Text(
                                    "Save",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
