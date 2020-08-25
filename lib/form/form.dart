import 'package:flutter/material.dart';

import 'form_cell.dart';
import 'form_row.dart';
import 'form_validation.dart';

enum TFormListType { column, sliver, builder, separated }

class TForm extends StatefulWidget {
  TForm({Key key, this.rows, this.listType = TFormListType.column})
      : super(key: key);

  TForm.sliver({Key key, this.rows, this.listType = TFormListType.sliver})
      : super(key: key);

  TForm.builder({Key key, this.rows, this.listType = TFormListType.builder})
      : super(key: key);

  TForm.separated({Key key, this.rows, this.listType = TFormListType.separated})
      : super(key: key);

  final List<TFormRow> rows;
  final TFormListType listType;

  static TFormState of(BuildContext context) {
    final _TFormScope scope =
        context.dependOnInheritedWidgetOfExactType<_TFormScope>();
    return scope?.formState;
  }

  @override
  TFormState createState() => TFormState(rows);
}

class TFormState extends State<TForm> {
  TFormState(this.rows);

  List<TFormRow> rows;

  void insert(currentRow, item) {
    if (item is List<TFormRow>) {
      rows.insertAll(rows.indexOf(currentRow) + 1, item);
    } else if (item is TFormRow) {
      rows.insert(rows.indexOf(currentRow), item);
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

  List validate() {
    List errors = formValidationErrors(rows);
    return errors;
  }

  void reload() {
    rows = List()..addAll(rows);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _TFormScope(
        rows: rows,
        formState: this,
        child: TFormList(
          type: widget.listType,
        ));
  }
}

class TFormList extends StatelessWidget {
  const TFormList({Key key, this.type}) : super(key: key);

  final TFormListType type;

  @override
  Widget build(BuildContext context) {
    final rows = TForm.of(context).rows;
    Widget widget;
    switch (type) {
      case TFormListType.column:
        widget = Column(
          children: rows.map((e) {
            return TFormCell(row: e);
          }).toList(),
        );
        break;
      case TFormListType.sliver:
        widget = SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
          return TFormCell(row: rows[index]);
        }, childCount: rows.length));
        break;
      case TFormListType.builder:
        widget = ListView.builder(
          itemCount: rows.length,
          itemBuilder: (BuildContext context, int index) {
            return TFormCell(row: rows[index]);
          },
        );
        break;
      case TFormListType.separated:
        widget = ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return TFormCell(row: rows[index]);
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
            itemCount: rows.length);
        break;
      default:
    }

    return widget;
  }
}

class _TFormScope extends InheritedWidget {
  const _TFormScope({
    Key key,
    Widget child,
    List rows,
    TFormState formState,
  })  : rows = rows,
        formState = formState,
        super(key: key, child: child);

  final List rows;

  final TFormState formState;

  get form => formState.widget;

  @override
  bool updateShouldNotify(_TFormScope old) => rows != old.rows;
}
