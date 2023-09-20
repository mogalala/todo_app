import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/ui/pages/add_task_page.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../../services/notification_services.dart';
import '../../services/theme_services.dart';
import '../size_config.dart';
import '../theme.dart';
import '../widgets/button.dart';
import '../widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;
  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.requestIOSPermissions();
    notifyHelper.initializeNotification();
    _taskController.getTasks();
  }

  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              ThemeServices().switchTheme();
            },
            icon: Icon(Get.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round_outlined,
                color: Get.isDarkMode ? Colors.white : darkGreyClr)),
        backgroundColor: context.theme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: (){
                notifyHelper.cancelAllNotification();
                _taskController.deleteAllTasks();
              },
              icon: Icon(Icons.cleaning_services_outlined,size: 20, color: Get.isDarkMode ? Colors.white : darkGreyClr,),
          ),
          SizedBox(width: 5),
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/person.jpeg'),
            radius: 16,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBAr(),
          SizedBox(
            height: 10,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: EdgeInsets.only(right: 20, left: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: headingStyle,
              ),
              Text(
                'Today',
                style: subHeadingStyle,
              ),
            ],
          ),
          MyButton(
              label: '+ Add TAsk',
              onTap: () async {
                await Get.to(() => AddTaskPage());
                _taskController.getTasks();
              }),
        ],
      ),
    );
  }

  _addDateBAr() {
    return Container(
      margin: EdgeInsets.only(right: 20, left: 20, top: 10),
      child: DatePicker(
        DateTime.now(),
        width: 65,
        height: 90,
        initialSelectedDate: DateTime.now(),
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    _taskController.getTasks();
  }

  _showTasks() {
    return Expanded(
      child: Obx(
        () {
          if (_taskController.taskList.isEmpty) {
            return _noTaskMsg();
          } else {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                itemCount: _taskController.taskList.length,
                scrollDirection: SizeConfig.orientation == Orientation.landscape ? Axis.horizontal : Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  var task = _taskController.taskList[index];
                  if (task.repeat == 'Daily' || task.date == DateFormat.yMd().format(_selectedDate) ||
                      (task.repeat == 'Weekly' && _selectedDate.difference(DateFormat.yMd().parse(task.date!)).inDays % 7 == 0) ||
                      (task.repeat == 'Monthly' && DateFormat.yMd().parse(task.date!).day == _selectedDate.day)
                  ) {
                    // var hour = int.parse(task.startTime.toString().split(':')[0]);
                    // var minutes = int.parse(task.startTime.toString().split(':')[1]);

                    // var date = DateFormat.jm().parse(task.startTime!);
                    // var myTime = DateFormat('HH:mm').format(date);
                    notifyHelper.scheduledNotification(
                        int.tryParse(task.startTime.toString().split(':')[0]) ?? 0,
                        int.tryParse(task.startTime.toString().split(':')[1]) ?? 0,
                        task,
                    );
                    return AnimationConfiguration.staggeredList(
                      duration: Duration(milliseconds: 1000),
                      position: index,
                      child: SlideAnimation(
                        horizontalOffset: 300,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () => showBottomSheet(
                              context,
                              task,
                            ),
                            child: TaskTile(
                              task: task,
                            ),
                          ),
                        ),
                      ),
                    );
                  }else{
                    return Container();
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }

  _noTaskMsg() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: SizeConfig.orientation == Orientation.landscape ? Axis.horizontal : Axis.vertical,
          children: [
            SizeConfig.orientation == Orientation.landscape ? SizedBox(height: 8) : SizedBox(height: 50),
            SvgPicture.asset(
              'assets/images/task.svg',
              height: 70,
              semanticsLabel: 'Task',
              color: primaryClr.withOpacity(.5),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'You do not have ant tasks yet! \n Add new task to make your days productive.',
                style: subTitleStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 5),
          width: SizeConfig.screenWidth,
          height: (SizeConfig.orientation == Orientation.landscape)
              ? (task.isCompleted == 1 ? SizeConfig.screenHeight * .6 : SizeConfig.screenHeight * .8)
              : (task.isCompleted == 1 ? SizeConfig.screenHeight * .25 : SizeConfig.screenHeight * .33),
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  height: 6,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              task.isCompleted == 1
                  ? Container()
                  : _buildBottomSheet(
                      label: 'Task Completed',
                      onTap: () {
                        notifyHelper.cancelNotification(task);
                        _taskController.markUsCompletedTasks(task.id!);
                        Get.back();
                      },
                      clr: primaryClr,
                    ),
              _buildBottomSheet(
                label: 'Delete Task',
                onTap: () {
                  notifyHelper.cancelNotification(task);
                  _taskController.deleteTasks(task: task);
                  Get.back();
                },
                clr: Colors.red[300]!,
              ),
              Divider(
                color: Get.isDarkMode ? Colors.grey : darkGreyClr,
              ),
              _buildBottomSheet(
                label: 'Cancel',
                onTap: () {
                  Get.back();
                },
                clr: primaryClr,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildBottomSheet({required String label, required Function() onTap, required Color clr, bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        height: 65,
        width: SizeConfig.screenWidth * .9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
