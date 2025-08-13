import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/auth_controller.dart';
import '../Widgets/custom_bottom.dart';
import '../Widgets/custom_text_form_feild.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = Get.find<AuthController>();
  bool isLoading = false;


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 70),
            width: double.infinity,
            color: Color.fromRGBO(40, 40, 240, 1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "ToDo",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),

                Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.78,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100),
                    ),
                  ),
                  child: Column(
                    children: [
                      Image.asset("assets/login.jpg", height: 180),
                      SizedBox(height: 10),
                      Text(
                        "Please log in With your email ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30),

                      CustomTextFormField(
                        hintText: 'Enter Email',
                        myController: emailController,
                        icon: Icon(Icons.email),
                      ),
                      SizedBox(height: 10),

                      CustomTextFormField(
                        hintText: 'Enter Password',
                        myController: passwordController,
                        icon: Icon(Icons.lock_outline),
                      ),

                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: ()  {
                            _authController.ForgotPassword(emailController.text);
                          },
                          child: Text(
                            'Forget Password?',
                            style: TextStyle(
                              color: Color.fromRGBO(40, 40, 240, 1),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      CustomBottom(
                        title: isLoading ? 'Loading...' : 'Log in',
                        onPressed: ()  {
                          if (_formKey.currentState!.validate()) {
                            _authController.logIn(emailController.text, passwordController.text);
                          }
                        },
                      ),
                      Spacer(),
                      Text(
                        "       Or \nLog in With",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.grey),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: IconButton(
                              icon: Image.asset(
                                "assets/facebook.png",
                                height: 30,
                              ),
                              onPressed: () {
                                CoustomAwesomeDialog.showSuccessDialog(
                                  context,
                                  'Error',
                                  'This feature is not available yet.',
                                  DialogType.error,
                                );
                              },
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.grey),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: IconButton(
                              icon: Image.asset(
                                "assets/google.png",
                                height: 30,
                              ),
                              onPressed: () async {
                                await _authController.SignInWithGoogle();
                              },
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.grey),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: IconButton(
                              icon: Image.asset("assets/apple.png", height: 30),
                              onPressed: () {
                                CoustomAwesomeDialog.showSuccessDialog(
                                  context,
                                  'Error',
                                  'This feature is not available yet.',
                                  DialogType.error,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Spacer(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account ?",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 2),
                          GestureDetector(
                            onTap: () {
                              Get.offAllNamed("/register");
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(40, 40, 240, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CoustomAwesomeDialog {
  static void showSuccessDialog(
      BuildContext context,
      String title,
      String desc,
      DialogType dialogType,
      ) {
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.rightSlide,
      title: title,
      desc: desc,
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
    ).show();
  }
}
