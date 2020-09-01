import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tform/form/form.dart';

import 'package:tform/tform.dart';

import '../utils.dart';

import 'package:tform_example/widgets/photos_cell.dart';
import 'package:tform_example/widgets/verifitionc_code_button.dart';

class FormPage extends StatelessWidget {
  FormPage({Key key}) : super(key: key);
  final GlobalKey _formKey = GlobalKey<TFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("表单"),
        actions: [
          FlatButton(
            child: Text(
              "提交",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onPressed: () {
              //校验
              List errors = (_formKey.currentState as TFormState).validate();
              if (errors.length > 0) {
                showToast(errors.first);
                return;
              }
              //通过
              showToast("提交成功");
            },
          ),
        ],
      ),
      body: TForm.builder(
        key: _formKey,
        rows: buildFormRows(),
        readOnly: false,
        divider: Divider(
          height: 0.5,
          thickness: 0.5,
        ),
      ),
    );
  }
}

List<TFormRow> buildFormRows() {
  return [
    TFormRow.input(
      enabled: false,
      title: "姓名",
      placeholder: "请输入姓名",
      value: "张二蛋",
      fieldConfig: TFormFieldConfig(
          height: 100, style: TextStyle(color: Colors.red, fontSize: 20)),
    ),
    TFormRow.input(
      title: "身份证号",
      placeholder: "请输入身份证号",
      value: "4101041991892382938293",
      clearButtonMode: OverlayVisibilityMode.editing,
    ),
    TFormRow.input(
      keyboardType: TextInputType.number,
      title: "预留手机号",
      placeholder: "请输入手机号",
      maxLength: 11,
      requireMsg: "请输入正确的手机号",
      requireStar: true,
      validator: (row) {
        return RegExp(
                r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$')
            .hasMatch(row.value);
      },
    ),
    TFormRow.input(
      title: "验证码",
      placeholder: "请输入验证码",
      suffixWidget: (context, row) {
        return VerifitionCodeButton(
          title: "获取验证码",
          seconds: 60,
          onPressed: () {
            showToast("验证码已发送");
          },
        );
      },
    ),
    TFormRow.selector(
      title: "学历",
      placeholder: "请选择",
      options: ["小学", "初中", "高中", "专科", "本科", "硕士及以上"],
    ),
    TFormRow.multipleSelector(
      title: "家庭成员",
      placeholder: "请选择",
      options: ["父亲", "母亲", "女儿", "儿子"],
    ),
    TFormRow.customSelector(
      title: "出生年月",
      placeholder: "请选择",
      onTap: (context, row) async {
        return showPickerDate(context);
      },
    ),
    TFormRow.customCell(
      widget: Container(
          color: Colors.grey[200],
          height: 48,
          width: double.infinity,
          alignment: Alignment.center,
          child: Text("------ 我是自定义的Cell ------")),
    ),
    TFormRow.customCellBuilder(
      title: "房屋照片",
      state: [
        {"picurl": ""},
        {"picurl": ""},
        {"picurl": ""}
      ],
      requireMsg: "请完成上传房屋照片",
      validator: (row) {
        bool suc = (row.state as List)
            .every((element) => (element["picurl"].length > 0));
        if (!suc) {
          row.requireMsg = "请完成${row.title}上传";
        }
        return suc;
      },
      widgetBuilder: (context, row) {
        return CustomPhotosWidget(row: row);
      },
    ),
  ];
}
