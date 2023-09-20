import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/ui/theme.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../widgets/button.dart';
import '../widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 15))).toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: primaryClr),
        backgroundColor: context.theme.backgroundColor,
        elevation: 0,
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/person.jpeg'),
            radius: 16,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              InputField(
                title: 'Title',
                hint: 'Enter title here',
                controller: _titleController,
              ),
              InputField(
                title: 'Note',
                hint: 'Enter your note',
                controller: _noteController,
              ),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectDate),
                widget: IconButton(
                  onPressed: () {
                    _getDateFromUser();
                  },
                  icon: Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: InputField(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              InputField(
                title: 'Remind',
                hint: '$_selectedRemind minutes early',
                widget: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButton(
                    dropdownColor: Colors.blueGrey,
                    items: remindList
                        .map<DropdownMenuItem<String>>((element) => DropdownMenuItem(
                            value: element.toString(),
                            child: Text(
                              '$element',
                              style: TextStyle(color: Colors.white),
                            )))
                        .toList(),
                    onChanged: (newElement) {
                      setState(() {
                        _selectedRemind = int.parse(newElement!);
                      });
                    },
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    iconSize: 30,
                    elevation: 3,
                    underline: Container(
                      height: 0,
                    ),
                    style: subTitleStyle,
                  ),
                ),
              ),
              InputField(
                title: 'Repeat',
                hint: _selectedRepeat,
                widget: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButton(
                    dropdownColor: Colors.blueGrey,
                    items: repeatList
                        .map<DropdownMenuItem<String>>((element) => DropdownMenuItem(
                            value: element,
                            child: Text(
                              element,
                              style: TextStyle(color: Colors.white),
                            )))
                        .toList(),
                    onChanged: (newElement) {
                      setState(() {
                        _selectedRepeat = newElement!;
                      });
                    },
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    iconSize: 30,
                    elevation: 3,
                    underline: Container(
                      height: 0,
                    ),
                    style: subTitleStyle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _colorPalette(),
                    MyButton(
                      label: 'Create Task',
                      onTap: () {
                        _validateDate();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar('Required', 'All field are required',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: Icon(
            Icons.warning_amber_outlined,
            color: Colors.red,
          ));
    } else {
      print('vvkKNVK');
    }
  }

  _addTaskToDb() async {
    int value = await _taskController.addTask(
      task: Task(
        title: _titleController.text,
        note: _noteController.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(_selectDate),
        startTime: _startTime,
        endTime: _endTime,
        color: _selectedColor,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
      ),
    );
    print('/////////// $value');
  }

  Column _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'color',
            style: titleStyle,
          ),
        ),
        Wrap(
          children: List.generate(
              3,
              (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: CircleAvatar(
                        child: _selectedColor == index
                            ? Icon(
                                Icons.done,
                                size: 15,
                                color: Colors.white,
                              )
                            : null,
                        backgroundColor: index == 0
                            ? primaryClr
                            : index == 1
                                ? pinkClr
                                : orangeClr,
                        radius: 14,
                      ),
                    ),
                  )),
        ),
      ],
    );
  }

  void _getDateFromUser() async{
    DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2033),
    );
    if(_pickedDate != null){
      setState(() {
        _selectDate = _pickedDate;
      });
    }else{
      print('No Date Selected');
    }
  }

  void _getTimeFromUser({required bool isStartTime}) async{
    TimeOfDay? _pickedTime = await showTimePicker(
        context: context,
        initialTime: isStartTime
            ? TimeOfDay.fromDateTime(DateTime.now())
            : TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 20))),
    );

    String _formattedTime = _pickedTime!.format(context);
    if(isStartTime)
      setState(() => _startTime = _formattedTime);
    else if(!isStartTime)
      setState(() => _endTime = _formattedTime);
    else print('No Time Selected, Something is wrong');

  }
}
