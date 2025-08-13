import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/auth_controller.dart';
import '../Controllers/todo_controller.dart';
import '../model/counter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _formkeys = GlobalKey<FormState>();
  TextEditingController taskController = TextEditingController();
  final ToDoController todoController = Get.put(ToDoController());

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(40, 40, 240, 1),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "ToDo",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () => Get.defaultDialog(
              title: "Confirm Delete All",
              content: Text("Are you sure you want to Delete All Tasks?"),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => todoController.deleteAllToDos(),
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            icon: Icon(
              Icons.delete_forever_outlined,
              color: Colors.red,
              size: 25,
            ),
          ),
        ],

        leading: IconButton(
          onPressed: () => Get.defaultDialog(
            title: "Confirm Logout",
            content: Text("Are you sure you want to logout?"),
            actions: [
              TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
              TextButton(
                onPressed: () => AuthController().logout(),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
          icon: Icon(Icons.logout, color: Colors.white, size: 25),
        ),
      ),

      body: GetBuilder<ToDoController>(
        init: ToDoController(),
        initState: (_) {},
        builder: (todoController) {
          todoController.getData();

          return Scaffold(
            body: Center(
              child: todoController.isLoading
                ? SizedBox(
                      child: CircularProgressIndicator(color: Colors.black),
                    )
                  : RefreshIndicator(
                    onRefresh: () async {
                      await todoController.getData();
                    },
                    child: Column(
                      children: [
                        Counter(),
                        Expanded(
                          child: ListView.builder(
                            itemCount: todoController.todoList.length,
                            itemBuilder: (context, index) {
                              return FractionallySizedBox(
                                widthFactor: .95,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.only(top: 8),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(42, 42, 255, 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                    child: ListTile(
                                      title: Text(
                                        todoController.todoList[index].task,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                            decoration: todoController.todoList[index].isDone
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                      ),
                                      trailing: SizedBox(
                                        width: 150,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () => todoController.changeState(todoController.todoList[index].docId),
                                              icon: Icon(
                                                todoController.todoList[index].isDone
                                                   ? Icons.check_circle
                                                   : Icons.check_circle_outline,
                                                color: todoController.todoList[index].isDone
                                                   ? Colors.green
                                                   : Colors.white,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                taskController.text = todoController.todoList[index].task;
                                                Get.defaultDialog(
                                                  title: "Update Task",
                                                  titleStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  content: Form(
                                                    key: _formkeys,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 60,
                                                          child: TextFormField(
                                                            controller: taskController,
                                                            maxLength: 20,
                                                            validator: (val) {
                                                              if (val!.isEmpty) {
                                                                return "Please enter a task";
                                                              }return null;
                                                            },
                                                            decoration: InputDecoration(
                                                              hintText: "Write a task",
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            ElevatedButton(
                                                              onPressed: () async {
                                                                if (_formkeys.currentState!.validate()) {
                                                                  await todoController.updateToDo(
                                                                    todoController.todoList[index].docId,
                                                                    taskController.text,
                                                                    false,
                                                                  );
                                                                  taskController.clear();
                                                                  Get.back();
                                                                } else {
                                                                  print("Invalid");
                                                                }
                                                              },
                                                              child: const Text(
                                                                "Save",
                                                                style: TextStyle(color: Colors.white),
                                                              ),
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: Color.fromRGBO(40, 40, 240, 1),
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () => Get.back(),
                                                              child: const Text(
                                                                "Cancel",
                                                                style: TextStyle(color: Colors.white),
                                                              ),
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: Colors.redAccent,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(Icons.edit, size: 20, color: Colors.white),
                                            ),
                                            IconButton(
                                              onPressed: () =>
                                                todoController.DeleteToDo(
                                                  todoController
                                                    .todoList[index]
                                                    .docId,
                                                  ),
                                              icon: const Icon(Icons.delete,size: 20),
                                              color: Colors.red,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ),
                      ],
                    ),
                  ),
            ),

            floatingActionButton: FloatingActionButton(
              backgroundColor: Color.fromRGBO(40, 40, 240, 1),
              child: Icon(Icons.add, color: Colors.white),
              onPressed: () => Get.defaultDialog(
                title: "Add Task",
                titleStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                content: Form(
                  key: _formkeys,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                        child: TextFormField(
                          controller: taskController,
                          maxLength: 20,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Please enter a task";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Write a task",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (_formkeys.currentState!.validate()) {
                                await todoController.addToDo(
                                  taskController.text,
                                  false,
                                  FirebaseAuth.instance.currentUser!.uid,
                                );
                                taskController.clear();
                                Get.back();
                              } else {
                                print("Invalid");
                              }
                            },
                            child: const Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(40, 40, 240, 1),
                            ),
                          ),

                          ElevatedButton(
                            onPressed: () => Get.back(),
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
