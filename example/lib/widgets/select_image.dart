import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectImageModel {
  String path;
  String url;

  SelectImageModel({this.path, this.url});
}

class SelectImageView extends StatefulWidget {
  SelectImageView({Key key, this.selected, this.imageModel}) : super(key: key);

  final SelectImageModel imageModel;
  final Future Function(SelectImageModel model) selected;

  @override
  _SelectImageViewState createState() => _SelectImageViewState();
}

class _SelectImageViewState extends State<SelectImageView> {
  final picker = ImagePicker();
  File _image;

  Future<bool> _getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      return true;
    } else {
      return false;
    }
  }

  Future<ImageSource> _showBottomSheet() async {
    return await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200.0,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('拍照', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, ImageSource.camera);
                  },
                ),
                ListTile(
                  title: Text('从相册选择', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, ImageSource.gallery);
                  },
                ),
                ListTile(
                  title: Text('取消', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //show
        final source = await _showBottomSheet();
        //image
        if (source == null) return;
        final bool result = await _getImage(source);
        if (!result) return;
        widget.imageModel.path = _image.path;

        if (widget.selected == null) return;
        await widget.selected(widget.imageModel);
        setState(() {});
      },
      child: Container(
        width: 100,
        margin: EdgeInsets.all(5),
        color: Colors.grey[200],
        child: Center(
            child: widget.imageModel.url != null
                ? Image.network(widget.imageModel.url)
                : widget.imageModel.path != null
                    ? Image.file(File(widget.imageModel.path))
                    : SizedBox.shrink()),
      ),
    );
  }
}
