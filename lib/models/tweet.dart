import 'package:intl/intl.dart';

class Tweet {
  String id;
  String tweetBody;
  String createdAt;
  String userId;
  String name;
  String screenName;
  String userImageUrl;
  int likeCount, retweetCount;
  String url;

  Tweet.data(
      this.id,
      this.tweetBody,
      this.createdAt,
      this.userId,
      this.name,
      this.screenName,
      this.userImageUrl,
      this.likeCount,
      this.retweetCount,
      this.url) {
    this.tweetBody ??= '';
  }

  factory Tweet.from(json) => Tweet.data(
      json['id_str'],
      json['text'],
      json['created_at'],
      json['user']['id_str'],
      json['user']['name'],
      json['user']['screen_name'],
      json['user']['profile_image_url_https'],
      json['favorite_count'],
      json['retweet_count'],
      json['entities']['urls'][0]['url']);

  String get time {
    // Sun Nov 22 01:37:07 +0000 2020
    var postedAt = DateFormat('E MMM d H:m:s y').parse(
        this.createdAt.substring(0, this.createdAt.indexOf("+")) +
            this.createdAt.substring(this.createdAt.length - 4));
    print(postedAt);
    var now = DateTime.now();
    Duration difference = now.difference(postedAt);
    print(difference);
    if (difference.inDays.abs() > 0) {
      return "${difference.inDays.abs()}d";
    }
    if (difference.inHours.abs() > 0) {
      return "${difference.inHours.abs()}h";
    }
    if (difference.inMinutes.abs() > 0) {
      return "${difference.inMinutes.abs()}m";
    }
    if (difference.inSeconds.abs() > 0) {
      return "${difference.inSeconds.abs()}s";
    }
    return "";
  }
}
