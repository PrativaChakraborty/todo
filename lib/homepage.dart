import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/Colors.dart';
import 'package:intl/intl.dart';
import 'package:todo/model.dart';
import 'package:todo/taskDialog.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
  String? name;
  HomePage({Key? key, required this.name}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

//declare a textcontroller

//create a class named task to store task and its boolean value

// make a dynamic growable list of task
List<Task> _tasklist = <Task>[];

class _HomePageState extends State<HomePage> {
  Color buttonColor = AppColor.greyColor;

  bool isTextEMpty = true;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('tasklist');
    if (data != null) {
      setState(() {
        _tasklist = taskFromJson(data);
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasklist', taskToJson(_tasklist));
  }

  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.calendar_month,
              size: 28,
            ),
            color: Color(0xffBFBECC),
            onPressed: () {},
          ),
        ),
        body: isLoading
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome ${widget.name} !',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.roboto(),
                  ).text.xl4.bold.make().pSymmetric(h: 12),
                  SizedBox(
                    height: 20,
                  ),
                  _tasklist.length == 0
                      ? Column(children: [
                          Center(
                            child: Text(
                              'No tasks yet',
                              style: GoogleFonts.roboto(),
                            ).text.lg.gray400.make().pSymmetric(h: 12),
                          ),
                          Center(
                            child: Text(
                              ' Click on the + button to add a task',
                              style: GoogleFonts.roboto(),
                            ).text.lg.gray400.make().pSymmetric(h: 12),
                          ),
                          SizedBox(
                            height: context.percentHeight * 8,
                          ),
                          Image.asset("assets/images/emptyScreen.png",
                              height: 300, width: 300),
                        ])
                      :
                      //make a dynamic list of widgets
                      Expanded(
                          child: ListView.builder(
                            itemCount: _tasklist.length,
                            itemBuilder: (context, index) {
                              return SwipeActionCell(
                                key: ObjectKey(_tasklist[index]),
                                trailingActions: [
                                  SwipeAction(

                                      ///this is the same as iOS native
                                      performsFirstActionWithFullSwipe: true,
                                      title: "delete",
                                      onTap: (CompletionHandler handler) async {
                                        _tasklist.removeAt(index);
                                        setData();
                                        setState(() {});
                                      },
                                      color: AppColor.primaryColor
                                          .withOpacity(0.6)),
                                ],
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColor.secondaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    onTap: () {},
                                    leading: RoundCheckBox(
                                      isChecked: _tasklist[index].isChecked,
                                      checkedColor: AppColor.primaryColor,
                                      size: 24,
                                      checkedWidget: Icon(
                                        Icons.check,
                                        color: AppColor.secondaryColor,
                                        size: 18,
                                      ),
                                      border: Border.all(
                                        color: AppColor.primaryColor,
                                        width: 2,
                                      ),
                                      onTap: (selected) {
                                        setState(() {
                                          _tasklist[index].isChecked =
                                              selected!;
                                          setData();
                                        });
                                      },
                                    ),
                                    title: Text(
                                      _tasklist[index].task,
                                      style: GoogleFonts.lato(
                                          fontSize: 20,
                                          decoration: _tasklist[index].isChecked
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                          color: _tasklist[index].isChecked
                                              ? Colors.grey
                                              : Colors.black),
                                    ).text.make(),
                                    subtitle: _tasklist[index].date == ''
                                        ? Text('')
                                        : Row(
                                            children: [
                                              Icon(Icons.calendar_today,
                                                  color: AppColor.primaryColor,
                                                  size: 12),
                                              SizedBox(width: 5),
                                              Text(
                                                _tasklist[index].date,
                                                style: GoogleFonts.roboto(
                                                    color:
                                                        AppColor.primaryColor),
                                              ).text.sm.make()
                                            ],
                                          ),
                                    trailing: GestureDetector(
                                      onTap: () async {
                                        var nt = await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return TaskDialog(
                                                existingTask: _tasklist[index],
                                              );
                                            });
                                        if (nt != null) {
                                          _tasklist[index] = nt;
                                          setData();
                                          setState(() {});
                                        }
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        color: AppColor.primaryColor,
                                      ),
                                    ),
                                  ),
                                ).pSymmetric(v: 2),
                              );
                            },
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ).pSymmetric(h: 16),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.primaryColor,
          onPressed: () async {
            final task = await _showAddTaskDialog(context);
            if (task != null) {
              _tasklist.add(task);
              setData();
              setState(() {});
            }
          },
          tooltip: 'Add new task',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<Task?> _showAddTaskDialog(BuildContext context) async {
    return showDialog<Task>(
      context: context,
      builder: (BuildContext context) {
        return TaskDialog();
      },
    );
  }
}
