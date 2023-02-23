import 'package:flutter/material.dart';
import 'package:todolist/themes/app_colors.dart' as AppColors;

class CommonButton extends StatelessWidget {
  final String data;
  final GestureTapCallback? onTap;

  const CommonButton({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.buttonBottomColor,
      child: InkWell(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
            ),
            child: Text(
              data,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}