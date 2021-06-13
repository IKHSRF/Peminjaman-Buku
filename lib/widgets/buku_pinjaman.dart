import 'package:book_store/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BukuPinjaman extends StatelessWidget {
  final snapshot;
  final int index;
  final idPinjam;
  BukuPinjaman({
    required this.snapshot,
    required this.index,
    required this.idPinjam,
  });
  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    return InkWell(
      onTap: () {},
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
                  snapshot.data['image'],
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
                      snapshot.data['title'],
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
                  // Jika rolenya bukan petugas, maka tombol delete hilang
                  IconButton(
                    onPressed: () {
                      bookProvider.removeBukuPinjaman(idPinjam, context);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
