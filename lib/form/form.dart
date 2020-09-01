import 'package:flutter/material.dart';

import 'form_cell.dart';
import 'form_row.dart';
import 'form_validation.dart';

enum TFormListType { column, sliver, builder, separated }

class TForm extends StatefulWidget {
  final List<TFormRow> rows;
  final TFormListType listType;
  final Divider divider;

  get deepCopyRows => rows.map((e) => e.clone()).toList();

  TForm({
    Key key,
    this.rows,
    this.listType = TFormListType.column,
    this.divider,
  }) : super(key: key);

  TForm.sliver({
    Key key,
    this.rows,
    this.listType = TFormListType.sliver,
    this.divider,
  }) : super(key: key);

  TForm.builder({
    Key key,
    this.rows,
    this.listType = TFormListType.builder,
    this.divider,
  }) : super(key: key);

  static TFormState of(BuildContext context) {
    final _TFormScope scope =
        context.dependOnInheritedWidgetOfExactType<_TFormScope>();
    return scope?.state;
  }

  @override
  TFormState createState() => TFormState(deepCopyRows);
}

class TFormState extends State<TForm> {
  List<TFormRow> rows;
  get form => widget;
  get divider => widget.divider;

  TFormState(this.rows);

  void insert(currentRow, item) {
    if (item is List<TFormRow>) {
      rows.insertAll(rows.indexOf(currentRow) + 1,
          item.map((e) => e..animation = true).toList());
    } else if (item is TFormRow) {
      rows.insert(rows.indexOf(currentRow), item..animation = true);
    }
    reload();
  }

  void delete(item) {
    if (item is List<TFormRow>) {
      item.forEach((element) {
        rows.remove(element);
      });
    } else if (item is TFormRow) {
      rows.remove(item);
    }
    reload();
  }

  void reset() {
    setState(() {
      rows = form.deepCopyRows;
    });
  }

  void reload() {
    setState(() {
      rows = [...rows];
    });
  }

  List validate() {
    List errors = formValidationErrors(rows);
    return errors;
  }

  @override
  Widget build(BuildContext context) {
    return _TFormScope(
        state: this,
        child: TFormList(
          type: widget.listType,
        ));
  }
}

class _TFormScope extends InheritedWidget {
  const _TFormScope({
    Key key,
    Widget child,
    this.state,
  }) : super(key: key, child: child);

  final TFormState state;
  get rows => state.rows;

  @override
  bool updateShouldNotify(_TFormScope old) => rows != old.rows;
}

class TFormList extends StatelessWidget {
  const TFormList({Key key, this.type}) : super(key: key);

  final TFormListType type;

  @override
  Widget build(BuildContext context) {
    final rows = TForm.of(context).rows;
    Widget list;
    switch (type) {
      case TFormListType.column:
        list = GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Column(
            children: rows.map((e) {
              return TFormCell(row: e);
            }).toList(),
          ),
        );
        break;
      case TFormListType.sliver:
        list = SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
          return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: TFormCell(row: rows[index]));
        }, childCount: rows.length));
        break;
      case TFormListType.builder:
        list = GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: ListView.builder(
            itemCount: rows.length,
            itemBuilder: (BuildContext context, int index) {
              return TFormCell(row: rows[index]);
            },
          ),
        );
        break;
      default:
    }
    return list;
  }
}
