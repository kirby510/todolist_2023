import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todolist/models/todo.dart';
import 'package:uuid/uuid.dart';

class ToDoController extends GetxController {
  GetStorage box = GetStorage();
  var uuid = Uuid();
  var toDoList = [].obs;

  @override
  void onInit() async {
    super.onInit();

    toDoList.value = jsonDecode(await box.read('toDoList') ?? '[]').map((data) => ToDo.fromJson(data)).toList();
  }

  addToDo(String? title, String? startDate, String? endDate) async {
    toDoList.add(ToDo(
      uuid: uuid.v4(),
      title: title,
      startDate: startDate,
      endDate: endDate,
    ));

    await box.write('toDoList', jsonEncode(toDoList));

    update();
  }

  getToDoByIndex(int index) {
    if (toDoList.length > index) {
      return toDoList[index] as ToDo;
    } else {
      return null;
    }
  }

  updateToDoCompleteness(String? uuid, bool completed) async {
    var index = toDoList.indexWhere((element) => element.uuid == uuid);

    if (index >= 0 && toDoList.length > index) {
      (toDoList[index] as ToDo).completed = completed;

      await box.write('toDoList', jsonEncode(toDoList));

      update();
    }
  }

  deleteToDo(ToDo? toDo) async {
    var index = toDoList.indexWhere((element) => element.uuid == toDo?.uuid);

    if (index >= 0 && toDoList.length > index) {
      toDoList.remove(toDo);

      await box.write('toDoList', jsonEncode(toDoList));

      update();
    }
  }

  deleteSelectedToDo(List selectedToDo) {
    selectedToDo.forEach((element) async {
      var uuid = (element as ToDo).uuid;
      var index = toDoList.indexWhere((element) => element.uuid == uuid);

      if (index >= 0 && toDoList.length > index) {
        toDoList.remove(element);

        await box.write('toDoList', jsonEncode(toDoList));

        update();
      }
    });
  }

  deleteAllToDo() async {
    toDoList.value = [];

    await box.write('toDoList', jsonEncode(toDoList));

    update();
  }

  updateToDo(String? uuid, String? title, String? startDate, String? endDate) async {
    var index = toDoList.indexWhere((element) => element.uuid == uuid);

    if (index >= 0 && toDoList.length > index) {
      (toDoList[index] as ToDo).title = title;
      (toDoList[index] as ToDo).startDate = startDate;
      (toDoList[index] as ToDo).endDate = endDate;

      await box.write('toDoList', jsonEncode(toDoList));

      update();
    }
  }
}