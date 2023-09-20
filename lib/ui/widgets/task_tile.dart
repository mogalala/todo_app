import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:todo/ui/theme.dart';
import '../../models/task.dart';
import '../size_config.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({Key? key, required this.task}) : super(key: key);
  final Task task;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(SizeConfig.orientation == Orientation.landscape ? 4 : 20)),
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
      width: SizeConfig.orientation == Orientation.landscape ? SizeConfig.screenWidth / 2 : SizeConfig.screenWidth,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _getBGClr(task.color),
        ),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.title!,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey[200],
                            size: 18,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${task.startTime} - ${task.endTime}',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[100],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(task.note!,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[100],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: .5,
              height: 60,
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                task.isCompleted == 0 ? 'TODO' : 'Completed',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getBGClr(int? color) {
    switch(color){
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return orangeClr;
      default:
        return bluishClr;
    }
  }
}
