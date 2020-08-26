import 'package:flutter/material.dart';

import 'form.dart';
import 'form_field.dart';
import 'form_row.dart';

class TFormCell extends StatefulWidget {
  TFormCell({Key key, this.row}) : super(key: key);

  final TFormRow row;

  @override
  _TFormCellState createState() => _TFormCellState();
}

class _TFormCellState extends State<TFormCell> {
  get row => widget.row;

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (row.widget != null) {
      widget = row.widget;
    } else if (row.widgetBuilder != null) {
      widget = row.widgetBuilder(context, row);
    } else {
      widget = TFormField(row: row);
    }
    // readonly
    widget = AbsorbPointer(
        child: widget, absorbing: TForm.of(context).readOnly ?? false);
    // animation
    widget = row.animation ?? false
        ? TweenAnimationBuilder(
            child: widget,
            duration: Duration(milliseconds: 500),
            builder: (BuildContext context, value, Widget child) {
              return Opacity(
                opacity: value,
                child: child,
              );
            },
            tween: Tween(begin: 0.0, end: 1.0),
          )
        : widget;
    return widget;
  }
}
