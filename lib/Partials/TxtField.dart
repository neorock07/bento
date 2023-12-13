import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget TxtField(BuildContext context,
    {GlobalKey? key,
    String? label,
    TextInputType? keyboardType,
    TextEditingController? controller}) {
  return Padding(
    padding: EdgeInsets.only(left: 5.w, right: 5.w),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextField(
          // initialValue: init,
          controller: controller,
          style: const TextStyle(color: Colors.white),
          // textCapitalization: TextCapitalization.characters,
          keyboardType:
              (keyboardType != null) ? keyboardType : TextInputType.text,
          decoration: InputDecoration(
            label: Text("$label"),
          ),
        )
      ],
    ),
  );
}
