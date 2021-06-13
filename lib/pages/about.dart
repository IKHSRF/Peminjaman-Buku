import 'package:book_store/common/utils.dart';
import 'package:book_store/widgets/custom_app_bar.dart';
import 'package:book_store/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
    return SafeArea(
      child: Scaffold(
        key: _drawerKey,
        drawer: CustomDrawer(),
        appBar: AppBarDrawer(
          title: "About",
          drawerKey: _drawerKey,
        ),
        body: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Nama Anggota Tim",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                // Search Box
                Text("Anggota 1"),
                SizedBox(height: 5.0),
                AboutTeam(
                  name: "Muhamad Reza Febrian",
                  fieldColor: Colors.grey.shade300,
                ),
                AboutTeam(
                  name: "065117082",
                  fieldColor: btnColor,
                ),
                SizedBox(height: 30.0),
                Text("Anggota 2"),
                SizedBox(height: 5.0),
                AboutTeam(
                  name: "Nurhidayat ",
                  fieldColor: Colors.grey.shade300,
                ),
                AboutTeam(
                  name: "065118051",
                  fieldColor: btnColor,
                ),
                SizedBox(height: 30.0),
                Text("Anggota 3"),
                SizedBox(height: 5.0),
                AboutTeam(
                  name: "Rini santa novita",
                  fieldColor: Colors.grey.shade300,
                ),
                AboutTeam(
                  name: "065118214",
                  fieldColor: btnColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AboutTeam extends StatelessWidget {
  final String name;
  final Color fieldColor;
  AboutTeam({
    required this.name,
    required this.fieldColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: name,
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
