import 'package:flutter/material.dart';

class CommonCheckbox extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;

  const CommonCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      child: Checkbox(
        checkColor:
        Colors.black,
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}