import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:twitterverse/utils/secret.dart';

class MiniAppsScreen extends StatefulWidget {
  @override
  _MiniAppsScreenState createState() => _MiniAppsScreenState();
}

class _MiniAppsScreenState extends State<MiniAppsScreen> {

  SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  checkSquareSetUp() async {
    prefs = await SharedPreferences.getInstance();

    bool isSetUp = prefs.getBool("SQURE")?? false;
    isSetUp = false;
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
