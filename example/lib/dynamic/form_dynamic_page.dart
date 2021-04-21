import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:tform/tform.dart';

import '../widgets/next_button.dart';
import '../widgets/photos_cell.dart';
import '../utils.dart';
import '../application.dart';

class FormDynamicPage extends StatelessWidget {
  FormDynamicPage({Key key}) : super(key: key);

  final GlobalKey _dynamicFormKey = GlobalKey<TFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("动态表单"),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return CustomScrollView(
              slivers: [
                TForm.sliver(
                  key: _dynamicFormKey,
                  rows: snapshot.data,
                  divider: Divider(
                    height: 0.5,
                    thickness: 0.5,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 30, bottom: 30, left: 22, right: 22),
                    child: NextButton(
                      title: "提交",
                      onPressed: () {
                        //校验
                        List errors =
                            (_dynamicFormKey.currentState as TFormState)
                                .validate();
                        if (errors.isNotEmpty) {
                          showToast(errors.first);
                          return;
                        }
                        //提交
                        showToast("成功");
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

Future getData() async {
  final json = await DefaultAssetBundle.of(Application.appContext)
      .loadString("lib/src/test.json");
  List form = jsonDecode(json)["data"]["form"];
  List<TFormRow> rows = [];
  form.forEach((e) {
    TFormRow row = getRow(e);
    if (row != null) {
      rows.add(row);
    }
  });
  return rows;
}

TFormRow getRow(e) {
  int type = int.parse(e["type"]);
  TFormRow row;
  switch (type) {
    case 1:
      row = TFormRow.input(
        tag: e["proid"],
        title: e["title"],
        placeholder: e["hintvalue"],
        value: e["value"],
        enabled: e["editable"],
        maxLength: e["maxlength"] != null ? int.parse(e["maxlength"]) : null,
        require: e["mustinput"],
        requireStar: e["mustinput"],
      );
      break;
    case 2:
      row = TFormRow.customSelector(
        tag: e["proid"],
        title: e["title"],
        placeholder: e["hintvalue"],
        value: e["value"],
        enabled: e["editable"],
        require: e["mustinput"],
        requireStar: e["mustinput"],
        onTap: (context, row) async {
          return showPickerDate(context);
        },
      );
      break;
    case 4:
      row = TFormRow.selector(
        tag: e["proid"],
        title: e["title"],
        placeholder: e["hintvalue"],
        value: e["value"],
        enabled: e["editable"],
        require: e["mustinput"],
        requireStar: e["mustinput"],
        options: (e["options"] as List).map((e) => e["selectvalue"]).toList(),
      );
      break;
    case 9:
      row = TFormRow.customSelector(
        tag: e["proid"],
        title: e["title"],
        placeholder: e["hintvalue"],
        value: e["value"],
        enabled: e["editable"],
        require: e["mustinput"],
        requireStar: e["mustinput"],
        options: (e["options"] as List).map((e) => e["selectvalue"]).toList(),
        onTap: (context, row) async {
          String value = await showPicker(row.options, context);
          if (value == "已婚") {
            TForm.of(context).insert(row, row.state);
          } else {
            TForm.of(context).delete(row.state);
          }
          return value;
        },
      );
      (e["options"] as List).forEach((element) {
        if (element["isOpen"] == "1") {
          List<TFormRow> rows = [];
          (element["extra"] as List).forEach((element) {
            rows.add(getRow(element));
          });
          row.state = rows;
        }
      });
      break;
    case 6:
      row = TFormRow.input(
        tag: e["proid"],
        title: e["title"],
        placeholder: e["hintvalue"],
        value: e["value"],
        enabled: e["editable"],
        require: e["mustinput"],
        requireStar: e["mustinput"],
        state: e["btnstate"],
        suffixWidget: (context, row) {
          return TextButton(
            onPressed: () {
              row.state = "1";
              showToast("验证成功");
            },
            child: Text(
              "验证",
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.blue),
            ),
          );
        },
        validator: (row) {
          if (!RegExp(
                  r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$')
              .hasMatch(row.value)) {
            row.requireMsg = "请输入正确的${row.title}";
            return false;
          }
          if (row.state == "0") {
            row.requireMsg = "请完成${row.title}验证";
            return false;
          }
          return true;
        },
      );
      break;
    case 7:
      row = TFormRow.customCellBuilder(
        tag: e["proid"],
        title: e["title"],
        state: e["piclist"],
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
      );
      break;
    default:
  }
  return row;
}
