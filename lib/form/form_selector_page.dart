import 'package:flutter/material.dart';

class TFormSelectorPage extends StatelessWidget {
  TFormSelectorPage(
      {Key key, this.options, this.isMultipleSelector, this.title})
      : super(key: key);

  final String title;
  final List<TFormOptionModel> options;
  final bool isMultipleSelector;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          isMultipleSelector
              ? TextButton(
                  child: Text(
                    "完成",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () {
                    String values = options
                        .where((element) => element.selected)
                        .map((e) => e.value)
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
            options: options,
          );
        },
      ),
    );
  }
}

class LTListTitle extends StatefulWidget {
  LTListTitle({Key key, this.model, this.isMultipleSelector, this.options})
      : super(key: key);
  final TFormOptionModel model;
  final bool isMultipleSelector;
  final List<TFormOptionModel> options;

  @override
  _LTListTitleState createState() => _LTListTitleState();
}

class _LTListTitleState extends State<LTListTitle> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (widget.isMultipleSelector) {
          setState(() {
            widget.model.selected = !widget.model.selected;
          });
        } else {
          widget.options.map((e) => e.selected = false).toList();
          widget.model.selected = true;
          Navigator.of(context).pop(widget.model.value);
        }
      },
      selected: widget.model.selected,
      title: Text(widget.model.value),
      trailing: widget.isMultipleSelector && widget.model.selected
          ? Icon(Icons.done)
          : SizedBox.shrink(),
    );
  }
}

class TFormOptionModel {
  final int index;
  final String value;
  bool selected;

  TFormOptionModel({this.value, this.selected = false, this.index});
}
