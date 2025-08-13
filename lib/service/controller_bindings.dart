import 'package:get/get.dart';
import '../Controllers/auth_controller.dart';
import '../Controllers/todo_controller.dart';


class ControllerBindings extends Bindings{
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(ToDoController());

  }

}