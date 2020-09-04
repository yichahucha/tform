import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const TFormRowTypeInput = "TFormRowTypeInput";
const TFormRowTypeCustomSelector = "TFormRowTypeCustomSelector";
const TFormRowTypeSelector = "TFormRowTypeSelector";
const TFormRowTypeMultipleSelector = "TFormRowTypeMultipleSelector";

abstract class TFormCloneable<T extends TFormCloneable<T>> {
  T clone();
}

class TFormRow implements TFormCloneable<TFormRow> {
  /// 唯一标识
  String tag;

  /// 类型
  String type;

  /// 是否必填
  bool require;

  /// 必填项是否显示 * 号
  bool requireStar;

  /// 必填项校验不通过提示
  String requireMsg;

  /// 自定义校验规则
  bool Function(TFormRow) validator;

  /// 选择类型或者输入类型的值
  String value;

  /// 标题
  String title;

  /// 输入框占位
  String placeholder;

  /// 是否能编辑
  bool enabled;

  /// 输入框长度限制
  int maxLength;

  /// 输入框内容是否加密
  bool obscureText;

  /// 键盘类型
  TextInputType keyboardType;

  /// 清除按钮显示模式
  OverlayVisibilityMode clearButtonMode;

  /// 输入框文字对齐方式
  TextAlign textAlign;

  /// 选择类型的选项，可以是纯字符串，也可以是 TFormOptionModel 对象
  List options;

  /// textfield 样式配置
  TFormFieldConfig fieldConfig;

  /// 输入事件
  void Function(TFormRow) onChanged;

  /// 点击事件
  Future Function(BuildContext, TFormRow) onTap;

  /// 自定义 Cell
  Widget widget;

  /// 通过 builder 的方式自定义 suffixWidget
  Widget Function(BuildContext, TFormRow) suffixWidget;

  /// 通过 builder 的方式自定义 Cell
  Widget Function(BuildContext, TFormRow) widgetBuilder;

  ///自定义 widget 对应的 state
  var state;

  /// 标记插入删除操作是否显示动画
  bool animation;

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
    this.keyboardType,
    this.clearButtonMode = OverlayVisibilityMode.editing,
    this.obscureText,
    this.textAlign = TextAlign.right,
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
    this.keyboardType,
    this.clearButtonMode = OverlayVisibilityMode.editing,
    this.obscureText,
    this.state,
    this.textAlign = TextAlign.left,
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
    this.suffixWidget,
    this.textAlign = TextAlign.right,
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
    this.suffixWidget,
    this.textAlign = TextAlign.right,
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
    this.suffixWidget,
    this.textAlign = TextAlign.right,
  }) {
    this.type = TFormRowTypeCustomSelector;
  }

  // 自定义无状态 cell
  TFormRow.customCell({
    this.tag,
    this.title = "",
    this.widget,
    this.require = false,
  });

  // 自定义有状态的 cell 配合 state 使用
  TFormRow.customCellBuilder({
    this.tag,
    this.state,
    this.title = "",
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
      ..fieldConfig = fieldConfig
      ..keyboardType = keyboardType
      ..clearButtonMode = clearButtonMode
      ..obscureText = obscureText
      ..textAlign = textAlign;
  }
}

class TFormFieldConfig {
  double height;
  EdgeInsets padding;
  TextStyle titleStyle;
  TextStyle valueStyle;
  TextStyle placeholderStyle;
  Divider divider;
  Widget selectorIcon;
  Color disableColor;

  TFormFieldConfig({
    this.height,
    this.padding,
    this.titleStyle,
    this.valueStyle,
    this.placeholderStyle,
    this.divider,
    this.selectorIcon,
    this.disableColor,
  });
}
