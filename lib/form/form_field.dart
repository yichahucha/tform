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

  bool get _isSelector =>
      widget.row.type == TFormRowTypeSelector ||
      widget.row.type == TFormRowTypeMultipleSelector ||
      widget.row.type == TFormRowTypeCustomSelector;

  bool get _isInput => widget.row.type == TFormRowTypeInput;

  TFormRow get row => widget.row;
  bool get _enabled => row.enabled ?? true;
  bool get _require => row.require ?? false;
  bool get _requireStar => row.requireStar ?? false;

  TextStyle get _titleStyle {
    return row.fieldConfig?.titleStyle ??
        TextStyle(fontSize: 15, color: Colors.black87);
  }

  TextStyle get _valueStyle {
    return row.fieldConfig?.valueStyle ??
        TextStyle(fontSize: 15, color: Colors.black87);
  }

  Widget get _selectorIcon =>
      row.fieldConfig?.selectorIcon ?? Icon(Icons.keyboard_arrow_right);

  Color get _disableColor => row.fieldConfig?.disableColor ?? Colors.black54;

  @override
  Widget build(BuildContext context) {
    _controller.text = row.value;
    return Column(
      children: [
        Container(
          padding: row.fieldConfig?.padding ??
              const EdgeInsets.fromLTRB(15, 0, 15, 0),
          height: row.fieldConfig?.height ?? 58.0,
          child: Row(
            children: [
              row.title.contains("*") ? _buildTitleText() : _buildRichText(),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: _buildCupertinoTextField(context),
              ),
              row.suffixWidget != null
                  ? row.suffixWidget(context, row)
                  : SizedBox.shrink(),
            ],
          ),
        ),
        row.fieldConfig?.divider ?? SizedBox.shrink()
      ],
    );
  }

  CupertinoTextField _buildCupertinoTextField(BuildContext context) {
    return CupertinoTextField(
      suffix: _isSelector ? _selectorIcon : null,
      obscureText: row.obscureText ?? false,
      controller: _controller,
      clearButtonMode: _isInput && _enabled
          ? row.clearButtonMode ?? OverlayVisibilityMode.never
          : OverlayVisibilityMode.never,
      enabled: _enabled,
      decoration: BoxDecoration(color: Colors.white),
      textAlign: row.textAlign ?? TextAlign.left,
      placeholder: row.placeholder ?? "",
      keyboardType: row.keyboardType,
      maxLength: row.maxLength,
      style:
          !_enabled ? _valueStyle.copyWith(color: _disableColor) : _valueStyle,
      placeholderStyle: row.fieldConfig?.placeholderStyle ??
          const TextStyle(fontSize: 15, color: CupertinoColors.placeholderText),
      readOnly: _isSelector,
      onChanged: (value) {
        row.value = value;
        if (row.onChanged != null) row.onChanged(row);
      },
      onTap: () async {
        if (_isSelector) {
          String value = "";
          switch (widget.row.type) {
            case TFormRowTypeMultipleSelector:
            case TFormRowTypeSelector:
              if (row.options == null || row.options.isEmpty) return;
              value = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TFormSelectorPage(
                    title: row.title,
                    options: row.options
                            .every((element) => (element is TFormOptionModel))
                        ? <TFormOptionModel>[...row.options]
                        : row.options.map((e) {
                            return TFormOptionModel(value: e);
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
          if (value != null) {
            setState(() {
              row.value = value;
            });
          }
          if (row.onChanged != null) row.onChanged(row);
        }
      },
    );
  }

  RichText _buildRichText() {
    return RichText(
        text: TextSpan(
      text: row.title ?? "",
      style:
          !_enabled ? _titleStyle.copyWith(color: _disableColor) : _titleStyle,
      children: [
        TextSpan(
          text: _require
              ? _requireStar
                  ? "*"
                  : ""
              : "",
          style: _titleStyle.copyWith(
              color: _enabled ? Colors.red : _disableColor),
        )
      ],
    ));
  }

  Row _buildTitleText() {
    RegExp re = RegExp(r"\*+|[^\*]+");
    Iterable<Match> matches = re.allMatches(row.title);
    final children = matches.map((e) {
      if (e[0].contains("*")) {
        return Text(
          e[0],
          style: _titleStyle.copyWith(
              color: _enabled ? Colors.red : _disableColor),
        );
      } else {
        return Text(
          e[0],
          style: !_enabled
              ? _titleStyle.copyWith(color: _disableColor)
              : _titleStyle,
        );
      }
    }).toList();
    return Row(children: children);
  }
}
