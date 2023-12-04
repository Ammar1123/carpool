import 'package:carpool/models/client.dart';
import 'package:carpool/models/route.dart';
import 'package:carpool/services/route_service.dart';
import 'package:flutter/material.dart';

class AddRideScreen extends StatefulWidget {
  final Client driver;
  const AddRideScreen({super.key, required this.driver});

  @override
  _AddRideScreenState createState() => _AddRideScreenState();
}

class _AddRideScreenState extends State<AddRideScreen> {
  String? selectedFrom;
  String? selectedTo;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final TextEditingController priceController =
      TextEditingController(); // Controller for price input
  final RouteService routeService = RouteService(); // Initialize RouteService

  final List<String> locations = [
    'AinShams',
    'Nasr city',
    'New Cairo',
    'Heliopolis',
    'Maadi',
    'October',
    'Madinty',
    'Elshrouk',
    'rehab',
  ]; // Example locations

  List<DropdownMenuItem<String>> _getFromLocations() {
    List<String> filteredLocations = List<String>.from(locations);
    if (selectedTo == 'AinShams') {
      filteredLocations.remove('AinShams');
    }
    return _buildDropdownMenuItems(filteredLocations);
  }

  List<DropdownMenuItem<String>> _getToLocations() {
    List<String> filteredLocations = List<String>.from(locations);
    if (selectedFrom == 'AinShams') {
      filteredLocations.remove('AinShams');
    }
    return _buildDropdownMenuItems(filteredLocations);
  }

  List<DropdownMenuItem<String>> _buildDropdownMenuItems(
      List<String> locations) {
    return locations.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          value,
          style: const TextStyle(color: Colors.black),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Ride'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('From',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8), // Spacing between label and dropdown

            DropdownButtonFormField<String>(
              value: selectedFrom,
              hint: const Text('From'),
              items: _getFromLocations(),
              onChanged: (newValue) {
                setState(() {
                  selectedFrom = newValue;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor:
                    Colors.grey[300], // Background color for dropdown list
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 8), // Spacing between label and dropdown

            const Text('To',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedTo,
              hint: const Text('To'),
              items: _getToLocations(),
              onChanged: (newValue) {
                setState(() {
                  selectedTo = newValue;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor:
                    Colors.grey[300], // Background color for dropdown list
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Time',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8), // Spacing between label and dropdown

            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[300],
                    labelText:
                        'Time: ${selectedDate.year}/${selectedDate.month}/${selectedDate.day} ${selectedTime.hour}:${selectedTime.minute}',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Price',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.number, // Use number keyboard
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                routeService.addNewRoute(CarpoolRoute(
                  startLocation: selectedFrom!,
                  endLocation: selectedTo!,
                  time: selectedDate,
                  price: double.parse(priceController.text),
                  id: DateTime.now().toString(),
                  driverId: widget.driver.id,
                  driverName: widget.driver.name,
                ));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ride added successfully'),
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50), // Wide button
              ),
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );
      if (pickedTime != null && pickedTime != selectedTime) {
        setState(() {
          selectedTime = pickedTime;
        });
      }
    }
  }
}
