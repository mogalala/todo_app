import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/ui/size_config.dart';
import 'package:todo/ui/theme.dart';

class InputField extends StatelessWidget {
  const InputField({Key? key, required this.title, required this.hint, this.controller, this.widget}) : super(key: key);

  final String title;
  final String hint;
  final TextEditingController? controller ;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
            style: titleStyle,
          ),
          Container(
            width: SizeConfig.screenWidth,
            height: 45,
            padding: EdgeInsets.only(left: 12),
            margin: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    autofocus: false,
                    readOnly: widget != null ? true : false,
                    style: subTitleStyle,
                    cursorColor: Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subTitleStyle,
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 0,color: context.theme.colorScheme.background)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 0,color: context.theme.colorScheme.background)),
                    ),
                  ),
                ),
                widget ?? Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
