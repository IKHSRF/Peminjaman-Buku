import 'package:book_store/pages/about.dart';
import 'package:book_store/pages/add_book.dart';
import 'package:book_store/pages/detail.dart';
import 'package:book_store/pages/edit_book.dart';
import 'package:book_store/pages/home.dart';
import 'package:book_store/pages/login.dart';
import 'package:book_store/pages/pinjam.dart';
import 'package:book_store/pages/profile.dart';
import 'package:book_store/pages/register.dart';
import 'package:book_store/pages/setting.dart';
import 'package:book_store/providers/book_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookProvider(),
      child: Consumer<BookProvider>(
        builder: (context, setting, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: setting.brigthness,
          ),
          initialRoute: '/',
          routes: {
            '/': (_) => LoginPage(),
            '/register': (_) => RegisterPage(),
            '/home': (_) => HomePage(),
            '/about': (_) => AboutPage(),
            '/add': (_) => AddBookPage(),
            '/detail': (_) => DetailsPage(),
            '/profile': (_) => ProfilePage(),
            '/edit': (_) => EditBookPage(),
            '/setting': (_) => SettingPage(),
            '/pinjam': (_) => PinjamPage(),
          },
        ),
      ),
    );
  }
}
