import 'package:book_store/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookWidget extends StatelessWidget {
  final snapshot;
  final int index;
  final String role;
  BookWidget({
    required this.snapshot,
    required this.index,
    required this.role,
  });
  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/detail',
          arguments: snapshot.data[index].id,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 100,
                height: 100,
                child: Image.network(
                  snapshot.data[index].image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Judul Buku : ",
                      style:
                          TextStyle(fontSize: 20, color: Colors.grey.shade300),
                    ),
                    Text(
                      snapshot.data[index].title,
                      overflow: TextOverflow.fade,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  // Jika rolenya bukan petugas, maka tombol edit hilang
                  (role == "Petugas")
                      ? IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/edit',
                              arguments: snapshot.data[index].id,
                            );
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        )
                      : Container(),
                  // Jika rolenya bukan petugas, maka tombol hapus hilang
                  (role == "Petugas")
                      ? IconButton(
                          onPressed: () {
                            bookProvider.deleteBook(
                              snapshot.data[index].id,
                              context,
                            );
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
