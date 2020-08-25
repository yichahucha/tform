import 'package:flutter/material.dart';
import 'package:tform/tform.dart';
import 'package:tform_example/widgets/select_image.dart';

class CustomPhotosWidget extends StatelessWidget {
  CustomPhotosWidget({
    Key key,
    this.row,
  }) : super(key: key);

  final TFormRow row;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(22, 0, 22, 0),
      child: Column(
        children: [
          Container(
            height: 48,
            alignment: Alignment.centerLeft,
            child: Text(
              "房屋照片",
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: (row.state as List).length,
              itemBuilder: (BuildContext context, int index) {
                return SelectImageView(
                  imageModel: row.state[index],
                  selected: (model) async {
                    // model.url =
                    //     "https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1598000545&di=3b9c32cab88272b744c569548a35810a&src=http://a1.att.hudong.com/05/00/01300000194285122188000535877.jpg";
                    return true;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
