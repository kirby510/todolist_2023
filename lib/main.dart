import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todolist/screens/todo_list.dart';
import 'package:todolist/themes/app_colors.dart' as AppColors;
import 'package:todolist/utils/todo_translations.dart';

void main() async {
  await GetStorage.init();

  runApp(GetMaterialApp(
    translations: ToDoTranslations(),
    locale: Get.locale ?? const Locale('en', 'US'),
    fallbackLocale: const Locale('en', 'US'),
    theme: ThemeData(
      primarySwatch: AppColors.primaryColor,
    ),
    home: const ToDoList(),
  ));
}
