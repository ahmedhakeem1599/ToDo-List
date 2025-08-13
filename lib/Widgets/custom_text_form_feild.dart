import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({super.key, required this.hintText, required this.myController, required this.icon});

  final String hintText;
  final TextEditingController myController;
  final Icon? icon;


  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.95,
      child: TextFormField(
        style: const TextStyle(color: Colors.black, fontSize: 13),
        validator: (value) {
          if (value == "") {
            return 'canot be empty';
          }
          return null;
        },
        controller: myController,
        decoration: InputDecoration(
          prefixIcon: icon,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
