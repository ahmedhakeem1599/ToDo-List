import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/todo_controller.dart';

class Counter extends StatelessWidget {
  const Counter({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ToDoController>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(
            '${controller.allCompletedTasks} / ${controller.allTasks}',
            style: TextStyle(
              color: (controller.allCompletedTasks == controller.allTasks)
                  ? Color.fromRGBO(40, 40, 240, 1)
                  : Colors.black,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}