import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:to_do_list/database/database_helper.dart';
import 'package:to_do_list/models/page_meta.dart';
import 'package:to_do_list/models/to_do_model.dart';

class HomeProvider with ChangeNotifier {
  List<ToDoModel> _tasks = [];
  ViewState _state = ViewState.initial;
  PageMeta _pageMeta = PageMeta();
  final TextEditingController titleController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<ToDoModel> get tasks => _tasks;

  ViewState get state => _state;

  Future<void> getTaskList({bool loadMore = false}) async {
    try {
      if (loadMore && _pageMeta.hasNext) {
        _pageMeta = _pageMeta.copyWith(offset: _pageMeta.offset + 1);
        _state = ViewState.loadingMore;
        notifyListeners();
      } else {
        _pageMeta = PageMeta();
        _state = ViewState.loading;
        notifyListeners();
      }
      final data = await DatabaseHelper.instance.getToDoList(
        _pageMeta,
      );
      if (loadMore) {
        _tasks.addAll(data);
      } else {
        _tasks = data;
      }
      _pageMeta = _pageMeta.copyWith(hasNext: data.length == _pageMeta.limit);
      _state = ViewState.initial;
      notifyListeners();
    } catch (e) {
      _state = ViewState.initial;
      notifyListeners();
      debugPrint('$e');
      Fluttertoast.showToast(
          msg: 'Something went wrong! Please try again later.',
          backgroundColor: Colors.red);
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      _state = ViewState.deleting;
      notifyListeners();
      await DatabaseHelper.instance.deleteToDoTask(id);
      _state = ViewState.initial;
      notifyListeners();
      getTaskList();
    } catch (e) {
      _state = ViewState.initial;
      notifyListeners();
      debugPrint('$e');
      Fluttertoast.showToast(
          msg: 'Something went wrong! Please try again later.',
          backgroundColor: Colors.red);
    }
  }

  Future<void> storeTask() async {
    try {
      _state = ViewState.creating;
      notifyListeners();
      await DatabaseHelper.instance.storeToDoTask(ToDoModel(
        title: titleController.text.trim(),
        isCompleted: false,
      ));
      _state = ViewState.initial;
      notifyListeners();
      getTaskList();
    } catch (e) {
      _state = ViewState.initial;
      notifyListeners();
      debugPrint('$e');
      Fluttertoast.showToast(
          msg: 'Something went wrong! Please try again later.',
          backgroundColor: Colors.red);
    }
  }

  Future<void> updateTask(int index, {bool? isCompleted}) async {
    try {
      _state = ViewState.editing;
      notifyListeners();
      await DatabaseHelper.instance.updateToDoTask(tasks[index].copyWith(
          title: isCompleted == true
              ? tasks[index].title
              : titleController.text.trim(),
          isCompleted: isCompleted ?? tasks[index].isCompleted));
      _state = ViewState.initial;
      notifyListeners();
      getTaskList();
    } catch (e) {
      _state = ViewState.initial;
      notifyListeners();
      debugPrint('$e');
      Fluttertoast.showToast(
          msg: 'Something went wrong! Please try again later.',
          backgroundColor: Colors.red);
    }
  }
}

enum ViewState {
  loading,
  creating,
  editing,
  initial,
  deleting,
  loadingMore,
}
