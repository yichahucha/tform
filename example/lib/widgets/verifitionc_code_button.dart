import 'dart:async';

import 'package:flutter/material.dart';

///验证码按钮
class VerifitionCodeButton extends StatefulWidget {
  VerifitionCodeButton({Key key, this.onPressed, this.seconds, this.title})
      : super(key: key);

  final void Function() onPressed;
  final int seconds;
  final String title;

  @override
  _VerifitionCodeButtonState createState() => _VerifitionCodeButtonState();
}

class _VerifitionCodeButtonState extends State<VerifitionCodeButton> {
  Timer timer;
  var text;
  var seconds;

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    text = widget.title;
    seconds = widget.seconds;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          if (timer == null) {
            if (widget.onPressed != null) widget.onPressed();
            timer = Timer.periodic(Duration(seconds: 1), (_) {
              seconds--;
              if (seconds == 0) {
                text = widget.title;
                seconds = widget.seconds;
                timer.cancel();
                timer = null;
              } else {
                text = seconds.toString() + "s";
              }
              setState(() {});
            });
          }
        },
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .button
              .copyWith(color: Theme.of(context).primaryColor),
        ));
  }
}
