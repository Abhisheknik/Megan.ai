import 'package:ai_app/views/pages/eassy_ai/application_home_page.dart';
import 'package:ai_app/views/pages/eassy_ai/assignment_home_page.dart';
import 'package:ai_app/views/pages/eassy_ai/essay_home_page.dart';
import 'package:ai_app/views/pages/eassy_ai/latter_home_page.dart';
import 'package:flutter/material.dart';

import 'widgets/appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        key: _scaffoldKey,
        appBar: CustomAppBar(
          scaffoldKey: _scaffoldKey,
          onProfilePressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(16),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: <Widget>[
            _createTile('Essay', Icons.home, context, const EssayMyHomePage()),
            _createTile(
                'Letter', Icons.email, context, const LatterMyHomePage()),
            _createTile('Application', Icons.apps, context,
                const ApplicationMyHomePage()),
            _createTile('Assignment', Icons.assignment, context,
                const AssignmentMyHomePage()),
          ],
        ),
      ),
    );
  }

  Widget _createTile(
      String title, IconData icon, BuildContext context, Widget destination) {
    return Card(
      color: Colors.deepPurple,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => destination,
          ));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 50.0, color: Colors.white),
            Text(title, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
