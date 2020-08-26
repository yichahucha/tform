import 'package:flutter/material.dart';
import 'package:tform/form/form.dart';

import 'package:tform/tform.dart';
import 'package:tform_example/application.dart';
import 'package:tform_example/widgets/next_button.dart';

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
        ),
        body: buildCustomScrollView());
  }

  CustomScrollView buildCustomScrollView() {
    return CustomScrollView(
      slivers: [
        TForm.sliver(
          key: _formKey,
          rows: formRows,
          readOnly: false,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 30),
            child: NextButton(
              title: "提交",
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
          ),
        ),
      ],
    );
  }
}
