import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo/Controllers/todo_controller.dart';
import '../service/auth_service.dart';


class AuthController extends GetxController {
  final AuthService _authService = AuthService();


  Future<void> logIn(String email, String password) async {
    try {
      await _authService.login(email, password); 
      Get.snackbar("Success", "Logged in successfully",
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.white70);
      Get.offAllNamed('/home');
    } catch (e) {
      if (e is FirebaseAuthException) {
        String errorMessage = "Login failed: An unknown error occurred";
        switch (e.code) {
          case 'invalid-email':
            errorMessage = "The email address is not valid.";
            break;
          case 'wrong-password':
            errorMessage = "Incorrect password. Please try again.";
            break;
          case 'user-not-found':
            errorMessage = "No account found with this email.";
            break;
          case 'user-disabled':
            errorMessage = "This account has been disabled.";
            break;
          case 'too-many-requests':
            errorMessage = "Too many attempts. Please try again later.";
            break;
          case 'network-request-failed':
            errorMessage = "No internet connection. Please check your network.";
            break;
          default:
            errorMessage = "Login failed: ${e.message}";
        }
        AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: "Error",
          desc: errorMessage,
          btnOkOnPress: () {},
          btnOkColor: Colors.red,
        ).show();


      } else {
        Get.snackbar("Error", "Login failed: $e",
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.red);
      }
    }
  }

  Future<void> Register(String email, String password) async {
    try {
      await _authService.register(email, password);
      logout();
      Get.offAllNamed("/login");
    } catch (e) {
      if (e is FirebaseAuthException) {
        String errorMessage = "Registration failed: An unknown error occurred";
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = "This email is already in use. Try another one.";
            break;
          case 'invalid-email':
            errorMessage = "The email address is not valid.";
            break;
          case 'weak-password':
            errorMessage = "Password is too weak. Use at least 6 characters.";
            break;
          case 'operation-not-allowed':
            errorMessage = "Email/password accounts are not enabled.";
            break;
          case 'network-request-failed':
            errorMessage = "No internet connection. Please check your network.";
            break;
          default:
            errorMessage = "Registration failed: ${e.message}";
        }
        AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: "Error",
          desc: errorMessage,
          btnOkOnPress: () {},
          btnOkColor: Colors.red,
        ).show();
      } else {
        Get.snackbar("Error", "Registration failed: $e",
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.red);
      }
    }
  }

  Future<void> SignInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.warning,
          animType: AnimType.rightSlide,
          title: "Cancelled",
          desc: "Sign-in process was cancelled by the user.",
          btnOkOnPress: () {},
          btnOkColor: Colors.orange,
        ).show();
        return;
      }
      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Get.snackbar("Success", "Logged in successfully",
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.blue);
      Get.offAllNamed('/home');
    } catch (e) {
      if (e is FirebaseAuthException) {
        String errorMessage = "Google sign-in failed: An unknown error occurred";
        switch (e.code) {
          case 'invalid-credential':
            errorMessage = "Invalid Google credentials. Please try again.";
            break;
          case 'user-disabled':
            errorMessage = "This account has been disabled.";
            break;
          case 'operation-not-allowed':
            errorMessage = "Google sign-in is not enabled.";
            break;
          default:
            errorMessage = "Google sign-in failed: ${e.message}";
        }
        AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: "Error",
          desc: errorMessage,
          btnOkOnPress: () {},
          btnOkColor: Colors.red,
        ).show();
      } else if (e is PlatformException) {
        String errorMessage = "Google sign-in failed: An unknown error occurred";
        switch (e.code) {
          case 'account-selection-cancelled':
            errorMessage = "Sign-in process was cancelled by the user.";
            break;
          case 'network_error':
            errorMessage = "No internet connection. Please check your network.";
            break;
          case 'sign_in_failed':
            errorMessage = "Sign-in failed. Please try again later.";
            break;
          default:
            errorMessage = "Google sign-in failed: ${e.message}";
        }
        AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: "Error",
          desc: errorMessage,
          btnOkOnPress: () {},
          btnOkColor: Colors.red,
        ).show();
      } else {
        Get.snackbar("Error", "Google sign-in failed: $e",
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.red);
      }
    }
  }

  Future<void> logout() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
      final ToDoController todoController = Get.find<ToDoController>();
      todoController.todoList.clear();
      todoController.update();
      Get.offAllNamed('/login');
    } catch (e) {
      if (e is PlatformException) {
        String errorMessage = "Logout failed: An unknown error occurred";
        switch (e.code) {
          case 'network_error':
            errorMessage = "No internet connection. Please check your network.";
            break;
          case 'sign-out-failed':
            errorMessage = "Failed to sign out from Google. Please try again.";
            break;
          default:
            errorMessage = "Logout failed: ${e.message}";
        }
        AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: "Error",
          desc: errorMessage,
          btnOkOnPress: () {},
          btnOkColor: Colors.red,
        ).show();
      } else {
        Get.snackbar("Error", "Logout failed: $e",
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.red);
      }
    }
  }

  Future<void> ForgotPassword(String email) async {
    try {
      await _authService.ForgotPassword(email);
      Get.snackbar("Success", "Password reset email sent",
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.blue);
    } catch (e) {
      if (e is FirebaseAuthException) {
        String errorMessage = "Password reset failed: An unknown error occurred";
        switch (e.code) {
          case 'invalid-email':
            errorMessage = "The email address is not valid.";
            break;
          case 'user-not-found':
            errorMessage = "No account found with this email.";
            break;
          case 'too-many-requests':
            errorMessage = "Too many requests. Please try again later.";
            break;
          case 'network-request-failed':
            errorMessage = "No internet connection. Please check your network.";
            break;
          case 'operation-not-allowed':
            errorMessage = "Password reset is not enabled.";
            break;
          default:
            errorMessage = "Password reset failed: ${e.message}";
        }
        AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: "Error",
          desc: errorMessage,
          btnOkOnPress: () {},
          btnOkColor: Colors.red,
        ).show();
      } else {
        Get.snackbar("Error", "Password reset failed: $e",
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.red);
      }
    }
  }

}
