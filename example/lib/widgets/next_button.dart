import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  const NextButton({Key key, this.title, this.onPressed, this.margin})
      : super(key: key);

  final title;
  final VoidCallback onPressed;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(double.infinity, 44)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(44 / 2)),
          ),
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).primaryColor)),
      child: Text(
        title,
        style: Theme.of(context).textTheme.button.copyWith(color: Colors.white),
      ),
    );
  }
}
