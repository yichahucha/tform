import 'package:flutter/material.dart';

class LTSelectorPage extends StatelessWidget {
  LTSelectorPage({Key key, this.options, this.isMultipleSelector, this.title})
      : super(key: key);

  final String title;
  final List<LTOptionModel> options;
  final bool isMultipleSelector;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          isMultipleSelector
              ? FlatButton(
                  child: Text(
                    "完成",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () {
                    String values = options
                        .where((element) => element.selected)
                        .map((e) => e.text)
                        .toList()
                        .join(",");
                    Navigator.of(context).pop(values);
                  },
                )
              : SizedBox.shrink(),
        ],
      ),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (BuildContext context, int index) {
          return LTListTitle(
            isMultipleSelector: isMultipleSelector,
            model: options[index],
          );
        },
      ),
    );
  }
}

class LTListTitle extends StatefulWidget {
  LTListTitle({Key key, this.model, this.isMultipleSelector}) : super(key: key);
  final LTOptionModel model;
  final bool isMultipleSelector;

  @override
  _LTListTitleState createState() => _LTListTitleState();
}

class _LTListTitleState extends State<LTListTitle> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (widget.isMultipleSelector) {
          widget.model.selected = !widget.model.selected;
          setState(() {});
        } else {
          Navigator.of(context).pop(widget.model.text);
        }
      },
      selected: widget.model.selected,
      title: Text(widget.model.text),
      trailing: widget.isMultipleSelector && widget.model.selected
          ? Icon(Icons.done)
          : SizedBox.shrink(),
    );
  }
}

class LTOptionModel {
  final int index;
  final String text;
  bool selected;

  LTOptionModel({this.text, this.selected = false, this.index});
}
