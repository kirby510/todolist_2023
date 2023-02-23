import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todolist/controllers/todo_controller.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/widgets/common_button.dart';
import 'package:todolist/widgets/common_textformfield.dart';
import 'package:todolist/themes/app_colors.dart' as AppColors;

class AddEditTodo extends StatefulWidget {
  const AddEditTodo({super.key});

  @override
  State<AddEditTodo> createState() => _AddEditTodoState();
}

class _AddEditTodoState extends State<AddEditTodo> {
  ToDo? toDo = null;

  final TextEditingController _toDoTitleController = TextEditingController();
  String? _toDoTitleError;
  final TextEditingController _toDoStartDateController =
      TextEditingController();
  String? _toDoStartDateError;
  final TextEditingController _toDoEndDateController = TextEditingController();
  String? _toDoEndDateError;

  @override
  void initState() {
    super.initState();

    var data = Get.arguments;

    if (data != null) {
      if (data.isNotEmpty) {
        var data0 = data[0];

        if (data0['toDo'] != null) {
          toDo = data0['toDo'];

          _toDoTitleController.value = TextEditingValue(
            text: toDo?.title ?? "",
          );
          _toDoStartDateController.value = TextEditingValue(
            text: toDo?.startDate ?? "",
          );
          _toDoEndDateController.value = TextEditingValue(
            text: toDo?.endDate ?? "",
          );
        }
      }
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
            title:
                Text(toDo?.uuid != null ? 'edit_todo'.tr : 'add_new_todo'.tr),
            actions: [
              toDo?.uuid != null
                  ? IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: 'delete'.tr,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                title: Text('are_you_sure'.tr),
                                content: Text('delete_this_confirmation'.tr),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('confirmation_no'.tr),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (toDo != null) {
                                        controller.deleteToDo(toDo);
                                      }

                                      Navigator.pop(context);

                                      Get.back();
                                    },
                                    child: Text('confirmation_yes'.tr),
                                  ),
                                ],
                              ),
                        );
                      },
              )
                  : Container(),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextFormField(
                        data: 'todo_title'.tr,
                        controller: _toDoTitleController,
                        hintText: 'todo_title_description'.tr,
                        errorText: _toDoTitleError,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      CommonTextFormField(
                        data: 'start_date'.tr,
                        controller: _toDoStartDateController,
                        hintText: 'date_description'.tr,
                        errorText: _toDoStartDateError,
                        onTap: () async {
                          final DateTime? pickedDateTime = await showDatePicker(
                              context: context,
                              initialDate:
                                  _toDoStartDateController.value.text.isNotEmpty
                                      ? DateFormat('dd MMM yyyy').parse(
                                          _toDoStartDateController.value.text)
                                      : DateTime.now(),
                              firstDate: DateTime(2023),
                              lastDate: _toDoEndDateController
                                      .value.text.isNotEmpty
                                  ? DateFormat('dd MMM yyyy')
                                      .parse(_toDoEndDateController.value.text)
                                  : DateTime(2100));

                          setState(() {
                            _toDoStartDateController.value = TextEditingValue(
                              text: DateFormat('dd MMM yyyy')
                                  .format(pickedDateTime!),
                            );
                          });
                        },
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      CommonTextFormField(
                        data: 'end_date'.tr,
                        controller: _toDoEndDateController,
                        hintText: 'date_description'.tr,
                        errorText: _toDoEndDateError,
                        onTap: () async {
                          final DateTime? pickedDateTime = await showDatePicker(
                              context: context,
                              initialDate: _toDoEndDateController
                                      .value.text.isNotEmpty
                                  ? DateFormat('dd MMM yyyy')
                                      .parse(_toDoEndDateController.value.text)
                                  : (_toDoStartDateController
                                          .value.text.isNotEmpty
                                      ? DateFormat('dd MMM yyyy').parse(
                                          _toDoStartDateController.value.text)
                                      : DateTime.now()),
                              firstDate:
                                  _toDoStartDateController.value.text.isNotEmpty
                                      ? DateFormat('dd MMM yyyy').parse(
                                          _toDoStartDateController.value.text)
                                      : DateTime(2023),
                              lastDate: DateTime(2100));

                          setState(() {
                            _toDoEndDateController.value = TextEditingValue(
                              text: DateFormat('dd MMM yyyy')
                                  .format(pickedDateTime!),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              CommonButton(
                data: toDo?.uuid != null ? 'save'.tr : 'create_now'.tr,
                onTap: () {
                  setState(() {
                    var proceed = true;

                    _toDoTitleError = null;
                    _toDoStartDateError = null;
                    _toDoEndDateError = null;

                    if (_toDoTitleController.value.text.isEmpty) {
                      proceed = false;

                      _toDoTitleError = 'todo_title_description'.tr;
                    }

                    if (_toDoStartDateController.value.text.isEmpty) {
                      proceed = false;

                      _toDoStartDateError = 'date_description'.tr;
                    }

                    if (_toDoEndDateController.value.text.isEmpty) {
                      proceed = false;

                      _toDoEndDateError = 'date_description'.tr;
                    }

                    if (proceed) {
                      if (toDo?.uuid != null) {
                        controller.updateToDo(
                            toDo?.uuid,
                            _toDoTitleController.value.text,
                            _toDoStartDateController.value.text,
                            _toDoEndDateController.value.text);
                      } else {
                        controller.addToDo(
                            _toDoTitleController.value.text,
                            _toDoStartDateController.value.text,
                            _toDoEndDateController.value.text);
                      }

                      Get.back();
                    }
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
