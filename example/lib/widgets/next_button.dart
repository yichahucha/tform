import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  const NextButton({Key key, this.title, this.onPressed, this.margin})
      : super(key: key);

  final title;
  final VoidCallback onPressed;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
      width: double.infinity,
      height: 44,
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(44 / 2.0)),
        color: Theme.of(context).primaryColor,
        child: Text(
          title,
          style:
              Theme.of(context).textTheme.button.copyWith(color: Colors.white),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
