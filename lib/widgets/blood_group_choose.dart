import 'package:blood_bank/providers/request_blood_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ChooseBloodGroup extends StatefulWidget {
  final String title;
  const ChooseBloodGroup({Key? key, required this.title}) : super(key: key);

  @override
  State<ChooseBloodGroup> createState() => _ChooseBloodGroupState();
}

class _ChooseBloodGroupState extends State<ChooseBloodGroup> {
  bool _selected = false;
  String _bloodType = "";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selected = !_selected;
          _bloodType = widget.title;
        });
        _selected
        ? Provider.of<RequestBlood>(context,listen: false).addBloods(_bloodType)
            : Provider.of<RequestBlood>(context,listen: false).removeBloods(_bloodType);
      },
      child: Container(
        width: 15.w,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _selected ? Color(0xFFe0174c) : Colors.transparent,
            border: Border.all(
                color: _selected ? Colors.white : Color(0xFFe0174c))),
        child: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 4.w,
              fontWeight: FontWeight.w500,
              color: _selected ? Colors.white : Color(0xFFbc0a3c)),
        ),
      ),
    );
  }
}
