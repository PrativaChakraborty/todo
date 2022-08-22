import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/Colors.dart';
import 'package:todo/homepage.dart';
import 'package:todo/model.dart';
import 'package:todo/notificationHandler.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:math';

class TaskDialog extends StatefulWidget {
  final Task? existingTask;
  const TaskDialog({Key? key, this.existingTask}) : super(key: key);

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  late TextEditingController _textController;
  DateTime selectedDate = DateTime.now();
  final NotificationService _notificationService = NotificationService();
  Random random = Random();
  bool isTextEMpty = true;
  String dueDate = '';
  String dueTime = '';
  int taskId = 0;
  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    if (widget.existingTask != null) {
      _textController.text = widget.existingTask!.task;
      isTextEMpty = false;
      dueDate = widget.existingTask!.date;
      dueTime = widget.existingTask!.time;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.secondaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          height: context.percentHeight * 25,
          width: context.percentWidth * 80,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _textController,
                autofocus: true,
                cursorColor: AppColor.primaryColor,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.radio_button_unchecked,
                    color: AppColor.greyColor,
                    size: 20,
                  ),
                  hintText: 'Enter a task',
                  hintStyle: GoogleFonts.lato(
                    fontSize: 18,
                    color: AppColor.greyColor,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      isTextEMpty = true;
                    } else {
                      isTextEMpty = false;
                    }
                    taskId = random.nextInt(1000);
                  });
                },
              ).p16(),
              //create a date picker
              Padding(
                padding: EdgeInsets.only(left: context.percentWidth * 22),
                child: GestureDetector(
                  onTap: () {
                    date = showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    ).then((date) {
                      dueDate = DateFormat('dd.MM.yyyy').format(date!);
                    }) as DateTime;
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.calendar_month_outlined,
                            color: AppColor.darkGreyColor),
                        Text(
                          dueDate == '' ? 'Set Due Date' : dueDate.toString(),
                          style:
                              GoogleFonts.roboto(color: AppColor.darkGreyColor),
                        ).text.lg.make().pSymmetric(h: 12),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: context.percentWidth * 25),
                child: GestureDetector(
                  onTap: () async {
                    time = showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    ).then((time) {
                      final localizations = MaterialLocalizations.of(context);
                      final formattedTimeOfDay =
                          localizations.formatTimeOfDay(time!);
                      dueTime = formattedTimeOfDay;
                    }) as TimeOfDay;

                    setState(() {
                      selectedDate = time as DateTime;
                    });
                    print(selectedDate);
                    await _notificationService.scheduleNotifications(
                        id: taskId,
                        title: _textController.text,
                        time: selectedDate);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.secondaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.notification_add_outlined,
                            color: AppColor.darkGreyColor),
                        Text(
                          dueTime == '' ? 'Reminder' : dueTime,
                          style:
                              GoogleFonts.roboto(color: AppColor.darkGreyColor),
                        ).text.lg.make().pSymmetric(h: 12),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.roboto(color: AppColor.primaryColor),
                    ).text.bold.xl.make(),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        if (_textController.text.isNotEmpty) {
                          Navigator.of(context).pop(Task(
                              id: taskId,
                              task: _textController.text,
                              isChecked: false,
                              date: dueDate,
                              time: dueTime));
                        }
                      },
                      child: Text(
                        'Add',
                        style: GoogleFonts.roboto(
                            color: isTextEMpty
                                ? AppColor.greyColor
                                : AppColor.primaryColor),
                      ).text.bold.xl.make()),
                ],
              )
            ],
          ),
        ).p16(),
      ),
    );
    ;
  }
}
