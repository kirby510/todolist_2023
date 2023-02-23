import 'package:flutter/material.dart';

class CommonTextFormField extends StatelessWidget {
  final String data;
  final TextEditingController? controller;
  final String? hintText;
  final String? errorText;
  final GestureTapCallback? onTap;

  const CommonTextFormField({
    super.key,
    required this.data,
    this.controller,
    this.hintText,
    this.errorText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        onTap != null ? GestureDetector(
          onTap: onTap,
          child: buildTextFormField(),
        ) : buildTextFormField(),
      ],
    );
  }

  Widget buildTextFormField() {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide:
          const BorderSide(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide:
          const BorderSide(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        errorBorder: OutlineInputBorder(
          borderSide:
          const BorderSide(width: 1, color: Colors.red),
          borderRadius: BorderRadius.circular(4),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
        suffixIcon: onTap != null ? const Icon(Icons.arrow_drop_down) : null,
        suffixIconColor: onTap != null ?
        (controller?.value.text.isNotEmpty == true
            ? Colors.black
            : Colors.grey) : null,
        errorText: errorText,
        errorStyle: const TextStyle(
          fontSize: 16,
          color: Colors.red,
        ),
      ),
      enabled: onTap != null ? false : true,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    );
  }
}