import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';

///
import '../../main.dart';
import '../../models/task.dart';
import '../../utils/colors.dart';
import '../../utils/constanst.dart';
import '../../utils/strings.dart';

// ignore: must_be_immutable
class TaskView extends StatefulWidget {
  final TextEditingController? taskControllerForTitle;
  final TextEditingController? taskControllerForSubtitle;
  final Task? task;

  const TaskView({
    super.key,
    required this.taskControllerForTitle,
    required this.taskControllerForSubtitle,
    required this.task,
  });

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  String? title;
  String? subtitle;
  DateTime? time;
  DateTime? date;

  /// Show Selected Time As String Format
  String showTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(time).toString();
      }
    } else {
      return DateFormat('hh:mm a')
          .format(widget.task!.createdAtTime)
          .toString();
    }
  }

  /// Show Selected Time As DateTime Format
  DateTime showTimeAsDateTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateTime.now();
      } else {
        return time;
      }
    } else {
      return widget.task!.createdAtTime;
    }
  }

  /// Show Selected Date As String Format
  String showDate(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    }
  }

  // Show Selected Date As DateTime Format
  DateTime showDateAsDateTime(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.createdAtDate;
    }
  }

  /// If any Task Already exist return TRUE otherWise FALSE
  bool isTaskAlreadyExistBool() {
    if (widget.taskControllerForTitle?.text == null &&
        widget.taskControllerForSubtitle?.text == null) {
      return true;
    } else {
      return false;
    }
  }

  /// If any task already exist app will update it otherwise the app will add a new task
  dynamic isTaskAlreadyExistUpdateTask() async {
    if (widget.taskControllerForTitle?.text != null &&
        widget.taskControllerForSubtitle?.text != null) {
      try {
        widget.taskControllerForTitle?.text = title ?? '';
        widget.taskControllerForSubtitle?.text = subtitle ?? '';

        if (widget.task != null) {
          widget.task!.title = title ?? '';
          widget.task!.subtitle = subtitle ?? '';
          if (date != null) widget.task!.createdAtDate = date!;
          if (time != null) widget.task!.createdAtTime = time!;
          await BaseWidget.of(context).dataStore.updateTask(task: widget.task!);
        }
        Navigator.of(context).pop();
      } catch (error) {
        nothingEnterOnUpdateTaskMode(context);
      }
    } else {
      if (title != null && subtitle != null) {
        var task = Task.create(
          title: title ?? '',
          createdAtTime: time,
          createdAtDate: date,
          subtitle: subtitle ?? '',
        );
        await BaseWidget.of(context).dataStore.addTask(task: task);
        Navigator.of(context).pop();
      } else {
        emptyFieldsWarning(context);
      }
    }
  }

  /// Delete Selected Task
  dynamic deleteTask() async {
    if (widget.task != null) {
      await BaseWidget.of(context).dataStore.deleteTask(task: widget.task!);
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const MyAppBar(),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /// new / update Task Text
                  _buildTopText(textTheme, screenWidth),

                  /// Middle Two TextFileds, Time And Date Selection Box
                  _buildMiddleTextFieldsANDTimeAndDateSelection(
                      context, textTheme, screenWidth),

                  /// All Bottom Buttons
                  _buildBottomButtons(context, screenWidth),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// All Bottom Buttons
  Padding _buildBottomButtons(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 16, right: 16, top: 16),
      child: Row(
        mainAxisAlignment: isTaskAlreadyExistBool()
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceBetween,
        children: [
          if (!isTaskAlreadyExistBool())
            Expanded(
              child: Container(
                height: 48,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: MyColors.primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onPressed: () {
                    deleteTask();
                    Navigator.pop(context);
                  },
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.close, color: MyColors.primaryColor, size: 20),
                      SizedBox(width: 5),
                      Text(
                        MyString.deleteTask,
                        style: TextStyle(
                          color: MyColors.primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: Container(
              height: 48,
              margin: isTaskAlreadyExistBool()
                  ? null
                  : const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: MyColors.primaryColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: MyColors.primaryColor.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onPressed: () {
                  isTaskAlreadyExistUpdateTask();
                },
                color: MyColors.primaryColor,
                child: Text(
                  isTaskAlreadyExistBool()
                      ? MyString.addTaskString
                      : MyString.updateTaskString,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Middle Two TextFileds And Time And Date Selection Box
  SizedBox _buildMiddleTextFieldsANDTimeAndDateSelection(
      BuildContext context, TextTheme textTheme, double screenWidth) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title of TextFiled
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(MyString.titleOfTitleTextField,
                style: textTheme.titleMedium?.copyWith(fontSize: 15)),
          ),

          /// Title TextField
          Container(
            width: screenWidth * 0.92,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: ListTile(
              title: TextFormField(
                controller: widget.taskControllerForTitle,
                maxLines: 3,
                cursorHeight: 30,
                style: const TextStyle(color: Colors.black, fontSize: 15),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                onFieldSubmitted: (value) {
                  title = value;
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onChanged: (value) {
                  title = value;
                },
              ),
            ),
          ),

          const SizedBox(
            height: 6,
          ),

          /// Note TextField
          Container(
            width: screenWidth * 0.92,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: ListTile(
              title: TextFormField(
                controller: widget.taskControllerForSubtitle,
                style: const TextStyle(color: Colors.black, fontSize: 14),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.bookmark_border,
                      color: Colors.grey, size: 18),
                  border: InputBorder.none,
                  counter: Container(),
                  hintText: MyString.addNote,
                  hintStyle: const TextStyle(fontSize: 13),
                ),
                onFieldSubmitted: (value) {
                  subtitle = value;
                },
                onChanged: (value) {
                  subtitle = value;
                },
              ),
            ),
          ),

          /// Time Picker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: GestureDetector(
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(showTimeAsDateTime(time)),
                );
                if (picked != null) {
                  setState(() {
                    final now = DateTime.now();
                    final selected = DateTime(now.year, now.month, now.day,
                        picked.hour, picked.minute);
                    if (widget.task?.createdAtTime == null) {
                      time = selected;
                    } else {
                      widget.task!.createdAtTime = selected;
                    }
                  });
                }
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Icon(Icons.access_time, color: Colors.blueGrey),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      MyString.timeString,
                      style: textTheme.bodyMedium?.copyWith(fontSize: 14),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Text(
                        showTime(time),
                        style: textTheme.bodyLarge?.copyWith(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Date Picker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: showDateAsDateTime(date),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    if (widget.task?.createdAtDate == null) {
                      date = picked;
                    } else {
                      widget.task!.createdAtDate = picked;
                    }
                  });
                }
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Icon(Icons.calendar_today, color: Colors.blueGrey),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      MyString.dateString,
                      style: textTheme.bodyMedium?.copyWith(fontSize: 14),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Text(
                        showDate(date),
                        style: textTheme.bodyLarge?.copyWith(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// new / update Task Text
  SizedBox _buildTopText(TextTheme textTheme, double screenWidth) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 30,
            child: Divider(
              thickness: 1,
            ),
          ),
          RichText(
            text: TextSpan(
                text: isTaskAlreadyExistBool()
                    ? MyString.addNewTask
                    : MyString.updateCurrentTask,
                style: textTheme.titleMedium
                    ?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                children: const [
                  TextSpan(
                    text: MyString.taskStrnig,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  )
                ]),
          ),
          const SizedBox(
            width: 30,
            child: Divider(
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// AppBar
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
