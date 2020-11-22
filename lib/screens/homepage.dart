import 'package:flutter/material.dart';
import 'package:twitterverse/screens/timeline.dart';
import 'package:twitterverse/screens/webview.dart';

import 'miniapps.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var imageUrl =
      "https://pbs.twimg.com/profile_images/1289028088173432832/0WOMdOw9_400x400.jpg";

  int curIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
        ),
        centerTitle: true,
        title: ImageIcon(
          AssetImage("images/twitter.png"),
          size: 45,
          color: Colors.lightBlue,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.bubble_chart_outlined,
              size: 25,
              color: Colors.lightBlue,
            ),
          )
        ],
      ),
      body: Center(
        child: curIdx == 3 ? MiniAppsScreen() : Timeline(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => CustomView("https://nytimes.com")));
        },
        tooltip: 'Increment',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.apps_rounded),
          label: 'multiverse',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.mail),
          label: 'DM',
        ),
      ],
      currentIndex: curIdx,
      selectedItemColor: Colors.lightBlue,
      onTap: (idx) {
        setState(() {
          curIdx = idx;
        });
      },
    );
  }
}
