import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime> onDateSelected;
  final String label;

  const DatePicker({
    super.key,
    this.initialDate,
    required this.onDateSelected,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: initialDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) onDateSelected(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          initialDate != null
              ? '${initialDate!.toLocal()}'.split(' ')[0]
              : 'Select date',
        ),
      ),
    );
  }
}
