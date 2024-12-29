import 'package:flutter/material.dart';

class LocationDropdown extends StatefulWidget {
  final List<String> locations;
  final void Function(String) onLocationChanged;

  const LocationDropdown({
    required this.locations,
    required this.onLocationChanged,
    super.key,
  });

  @override
  LocationDropdownState createState() => LocationDropdownState();
}

class LocationDropdownState extends State<LocationDropdown> {
  String? selectedLocation;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedLocation,
      items: widget.locations
          .map((location) => DropdownMenuItem(
                value: location,
                child: Text(
                  location,
                  style: TextStyle(color: Color(0xFFEF6C00)),
                ),
              ))
          .toList(),
      decoration: InputDecoration(
        labelText: 'Select Location',
        labelStyle: TextStyle(color: Colors.orange[800]),
        hintText: 'Choose your location',
        prefixIcon: Icon(Icons.location_on, color: Colors.orange),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
      onChanged: (newValue) {
        setState(() {
          selectedLocation = newValue;
        });
        widget.onLocationChanged(newValue!);
      },
    );
  }
}
