import 'package:flutter/material.dart';
import 'package:syncspace/utils/colours.dart';

class MeetingOption extends StatelessWidget {
  final String text;
  final bool ismute;
  final Function(bool) onChange;
  const MeetingOption({
    super.key,
    required this.text,
    required this.ismute,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: secondaryBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text, style: const TextStyle(fontSize: 16),),
          ),
          Switch(value: ismute, onChanged: onChange),
        ],
      ),
    );
  }
}
