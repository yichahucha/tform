import 'package:flutter/material.dart';

const TFormRowTypeInput = "TFormRowTypeInput";
const TFormRowTypeSelector = "TFormRowTypeSelector";
const TFormRowTypeMultipleSelector = "TFormRowTypeMultipleSelector";
const TFormRowTypeCustomSelector = "TFormRowTypeCustomSelector";

class TFormRow {
  /// 唯一标识
  String tag;

  /// 类型（目前内置单选、多选、输入类型）
  String type;

  bool required;
  bool requireStar;
  String requireMsg;
  bool Function(TFormRow) validator;

  String value;
  String title;
  String placeholder;
  int maxLength;
  double height;
  bool enabled;
  Widget suffixWidget;

  List options;
  bool animation;

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

  TFormRow(
      {this.tag,
      this.type = TFormRowTypeInput,
      this.widgetBuilder,
      this.suffixWidget,
      this.widget,
      this.state,
      this.maxLength,
      this.title = "",
      this.value = "",
      this.height = 58.0,
      this.required = true,
      this.requireStar = false,
      this.enabled = true,
      this.placeholder = "",
      this.requireMsg,
      this.options,
      this.onChanged,
      this.onTap,
      this.validator});

  /// 输入
  TFormRow.input({
    this.tag,
    this.title = "",
    this.value = "",
    this.placeholder = "请输入",
    this.height = 58.0,
    this.required = true,
    this.requireStar = false,
    this.enabled = true,
    this.requireMsg,
    this.onChanged,
    this.validator,
    this.suffixWidget,
    this.maxLength,
  }) {
    this.type = TFormRowTypeInput;
  }

  /// 单选
  TFormRow.selector(
      {this.tag,
      this.title = "",
      this.value = "",
      this.placeholder = "请选择",
      this.height = 58.0,
      this.required = true,
      this.requireStar = false,
      this.enabled = true,
      this.requireMsg,
      this.options,
      this.validator}) {
    this.type = TFormRowTypeSelector;
  }

  /// 多选
  TFormRow.multipleSelector(
      {this.tag,
      this.title = "",
      this.value = "",
      this.placeholder = "请选择",
      this.height = 58.0,
      this.required = true,
      this.requireStar = false,
      this.enabled = true,
      this.requireMsg,
      this.options,
      this.validator}) {
    this.type = TFormRowTypeMultipleSelector;
  }

  /// 自定义选择器，配合 state 定义自己的数据 onTap 点击事件
  TFormRow.customSelector(
      {this.tag,
      this.state,
      this.title = "",
      this.value = "",
      this.placeholder = "请选择",
      this.height = 58.0,
      this.required = true,
      this.requireStar = false,
      this.enabled = true,
      this.requireMsg,
      this.options,
      this.onTap,
      this.validator}) {
    this.type = TFormRowTypeCustomSelector;
  }

  // 自定义无状态 cell
  TFormRow.customCell({
    this.tag,
    this.widget,
    this.required = false,
  });

  // 自定义有状态的 cell 配合 state 属性使用
  TFormRow.customCellBuilder({
    this.tag,
    this.state,
    this.widgetBuilder,
    this.required = true,
    this.requireMsg,
    this.validator,
  });
}
