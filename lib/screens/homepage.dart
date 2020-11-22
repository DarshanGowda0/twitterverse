import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitterverse/models/tweet.dart';
import 'package:twitterverse/utils/service.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var imageUrl =
      "https://pbs.twimg.com/profile_images/1289028088173432832/0WOMdOw9_400x400.jpg";

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
        child: Timeline(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
      currentIndex: 0,
      selectedItemColor: Colors.lightBlue,
      onTap: (idx) {},
    );
  }
}

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  static const String _lorenIpsum =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec iaculis orci vel tempor dignissim. Praesent nisl neque, iaculis et euismod ut, dignissim non arcu. In vel convallis mauris, a viverra turpis. Curabitur ac erat pulvinar, mattis nisl eu, placerat risus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Duis cursus, nisi eu molestie vulputate, libero tellus convallis purus, id cursus sapien orci at velit. Duis placerat et massa et molestie. Quisque id elit blandit, tempor nulla non, faucibus ex. Pellentesque elementum cursus neque, vitae ultricies massa molestie nec. Morbi a eros finibus, sagittis mi eget, gravida.';

  List<Tweet> allTweets = [];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(8),
      itemCount: allTweets.length,
      itemBuilder: (BuildContext context, int index) {
        Tweet tweet = allTweets[index];
        return Container(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(tweet.userImageUrl),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleRow(tweet),
                      tweetBody(tweet),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
      separatorBuilder: (_, idx) => Divider(),
    );
  }

  Container tweetBody(Tweet tweet) {
    return Container(
      child: Text(
        tweet.tweetBody,
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
        style:
            TextStyle(fontFamily: 'OpenSans', fontSize: 14),
      ),
    );
  }

  Row titleRow(Tweet tweet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          tweet.name,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Roboto'),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            "@${tweet.screenName}",
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            "⚬",
            textAlign: TextAlign.justify,
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
          ),
        ),
        Text(
          tweet.time,
          style: TextStyle(color: Colors.black.withOpacity(0.6)),
        ),
        Spacer(),
        FaIcon(
          FontAwesomeIcons.ellipsisH,
          size: 12,
        ),
      ],
    );
  }

  @override
  void initState() {
    _fetchData();
  }

  void _fetchData() async {
    String url = "https://api.twitter.com/1.1/search/tweets.json";
    String query = "from:washingtonpost&count=10&has=links";
    var data = await ApiService.getAllTweets("$url?q=$query");
    var listOfTweets = data['statuses'];
    allTweets.clear();
    for (var tweetData in listOfTweets) {
      Tweet tweet = Tweet.from(tweetData);
      allTweets.add(tweet);
    }
    setState(() {});
  }
}
