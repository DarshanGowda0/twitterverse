import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:twitterverse/screens/webview.dart';
import 'package:twitterverse/utils/constants.dart';
import 'package:twitterverse/utils/secret.dart';

class MiniAppsScreen extends StatefulWidget {
  @override
  _MiniAppsScreenState createState() => _MiniAppsScreenState();
}

class _MiniAppsScreenState extends State<MiniAppsScreen> {
  SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(
          crossAxisCount: 3,
          children: MINI_APPS.map((app) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      type: MaterialType.card,
                      elevation: 2,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) =>
                                      CustomView(app['contentUrl'])));
                        },
                        child: Container(
                          color: Colors.grey.withOpacity(.1),
                          height: 80,
                          width: 80,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Image.network(
                                  app['imageUrl'],
                                  height: 80,
                                  width: 80,
                                ),
                              )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        app['name'],
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
            );
          }).toList()),
    );
  }

  checkSquareSetUp() async {
    prefs = await SharedPreferences.getInstance();

    bool isSetUp = prefs.getBool("SQUARE") ?? false;
    // isSetUp = false;
    if (!isSetUp) {
      await InAppPayments.setSquareApplicationId(SQUARE_APP_ID);
      _onStartCardEntryFlow();
    } else {}
  }

  Future<void> _onStartCardEntryFlow() async {
    await InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess,
        onCardEntryCancel: _onCancelCardEntryFlow);
  }

  void _onCancelCardEntryFlow() {
    // Handle the cancel callback
  }

  void _onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    try {
      print("_onCardEntryCardNonceRequestSuccess");
      InAppPayments.completeCardEntry(
          onCardEntryComplete: _onCardEntryComplete);
    } on Exception catch (ex) {
      // payment failed to complete due to error
      // notify card entry to show processing error
      print(ex);
      InAppPayments.showCardNonceProcessingError("Some Error");
    }
  }

  void _onCardEntryComplete() {
    // Update UI to notify user that the payment flow is finished successfully
    print("_onCardEntryComplete");
    final snackBar = SnackBar(
      content: Text('You payment details have been setup!'),
    );
    Scaffold.of(context).showSnackBar(snackBar);
    prefs.setBool("SQUARE", true);
  }

  @override
  void initState() {
    checkSquareSetUp();
  }
}
