import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'form_row.dart';
import 'form_selector_page.dart';

class TFormField extends StatefulWidget {
  final TFormRow row;

  TFormField({Key key, this.row}) : super(key: key);

  @override
  _TFormFieldState createState() => _TFormFieldState();
}

class _TFormFieldState extends State<TFormField> {
  final TextEditingController _controller = TextEditingController();

  bool get isSelector =>
      widget.row.type == TFormRowTypeSelector ||
      widget.row.type == TFormRowTypeMultipleSelector ||
      widget.row.type == TFormRowTypeCustomSelector;

  TFormRow get row => widget.row;

  @override
  Widget build(BuildContext context) {
    _controller.text = row.value;
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
      height: row.height,
      child: Row(
        children: [
          RichText(
              text: TextSpan(
            text: row.title,
            style: TextStyle(fontSize: 15, color: Colors.black87),
            children: [
              TextSpan(
                  text: row.required ? row.requireStar ? "*" : "" : "",
                  style: TextStyle(fontSize: 15, color: Colors.red))
            ],
          )),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: CupertinoTextField(
              maxLength: row.maxLength,
              minLines: null,
              controller: _controller,
              placeholderStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: CupertinoColors.placeholderText),
              readOnly: isSelector,
              onChanged: (value) {
                row.value = value;
                if (row.onChanged != null) {
                  row.onChanged(row);
                }
              },
              onTap: () async {
                if (isSelector) {
                  String value = "";
                  switch (widget.row.type) {
                    case TFormRowTypeMultipleSelector:
                    case TFormRowTypeSelector:
                      if (row.options == null && row.options.length == 0)
                        return;
                      value = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LTSelectorPage(
                            title: row.title,
                            options: row.options.map((e) {
                              return LTOptionModel(text: e);
                            }).toList(),
                            isMultipleSelector:
                                row.type == TFormRowTypeMultipleSelector,
                          ),
                        ),
                      );
                      break;
                    case TFormRowTypeCustomSelector:
                      if (row.onTap == null) return;
                      value = await row.onTap(context, row);
                      break;
                    default:
                  }
                  if (value != null && value.length > 0) {
                    row.value = value;
                    setState(() {});
                  }
                }
              },
              enabled: row.enabled,
              textAlign: row.type == TFormRowTypeInput
                  ? TextAlign.left
                  : TextAlign.right,
              style: TextStyle(
                  fontSize: 15,
                  color: row.enabled ? Colors.black87 : Colors.black54),
              clearButtonMode: OverlayVisibilityMode.never,
              decoration: BoxDecoration(),
              placeholder: row.placeholder,
            ),
          ),
          row.suffixWidget != null
              ? row.suffixWidget
              : isSelector
                  ? Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.black38,
                    )
                  : SizedBox.shrink(),
        ],
      ),
    );
  }
}
