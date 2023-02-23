import 'package:get/get.dart';

class ToDoTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'todo_list': 'To-Do List',
      'add_new_todo': 'Add New To-Do List',
      'todo_title': 'To-Do Title',
      'todo_title_description': 'Please key in your To-Do Title here.',
      'start_date': 'Start Date',
      'date_description': 'Select a date.',
      'end_date': 'End Date',
      'create_now': 'Create Now',
      'time_left': 'Time Left',
      'time_left_duration': '@hours hrs @minutes min',
      'status': 'Status',
      'status_incomplete': 'Incomplete',
      'status_complete': 'Completed',
      'tick_if_completed': 'Tick if completed',
      'delete': 'Delete',
      'are_you_sure': 'Are you sure?',
      'delete_confirmation': 'Do you want to delete the selected To-Do?',
      'confirmation_yes': 'Yes',
      'confirmation_no': 'No',
      'delete_all': 'Delete All',
      'delete_all_confirmation': 'Do you want to delete all To-Dos?',
      'overdue': 'Overdue',
      'edit_todo': 'Edit To-Do',
      'save': 'Save',
      'delete_this_confirmation': 'Do you want to delete this To-Do?',
    },
  };
}