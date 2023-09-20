import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/ui/theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.payload}) : super(key: key);
  final String payload;
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _payload ='';
  @override
  void initState() {
    _payload = widget.payload;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        iconTheme: IconThemeData(color: primaryClr),
        centerTitle: true,
        title: Text(_payload.toString().split('|')[0],
          style: TextStyle(color: Get.isDarkMode ? Colors.white : darkGreyClr),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10),
              child: Column(
                children: [
                  Text('Hello ,mo',
                    style: TextStyle(fontSize: 26,fontWeight: FontWeight.w900,color: Get.isDarkMode ? white : darkGreyClr),
                  ),
                  SizedBox(height: 10,),
                  Text('you have new reminder',
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Get.isDarkMode ? white : darkGreyClr),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: primaryClr,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.text_format,size: 30,color: Colors.white,),
                            SizedBox(width: 20,),
                            Text('title',
                              style: TextStyle(color: Colors.white ,fontSize: 30,),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(_payload.toString().split('|')[0],
                            style: TextStyle(color: Colors.white ,fontSize: 20,),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.description,size: 30,color: Colors.white,),
                            SizedBox(width: 20,),
                            Text('Description',
                              style: TextStyle(color: Colors.white ,fontSize: 30,),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(_payload.toString().split('|')[1],
                            style: TextStyle(color: Colors.white ,fontSize: 20,),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined,size: 30,color: Colors.white,),
                            SizedBox(width: 20,),
                            Text('Date',
                              style: TextStyle(color: Colors.white ,fontSize: 30,),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(_payload.toString().split('|')[2],
                            style: TextStyle(color: Colors.white ,fontSize: 20,),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}
