import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ScrollController _scrollController = ScrollController();
  DateTime selectedDate = DateTime.now();
  final double itemWidth = 100.0;
  final int itemCount = 365;
  final int visibleItems = 7;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrentDate());

    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      int index = (offset / itemWidth).round() + (visibleItems ~/ 2);
      DateTime firstDate = DateTime.now().subtract(
        Duration(days: itemCount ~/ 2),
      );
      DateTime newSelectedDate = firstDate.add(Duration(days: index));
      setState(() => selectedDate = newSelectedDate);
    });
  }

  void _scrollToCurrentDate() {
    DateTime firstDate = DateTime.now().subtract(
      Duration(days: itemCount ~/ 2),
    );
    int currentIndex = DateTime.now().difference(firstDate).inDays;
    _scrollController.animateTo(
      (currentIndex - (visibleItems ~/ 2)) * itemWidth,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Horizontal Date Picker',
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Selected Date: ${DateFormat('E dd').format(selectedDate)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 100,
                width: itemWidth * visibleItems,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  itemCount: itemCount,
                  itemExtent: itemWidth,
                  itemBuilder: (context, index) {
                    DateTime firstDate = DateTime.now().subtract(
                      Duration(days: itemCount ~/ 2),
                    );
                    DateTime date = firstDate.add(Duration(days: index));
                    bool isSelected =
                        date.day == selectedDate.day &&
                        date.month == selectedDate.month &&
                        date.year == selectedDate.year;

                    return Container(
                      width: itemWidth,
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('E').format(date),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isSelected ? Colors.blue : Colors.grey,
                                ),
                              ),
                              Text(
                                date.day.toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isSelected ? Colors.blue : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          if (isSelected)
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(top: 10),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
