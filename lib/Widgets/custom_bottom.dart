import 'package:flutter/material.dart';

class CustomBottom extends StatelessWidget {
  const CustomBottom({super.key, required this.title, this.onPressed});

  final String title;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.80,
      child: MaterialButton(
          onPressed: onPressed,
          color: Color.fromRGBO(40, 40, 240, 1),
          height: 50,
          minWidth: double.infinity,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100)
          ),
          child: Text(
              title ,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white ,
                  fontWeight: FontWeight.bold
              )
          )
      ),
    );
  }
}
