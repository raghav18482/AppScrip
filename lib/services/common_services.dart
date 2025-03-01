import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommonServices{
  final baseurl = 'https://reqres.in/';

  static showToast(msg, color) => Fluttertoast.showToast(
      msg: msg, gravity: ToastGravity.BOTTOM, backgroundColor: color);

  Widget iconLink(wIcon, label) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Row(
        children: [
          Icon(
            wIcon,
            size: 23,
          ),
          const SizedBox(width: 15),
          Text(
            label,
          )
        ],
      ),
    );
  }

}