import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todolist/controllers/todo_controller.dart';
import 'package:todolist/screens/add_edit_todo.dart';
import 'package:todolist/widgets/common_button.dart';
import 'package:todolist/widgets/common_checkbox.dart';
import 'package:todolist/themes/app_colors.dart' as AppColors;

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> with WidgetsBindingObserver {
  var selectionMode = false;
  var selectedToDo = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  @override
  Widget build(context) {
    return GetBuilder(
      init: Get.put(ToDoController(), permanent: true),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.toolbarColor,
            foregroundColor: Colors.black,
            title: Text('todo_list'.tr),
            actions: [
              Obx(() {
                return controller.toDoList.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'delete'.tr,
                  onPressed: () {
                    if (selectionMode) {
                      if (selectedToDo.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                title: Text('are_you_sure'.tr),
                                content: Text('delete_confirmation'.tr),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectionMode = false;
                                        selectedToDo = [];

                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Text('confirmation_no'.tr),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        controller.deleteSelectedToDo(selectedToDo);
                                        selectionMode = false;
                                        selectedToDo = [];

                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Text('confirmation_yes'.tr),
                                  ),
                                ],
                              ),
                        );
                      } else {
                        setState(() {
                          selectionMode = false;
                          selectedToDo = [];
                        });
                      }
                    } else {
                      setState(() {
                        selectionMode = true;
                        selectedToDo = [];
                      });
                    }
                  },
                )
                    : Container();
              }),
            ],
          ),
          body: Obx(() {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: controller.toDoList.length,
                      itemBuilder: (context, int index) {
                        var toDo = controller.getToDoByIndex(index);
                        var endDate = toDo?.endDate != null
                            ? DateFormat('dd MMM yyyy').parse(toDo.endDate)
                            : DateTime.now();
                        var timeLeft = endDate
                            .add(Duration(days: 1))
                            .difference(DateTime.now());
                        var timeLeftHours = timeLeft.inHours;
                        var timeLeftMinutes =
                            timeLeft.inMinutes - (timeLeftHours * 60);

                        return Row(
                          children: [
                            selectionMode
                                ? CommonCheckbox(
                              value: selectedToDo.indexWhere(
                                      (element) =>
                                  element.uuid == toDo?.uuid) >=
                                  0,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    if (selectedToDo.indexWhere(
                                            (element) =>
                                        element.uuid ==
                                            toDo?.uuid) <
                                        0) {
                                      selectedToDo.add(toDo);
                                    }
                                  } else {
                                    if (selectedToDo.indexWhere(
                                            (element) =>
                                        element.uuid ==
                                            toDo?.uuid) >=
                                        0) {
                                      selectedToDo.remove(toDo);
                                    }
                                  }
                                });
                              },
                            )
                                : Container(),
                            Expanded(
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    if (selectionMode) {
                                      setState(() {
                                        if (selectedToDo.indexWhere(
                                                (element) =>
                                            element.uuid == toDo?.uuid) >=
                                            0) {
                                          if (selectedToDo.indexWhere(
                                                  (element) =>
                                              element.uuid ==
                                                  toDo?.uuid) >=
                                              0) {
                                            selectedToDo.remove(toDo);
                                          }
                                        } else {
                                          if (selectedToDo.indexWhere(
                                                  (element) =>
                                              element.uuid ==
                                                  toDo?.uuid) <
                                              0) {
                                            selectedToDo.add(toDo);
                                          }
                                        }
                                      });
                                    } else {
                                      Get.to(() => const AddEditTodo(),
                                          arguments: [{
                                            'toDo': toDo,
                                          }]
                                      );
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              toDo?.title,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'start_date'.tr,
                                                        style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text(
                                                        toDo?.startDate,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'end_date'.tr,
                                                        style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text(
                                                        toDo?.endDate,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'time_left'.tr,
                                                        style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text(
                                                        timeLeftHours >= 0 &&
                                                            timeLeftMinutes >=
                                                                0
                                                            ? 'time_left_duration'
                                                            .trParams({
                                                          'hours':
                                                          timeLeftHours
                                                              .toString(),
                                                          'minutes':
                                                          timeLeftMinutes
                                                              .toString(),
                                                        })
                                                            : 'overdue'.tr,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.cardBottomColor,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 16),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'status'.tr,
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      toDo?.completed == true
                                                          ? 'status_complete'.tr
                                                          : 'status_incomplete'
                                                          .tr,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      controller
                                                          .updateToDoCompleteness(
                                                          toDo?.uuid,
                                                          toDo?.completed ==
                                                              true
                                                              ? false
                                                              : true);
                                                    });
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        'tick_if_completed'.tr,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      CommonCheckbox(
                                                        value:
                                                        toDo?.completed ??
                                                            false,
                                                        onChanged:
                                                            (bool? value) {
                                                          setState(() {
                                                            controller
                                                                .updateToDoCompleteness(
                                                                toDo?.uuid,
                                                                value ??
                                                                    true);
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
                selectionMode && controller.toDoList.isNotEmpty
                    ? CommonButton(
                  data: 'delete_all'.tr,
                    onTap: () {
                      if (controller.toDoList.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                title: Text('are_you_sure'.tr),
                                content: Text('delete_all_confirmation'.tr),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectionMode = false;
                                        selectedToDo = [];

                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Text('confirmation_no'.tr),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        controller.deleteAllToDo();
                                        selectionMode = false;
                                        selectedToDo = [];

                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Text('confirmation_yes'.tr),
                                  ),
                                ],
                              ),
                        );
                      } else {
                        setState(() {
                          selectionMode = false;
                          selectedToDo = [];
                        });
                      }
                    }
                )
                    : Container(),
              ],
            );
          }),
          floatingActionButton: selectionMode
              ? Container()
              : FloatingActionButton(
            child: const Icon(Icons.add),
            backgroundColor: AppColors.floatingActionButtonsColor,
            foregroundColor: Colors.white,
            onPressed: () => Get.to(() => const AddEditTodo()),
          ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
