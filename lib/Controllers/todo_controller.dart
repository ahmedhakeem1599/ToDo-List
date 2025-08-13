import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../model/task_model.dart';

class ToDoController extends GetxController {

  var isLoading = true;
  var todoList = <TaskModel>[];
  var allTasks = 0;
  var allCompletedTasks = 0;

  Future<void> addToDo(String task, bool done, String id) async {
    try{
    await FirebaseFirestore.instance
        .collection('todos')
        .doc()
        .set({"task": task, "isDone": done, "id": id}, SetOptions(merge: true))
        .then((value) => Get.back());
    updateTaskCounts();
    }
    catch (e) {
      Get.snackbar("Error", "Failed to add task: $e",
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> getData() async {
    try {

      QuerySnapshot _TaskSnapshot = await FirebaseFirestore.instance
          .collection('todos')
          .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      todoList.clear();
      for (var item in _TaskSnapshot.docs) {
        todoList.add(
            TaskModel(
              item['task'],
              item['isDone'],
              item['id'],
              item.id,
        ));
      }
      updateTaskCounts();
      isLoading = false ;
      update();
    }
    catch (e) {
      Get.snackbar("Error", "Failed to get data: $e",
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> DeleteToDo(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('todos')
          .doc(docId)
          .delete();
      todoList.removeWhere((task) => task.docId == docId);
      updateTaskCounts();
    } catch (e) {
      Get.snackbar("Error", "Failed to delete task: $e",
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> deleteAllToDos() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('todos')
          .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      for (var doc in querySnapshot.docs) {
        await FirebaseFirestore.instance.collection('todos').doc(doc.id).delete();
      }
      Get.back();
      todoList.clear();
      updateTaskCounts();

    } catch (e) {
      Get.snackbar("Error", "Failed to delete all tasks: $e",
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> updateToDo(String docId, String newTask, bool newDone) async {
    try {
      await FirebaseFirestore.instance
          .collection('todos')
          .doc(docId)
          .update({
        "task": newTask,
        "isDone": newDone,
      });
      Get.back();
      int index = todoList.indexWhere((task) => task.docId == docId);
      if (index != -1) {
        todoList[index] = TaskModel(newTask, newDone, todoList[index].id, docId);
      }
      updateTaskCounts();

    } catch (e) {
      Get.snackbar("Error", "Failed to update task: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> changeState(String docId) async {
    try {
      int index = todoList.indexWhere((task) => task.docId == docId);
      if (index != -1) {
        bool newState = !todoList[index].isDone;
        await FirebaseFirestore.instance
            .collection('todos')
            .doc(docId)
            .update({"isDone": newState});
        todoList[index] = TaskModel(
          todoList[index].task,
          newState,
          todoList[index].id,
          docId,
        );
        updateTaskCounts(); // تحديث العدادات

      }
    } catch (e) {
      Get.snackbar("Error", "Failed to change task state: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void updateTaskCounts() {
    allTasks = todoList.length;
    allCompletedTasks = todoList.where((task) => task.isDone).length;
  }


}
