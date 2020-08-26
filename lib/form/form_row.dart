import 'package:flutter/material.dart';

const TFormRowTypeInput = "TFormRowTypeInput";
const TFormRowTypeSelector = "TFormRowTypeSelector";
const TFormRowTypeMultipleSelector = "TFormRowTypeMultipleSelector";
const TFormRowTypeCustomSelector = "TFormRowTypeCustomSelector";

abstract class TFormCloneable<T extends TFormCloneable<T>> {
  T clone();
}

class TFormRow implements TFormCloneable<TFormRow> {
  String tag;
  String type;

  bool require;
  bool requireStar;
  String requireMsg;
  bool Function(TFormRow) validator;

  String value;
  String title;
  String placeholder;
  int maxLength;
  bool enabled;
  Widget suffixWidget;

  List options;
  bool animation;

  /// config
  TFormFieldConfig fieldConfig;

  /// 输入事件
  void Function(TFormRow) onChanged;

  /// 点击事件
  Future Function(BuildContext, TFormRow) onTap;

  /// 自定义 Cell
  Widget widget;

  /// 通过 builder 的方式自定义 Cell
  Widget Function(BuildContext, TFormRow) widgetBuilder;

  ///自定义 widget 对应的 state
  var state;

  TFormRow({
    this.tag,
    this.type = TFormRowTypeInput,
    this.widgetBuilder,
    this.suffixWidget,
    this.widget,
    this.state,
    this.maxLength,
    this.title = "",
    this.value = "",
    this.require = true,
    this.requireStar = false,
    this.enabled = true,
    this.placeholder = "",
    this.requireMsg,
    this.options,
    this.onChanged,
    this.onTap,
    this.validator,
    this.fieldConfig,
  });

  /// 输入
  TFormRow.input({
    this.tag,
    this.title = "",
    this.value = "",
    this.placeholder = "请输入",
    this.require = true,
    this.requireStar = false,
    this.enabled = true,
    this.requireMsg,
    this.onChanged,
    this.validator,
    this.suffixWidget,
    this.maxLength,
    this.fieldConfig,
  }) {
    this.type = TFormRowTypeInput;
  }

  /// 单选
  TFormRow.selector({
    this.tag,
    this.title = "",
    this.value = "",
    this.placeholder = "请选择",
    this.require = true,
    this.requireStar = false,
    this.enabled = true,
    this.requireMsg,
    this.options,
    this.validator,
    this.fieldConfig,
  }) {
    this.type = TFormRowTypeSelector;
  }

  /// 多选
  TFormRow.multipleSelector({
    this.tag,
    this.title = "",
    this.value = "",
    this.placeholder = "请选择",
    this.require = true,
    this.requireStar = false,
    this.enabled = true,
    this.requireMsg,
    this.options,
    this.validator,
    this.fieldConfig,
  }) {
    this.type = TFormRowTypeMultipleSelector;
  }

  /// 自定义选择器，配合 state 定义自己的数据 onTap 点击事件
  TFormRow.customSelector({
    this.tag,
    this.state,
    this.title = "",
    this.value = "",
    this.placeholder = "请选择",
    this.require = true,
    this.requireStar = false,
    this.enabled = true,
    this.requireMsg,
    this.options,
    this.onTap,
    this.validator,
    this.fieldConfig,
  }) {
    this.type = TFormRowTypeCustomSelector;
  }

  // 自定义无状态 cell
  TFormRow.customCell({
    this.tag,
    this.widget,
    this.require = false,
  });

  // 自定义有状态的 cell 配合 state 属性使用
  TFormRow.customCellBuilder({
    this.tag,
    this.state,
    this.widgetBuilder,
    this.require = true,
    this.requireMsg,
    this.validator,
  });

  @override
  TFormRow clone() {
    return TFormRow()
      ..tag = tag
      ..type = type
      ..widgetBuilder = widgetBuilder
      ..suffixWidget = suffixWidget
      ..widget = widget
      ..state = state
      ..maxLength = maxLength
      ..title = title
      ..value = value
      ..require = require
      ..requireStar = requireStar
      ..enabled = enabled
      ..placeholder = placeholder
      ..requireMsg = requireMsg
      ..options = options
      ..onChanged = onChanged
      ..onTap = onTap
      ..validator = validator
      ..fieldConfig = fieldConfig;
  }
}

class TFormFieldConfig {
  double height;
  EdgeInsets padding;
  TextStyle style;
  TextStyle placeholderStyle;
  Divider divider;

  TFormFieldConfig({
    this.height,
    this.padding,
    this.style,
    this.placeholderStyle,
    this.divider,
  });
}
