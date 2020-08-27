import 'package:flutter/material.dart';
import 'package:tform_example/application.dart';
import 'package:tform_example/dynamic/form_dynamic_page.dart';

import './basic/form_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Application.appContext = context;

    return Scaffold(
      appBar: AppBar(
        title: Text("示例"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("基本使用"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FormPage(),
                ),
              );
            },
          ),
          Divider(
            height: 0.5,
            thickness: 0.5,
          ),
          ListTile(
            title: Text("动态表单"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FormDynamicPage(),
                ),
              );
            },
          ),
          Divider(
            height: 0.5,
            thickness: 0.5,
          ),
        ],
      ),
    );
  }
}
