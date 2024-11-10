import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sauna_krystal/app/widgets/custom_button.dart';

class BookingModal extends StatefulWidget {
  @override
  _BookingModalState createState() => _BookingModalState();
}

class _BookingModalState extends State<BookingModal> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> timeSlots = [];
  String? selectedStartSlot;
  String? selectedEndSlot;
  int selectedDuration = 1; // in hours
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    dateController.text = _formatDate(selectedDate);
    _loadTimeSlots();
  }

  // Load time slots, here we are simulating data.
  void _loadTimeSlots() async {
    final dateKey = DateFormat('dd-MM-yyyy').format(selectedDate);
    final doc = await _firestore.collection('booking').doc(dateKey).get();
    if (doc.exists) {
      timeSlots = List<Map<String, dynamic>>.from(doc['timeSlots']);
    } else {
      timeSlots = List.generate(24, (index) {
        String hour = index.toString().padLeft(2, '0');
        return {
          'time': '$hour:00',
          'available': true, // Simulate all times being available for now
        };
      });
      await _firestore.collection('booking').doc(dateKey).set({
        'timeSlots': timeSlots,
      });
    }
    setState(() {});
  }

  List<String> _getAvailableIntervals(int duration) {
    List<String> availableIntervals = [];

    for (int i = 0; i < timeSlots.length - duration + 1; i++) {
      bool isIntervalAvailable = true;

      // Check consecutive slots for availability
      for (int j = 0; j < duration; j++) {
        if (!timeSlots[i + j]['available']) {
          isIntervalAvailable = false;
          break;
        }
      }

      if (isIntervalAvailable) {
        String startSlot = timeSlots[i]['time'];
        int startHour = int.parse(startSlot.split(":")[0]);
        int endHour = (startHour + duration) % 24;

        String endSlot = '${endHour.toString().padLeft(2, '0')}:00';
        availableIntervals.add('$startSlot - $endSlot');
      }
    }

    return availableIntervals;
  }

  Map<String, List<String>> _getCategorizedIntervals(int duration) {
    List<String> availableIntervals = _getAvailableIntervals(duration);

    Map<String, List<String>> categorizedIntervals = {
      'Morning': [],
      'Day': [],
      'Evening': [],
      'Night': [],
    };

    for (String interval in availableIntervals) {
      int startHour = int.parse(interval.split(":")[0]);

      if (startHour >= 6 && startHour < 12) {
        categorizedIntervals['Morning']?.add(interval);
      } else if (startHour >= 12 && startHour < 17) {
        categorizedIntervals['Day']?.add(interval);
      } else if (startHour >= 17 && startHour < 24) {
        categorizedIntervals['Evening']?.add(interval);
      } else {
        categorizedIntervals['Night']?.add(interval);
      }
    }

    return categorizedIntervals;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<String>> categorizedIntervals =
        _getCategorizedIntervals(selectedDuration);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Забронировать',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close))
                ],
              ),
              SizedBox(height: 10),
              _buildTextField(
                  controller: nameController, label: 'Имя', icon: Icons.person),
              SizedBox(height: 16),
              _buildTextField(
                  controller: phoneController,
                  label: 'Телефон',
                  icon: Icons.phone,
                  inputType: TextInputType.phone),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: _buildTextField(
                      controller: dateController,
                      label: 'Дата',
                      icon: Icons.calendar_today),
                ),
              ),
              SizedBox(height: 16),
              Text('Выберите продолжительность:',
                  style: TextStyle(fontSize: 16)),
              DropdownButton<int>(
                value: selectedDuration,
                items: List.generate(10, (index) => index + 1)
                    .map((hour) => DropdownMenuItem<int>(
                        value: hour,
                        child: Text('$hour ${hour == 1 ? "час" : "часов"}')))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDuration = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              ..._buildTimeCategorySection(
                  'Утро', categorizedIntervals['Morning']),
              ..._buildTimeCategorySection('День', categorizedIntervals['Day']),
              ..._buildTimeCategorySection(
                  'Вечер', categorizedIntervals['Evening']),
              ..._buildTimeCategorySection(
                  'Ночь', categorizedIntervals['Night']),
              SizedBox(height: 16),
              CustomButton(
                onPressed: () async {
                  if (selectedStartSlot != null && selectedEndSlot != null) {
                    // Convert selected start and end times to hours
                    int startHour = int.parse(selectedStartSlot!.split(":")[0]);
                    int endHour = int.parse(selectedEndSlot!.split(":")[0]);

                    // Create a list of time slots to mark as unavailable and add booking details
                    List<Map<String, dynamic>> slotsToUpdate = [];
                    for (int hour = startHour; hour <= endHour; hour++) {
                      String slot = '${hour.toString().padLeft(2, '0')}:00';
                      slotsToUpdate.add({
                        'time': slot,
                        'available': false,
                        'bookedBy': {
                          'name': nameController.text,
                          'phone': phoneController.text,
                        }
                      });
                    }

                    final dateKey =
                        DateFormat('dd-MM-yyyy').format(selectedDate);
                    final docRef =
                        _firestore.collection('booking').doc(dateKey);

                    // Update Firestore to mark the selected time slots as unavailable and add booking details
                    await docRef.update({
                      'timeSlots': FieldValue.arrayUnion(slotsToUpdate),
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Бронирование успешно!',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // Close the modal after booking
                    Navigator.pop(context);
                  }
                },
                text: 'Забронировать',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      required IconData icon,
      TextInputType inputType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final tomorrow = now.add(Duration(days: 1));

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return "Сегодня";
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return "Завтра";
    } else {
      return DateFormat('dd MMM', 'ru').format(date);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2025),
        ) ??
        selectedDate;

    setState(() {
      selectedDate = picked;
      dateController.text = _formatDate(picked);
    });

    _loadTimeSlots();
  }

  // Builds the widget section for each time period category (Morning, Day, etc.)
  List<Widget> _buildTimeCategorySection(
      String category, List<String>? intervals) {
    if (intervals == null || intervals.isEmpty) {
      return [Text('$category: No available time slots.')];
    } else {
      return [
        Text('$category:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Wrap(
          spacing: 8.0, // space between items
          runSpacing: 8.0, // space between lines
          children: intervals.where((interval) {
            // Filter out unavailable slots
            int startHour = int.parse(interval.split(" - ")[0].split(":")[0]);
            int endHour = int.parse(interval.split(" - ")[1].split(":")[0]);

            // Check availability of all slots in the range
            for (int i = startHour; i <= endHour; i++) {
              String slot = '${i.toString().padLeft(2, '0')}:00';
              if (timeSlots.any((element) =>
                  element['time'] == slot && !element['available'])) {
                return false; // If any slot in the range is unavailable
              }
            }

            return true;
          }).map((interval) {
            bool isSelected = selectedStartSlot == interval.split(" - ")[0];

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedStartSlot = interval.split(" - ")[0];
                  selectedEndSlot = interval.split(" - ")[1];
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                margin: EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.white,
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(interval, style: TextStyle(fontSize: 16)),
              ),
            );
          }).toList(),
        ),
      ];
    }
  }
}
