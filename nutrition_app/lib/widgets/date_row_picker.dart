import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class DateRowPicker extends StatefulWidget {
  final DateTime date;
  final Function() onBackPressed;
  final Function() onForwardPressed;

  const DateRowPicker({
    Key? key,
    required this.date,
    required this.onBackPressed,
    required this.onForwardPressed,
  }) : super(key: key);

  @override
  State<DateRowPicker> createState() => _DateRowPickerState();
}

class _DateRowPickerState extends State<DateRowPicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: widget.onBackPressed,
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            size: 18.0,
          ),
        ),
        Text(
          DateFormat('MMMM, yyyy').format(widget.date),
          style: Theme.of(context).textTheme.subtitle2,
        ),
        IconButton(
          onPressed: widget.onForwardPressed,
          icon: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18.0,
          ),
        ),
      ],
    );
  }
}
