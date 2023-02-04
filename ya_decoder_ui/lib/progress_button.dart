import 'package:flutter/material.dart';

class ProgressButton extends StatefulWidget {
  final String text;
  final Function onPressed;

  const ProgressButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  ProgressButtonState createState() => ProgressButtonState();
}

class ProgressButtonState extends State<ProgressButton> {
  bool _isInProgress = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isInProgress
          ? null
          : () async {
              setState(() {
                _isInProgress = true;
              });
              try {
                await widget.onPressed();
              } finally {
                setState(() {
                  _isInProgress = false;
                });
              }
            },
      child:
          _isInProgress ? const CircularProgressIndicator() : Text(widget.text),
    );
  }
}
