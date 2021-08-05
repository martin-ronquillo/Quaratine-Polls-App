import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  const CardContainer({Key? key, required this.widgetsType})
      : super(key: key);

  final Widget widgetsType;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 5))
              ]),
          child: widgetsType),
      SizedBox(
        height: 20,
      )
    ]);
  }
}
