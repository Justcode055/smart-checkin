import 'package:flutter/material.dart';

// Mood slider widget (1-5)
class MoodSlider extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onChanged;

  const MoodSlider({
    super.key,
    this.initialValue = 3,
    required this.onChanged,
  });

  @override
  State<MoodSlider> createState() => _MoodSliderState();
}

class _MoodSliderState extends State<MoodSlider> {
  late int _moodValue;

  @override
  void initState() {
    super.initState();
    _moodValue = widget.initialValue;
  }

  String _getMoodEmoji(int value) {
    switch (value) {
      case 1:
        return '😞';
      case 2:
        return '😕';
      case 3:
        return '😐';
      case 4:
        return '🙂';
      case 5:
        return '😄';
      default:
        return '😐';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('How are you feeling?', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            return Column(
              children: [
                Text(_getMoodEmoji(index + 1), style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 8),
                Text('${index + 1}'),
              ],
            );
          }),
        ),
        const SizedBox(height: 16),
        Slider(
          value: _moodValue.toDouble(),
          min: 1,
          max: 5,
          divisions: 4,
          label: _moodValue.toString(),
          onChanged: (value) {
            setState(() {
              _moodValue = value.toInt();
            });
            widget.onChanged(_moodValue);
          },
        ),
      ],
    );
  }
}
