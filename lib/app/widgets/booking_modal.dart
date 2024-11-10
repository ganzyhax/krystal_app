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

  DateTime selectedDate = DateTime.now();
  int selectedDuration = 1; // Duration in hours
  String? selectedTimeSlot;

  // Using the predefined timeSlots list to track availability
  final List<Map<String, dynamic>> timeSlots = List.generate(24, (index) {
    final time = DateFormat("HH:mm").format(DateTime(0, 1, 1, index));
    return {"time": time, "available": true}; // example availability
  });

  @override
  void initState() {
    super.initState();
    dateController.text = _formatDate(selectedDate);
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
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = _formatDate(selectedDate);
      });
    }
  }

  List<Map<String, dynamic>> _generateTimeSlots(int duration) {
    List<Map<String, dynamic>> slots = [];
    for (int hour = 0; hour < timeSlots.length; hour++) {
      final startTime = timeSlots[hour]["time"];
      int endIndex = (hour + duration) % 24;
      final endTime = timeSlots[endIndex]["time"];
      bool available = timeSlots[hour]["available"];
      slots.add({
        "time": "$startTime-$endTime",
        "available": available,
        "period": _getPeriod(hour),
      });
    }
    return slots;
  }

  // Method to determine the period based on the hour of the day
  String _getPeriod(int hour) {
    if (hour >= 6 && hour < 12) {
      return "Morning";
    } else if (hour >= 12 && hour < 18) {
      return "Day";
    } else if (hour >= 18 && hour < 24) {
      return "Evening";
    } else {
      return "Night";
    }
  }

  void _selectTimeSlot(String time) {
    setState(() {
      selectedTimeSlot = time;
    });
  }

  Widget _buildTimeSlotList(
      String periodLabel, List<Map<String, dynamic>> periodSlots) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(periodLabel,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: periodSlots.map((slot) {
            bool isSelected = selectedTimeSlot == slot["time"];
            bool isAvailable = slot["available"];
            return GestureDetector(
              onTap: isAvailable ? () => _selectTimeSlot(slot["time"]) : null,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blueAccent
                      : (isAvailable ? Colors.white : Colors.grey[300]),
                  border: Border.all(
                      color: isSelected ? Colors.blueAccent : Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  slot["time"],
                  style: TextStyle(
                      color: isAvailable ? Colors.black : Colors.grey),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Generate slots for selected duration and group by period
    List<Map<String, dynamic>> allSlots = _generateTimeSlots(selectedDuration);
    List<Map<String, dynamic>> morningSlots =
        allSlots.where((slot) => slot["period"] == "Morning").toList();
    List<Map<String, dynamic>> daySlots =
        allSlots.where((slot) => slot["period"] == "Day").toList();
    List<Map<String, dynamic>> eveningSlots =
        allSlots.where((slot) => slot["period"] == "Evening").toList();
    List<Map<String, dynamic>> nightSlots =
        allSlots.where((slot) => slot["period"] == "Night").toList();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
              controller: nameController,
              label: 'Имя',
              icon: Icons.person,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: phoneController,
              label: 'Телефон',
              icon: Icons.phone,
              inputType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: _buildTextField(
                  controller: dateController,
                  label: 'Дата',
                  icon: Icons.calendar_today,
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Выберите час:'),
              ],
            ),
            SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DropdownButton<int>(
                  value: selectedDuration,
                  items: List.generate(10, (index) => index + 1)
                      .map((hour) => DropdownMenuItem<int>(
                            value: hour,
                            child: Text('$hour час${hour > 1 ? "ов" : ""}'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDuration = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildTimeSlotList("Утро", morningSlots),
            _buildTimeSlotList("День", daySlots),
            _buildTimeSlotList("Вечер", eveningSlots),
            _buildTimeSlotList("Ночь", nightSlots),
            SizedBox(height: 24),
            CustomButton(
              text: 'Подвердить',
              onPressed: () {
                if (selectedTimeSlot != null) {
                  print(
                      "Booking Confirmed for ${nameController.text} at $selectedTimeSlot");
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
    );
  }
}

void showBookingModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return BookingModal();
    },
  );
}
