import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tform/tform.dart';
import 'package:tform_example/application.dart';
import 'package:tform_example/widgets/next_button.dart';
import 'package:tform_example/widgets/photos_cell.dart';

import '../utils.dart';

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
                  readOnly: false,
                  divider: Divider(
                    height: 0.5,
                    thickness: 0.5,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 30),
                    child: NextButton(
                      title: "提交",
                      onPressed: () {
                        //校验
                        List errors =
                            (_dynamicFormKey.currentState as TFormState)
                                .validate();
                        if (errors.length > 0) {
                          showToast(errors.first);
                          return;
                        }
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
          clearButtonMode: OverlayVisibilityMode.editing,
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
          clearButtonMode: OverlayVisibilityMode.editing,
          suffixWidget: (context, row) {
            return FlatButton(
              onPressed: () {
                row.state = "1";
                showToast("验证成功");
              },
              // padding: EdgeInsets.only(left: 30),
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
    if (row != null) {
      rows.add(row);
    }
  });
  return rows;
}
