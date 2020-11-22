import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitterverse/models/tweet.dart';
import 'package:twitterverse/screens/webview.dart';
import 'package:twitterverse/utils/service.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  static const String _lorenIpsum =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec iaculis orci vel tempor dignissim. Praesent nisl neque, iaculis et euismod ut, dignissim non arcu. In vel convallis mauris, a viverra turpis. Curabitur ac erat pulvinar, mattis nisl eu, placerat risus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Duis cursus, nisi eu molestie vulputate, libero tellus convallis purus, id cursus sapien orci at velit. Duis placerat et massa et molestie. Quisque id elit blandit, tempor nulla non, faucibus ex. Pellentesque elementum cursus neque, vitae ultricies massa molestie nec. Morbi a eros finibus, sagittis mi eget, gravida.';

  List<SuperTweet> superTweets = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: superTweets.length != 0
          ? ListView.separated(
              padding: EdgeInsets.all(8),
              itemCount: superTweets.length,
              itemBuilder: (BuildContext context, int index) {
                SuperTweet stweet = superTweets[index];
                return Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(stweet.tweet.userImageUrl),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              titleRow(stweet.tweet),
                              tweetBody(stweet.tweet),
                              stweet.metaUrl != null && stweet.metaUrl != ""
                                  ? mediaCard(stweet)
                                  : Container(),
                              actionsRow(stweet.tweet),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (_, idx) => Divider(),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Container tweetBody(Tweet tweet) {
    return Container(
      child: Text(
        tweet.tweetBody,
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontFamily: 'OpenSans', fontSize: 14),
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
    String query = "from:washingtonpost&count=5&has=links";
    var data = await ApiService.getAllTweets("$url?q=$query");
    var listOfTweets = data['statuses'];
    List<Tweet> allTweets = [];
    for (var tweetData in listOfTweets) {
      Tweet tweet = Tweet.from(tweetData);
      allTweets.add(tweet);
    }
    print("got API data");
    List responses =
        await Future.wait(allTweets.map((t) => ApiService.getMetaData(t)));
    superTweets = responses.map((res) {
      return new SuperTweet(
          res['tweet'], res['meta']['image'], res['meta']['description']);
    }).toList();
    setState(() {});
  }

  actionsRow(Tweet tweet) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            singleAction(
                FontAwesomeIcons.comment, (tweet.retweetCount - 2).toString()),
            singleAction(FontAwesomeIcons.heart, tweet.likeCount.toString()),
            singleAction(
                FontAwesomeIcons.retweet, tweet.retweetCount.toString()),
            FaIcon(
              FontAwesomeIcons.shareSquare,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  mediaCard(SuperTweet superTweet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(
        //         topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        elevation: 1,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => CustomView(superTweet.tweet.url)));
          },
          child: Column(
            children: [
              Image.network(superTweet.metaUrl),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  superTweet.metaTitle,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  singleAction(IconData icon, String text) {
    return Row(
      children: [
        FaIcon(
          icon,
          size: 14,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3.0),
          child: Text(text),
        ),
      ],
    );
  }
}
