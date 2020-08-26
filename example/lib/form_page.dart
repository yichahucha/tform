import 'package:flutter/material.dart';
import 'package:tform/form/form.dart';

import 'package:tform/tform.dart';
import 'package:tform_example/application.dart';

import 'form_state.dart';
import 'form_utils.dart';

class FormPage extends StatelessWidget {
  FormPage({Key key}) : super(key: key);
  final GlobalKey _formKey = GlobalKey<TFormState>();

  @override
  Widget build(BuildContext context) {
    Application.appContext = context;
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
