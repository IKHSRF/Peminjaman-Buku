import 'package:book_store/providers/book_provider.dart';
import 'package:book_store/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<BookProvider>(context);
    return Drawer(
      child: FutureBuilder(
          future: Auth.getUserRole(FirebaseAuth.instance.currentUser!.uid),
          builder: (context, AsyncSnapshot userRole) {
            if (!userRole.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://firebasestorage.googleapis.com/v0/b/book-store-flutter.appspot.com/o/drawerImage.png?alt=media&token=689b5d69-298c-44cf-917a-2c7d3b573d56'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Container(),
                ),
                DrawerItem(
                  title: "Dashboard",
                  onTap: () {
                    Navigator.pushNamed(context, '/home');
                  },
                ),
                (userRole.data['role'] == "User")
                    ? DrawerItem(
                        title: "Buku Pinjaman",
                        onTap: () {
                          Navigator.pushNamed(context, '/pinjam');
                        },
                      )
                    : Container(),
                DrawerItem(
                  title: "About",
                  onTap: () {
                    Navigator.pushNamed(context, '/about');
                  },
                ),
                DrawerItem(
                  title: "Profile",
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                DrawerItem(
                  title: "Setting",
                  onTap: () {
                    Navigator.pushNamed(context, '/setting');
                  },
                ),
                DrawerItem(
                  title: "Log Out",
                  onTap: () {
                    noteProvider.logout(context);
                  },
                ),
              ],
            );
          }),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText2,
      ),
      onTap: onTap,
    );
  }
}
