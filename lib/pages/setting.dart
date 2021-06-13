import 'package:book_store/providers/book_provider.dart';
import 'package:book_store/widgets/custom_app_bar.dart';
import 'package:book_store/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();
    final noteProvider = Provider.of<BookProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBarDrawer(
          title: "Setting",
          drawerKey: _drawerKey,
        ),
        key: _drawerKey,
        drawer: CustomDrawer(),
        body: Container(
          color: Colors.red,
          margin: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 40.0,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  "Warna Tema Aplikasi",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                child: Text("Light", style: TextStyle(color: Colors.white)),
              ),
              Expanded(
                child: Switch(
                  value: noteProvider.isDark,
                  onChanged: (value) {
                    noteProvider.isDark = value;
                  },
                ),
              ),
              Expanded(
                child: Text("Dark", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Setting extends StatelessWidget {
  const Setting({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        color: Color(0xFFF5F6F9),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          margin: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
