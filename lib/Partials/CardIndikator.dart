import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget CardIndikator(BuildContext context, {
  double? height, 
  double? width,
  String? label, 
  String? value,
  IconData? icon,
  Color? iconColor
}){
    return Container(
        width: width!,
        height: height!,
        decoration: BoxDecoration(
          color: Color.fromRGBO(5, 15, 26, 1),
          borderRadius: BorderRadius.circular(10.dm)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 50.dm,
              height: 50.dm,
              child: Padding(
                padding: EdgeInsets.all(3.dm),
                child: Card(
                  color: Color.fromRGBO(26, 35, 44, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.dm)
                  ),
                  child: Icon(icon, color: iconColor,),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("$value",
                   style: TextStyle(
                    fontFamily: "Inria",
                    color: Colors.white,
                    fontSize: 18.sp
                   ),),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("$label",
                   style: TextStyle(
                    fontFamily: "Inria",
                    color: Colors.grey,
                    fontSize: 14.sp
                   ),),
                ),
              ],
            )
          ],
        ),
    ); 

}