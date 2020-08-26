import 'package:flutter/material.dart';

import 'form.dart';
import 'form_field.dart';
import 'form_row.dart';

class TFormCell extends StatelessWidget {
  const TFormCell({Key key, this.row}) : super(key: key);

  final TFormRow row;

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
    return AbsorbPointer(
        child: widget, absorbing: TForm.of(context).readOnly ?? false);
  }
}
