import 'package:flutter/material.dart';
import '../models/activity_model.dart';
import '../services/activity_service.dart';
import 'package:intl/intl.dart';

class EditActivityScreen extends StatefulWidget {
  final Activity activity;

  const EditActivityScreen({super.key, required this.activity});

  @override
  State<EditActivityScreen> createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends State<EditActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final ActivityService _activityService = ActivityService();

  late TextEditingController _titleController;
  late TextEditingController _descController;
  
  late String _selectedDuration;
  late String _selectedEnergy;
  late String _selectedLocation;
  late DateTime _selectedDate;

  bool _isLoading = false;

  final List<String> _durations = ["5 min", "15 min", "30 min", "60 min"];
  final List<String> _energyLevels = ["Low", "Medium", "High"];
  final List<String> _locations = ["Home", "Outside"];

  @override
  void initState() {
    super.initState();
    // Pre-fill values
    _titleController = TextEditingController(text: widget.activity.title);
    _descController = TextEditingController(text: widget.activity.description);
    
    // Ensure the initial value is in the list, otherwise default to first item
    _selectedDuration = _durations.contains(widget.activity.duration) ? widget.activity.duration : _durations.first;
    _selectedEnergy = _energyLevels.contains(widget.activity.energyLevel) ? widget.activity.energyLevel : _energyLevels.first;
    _selectedLocation = _locations.contains(widget.activity.location) ? widget.activity.location : _locations.first;
    _selectedDate = widget.activity.date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _updateActivity() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final updatedActivity = Activity(
        id: widget.activity.id, // Keep the same ID
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        duration: _selectedDuration,
        energyLevel: _selectedEnergy,
        location: _selectedLocation,
        date: _selectedDate,
      );

      try {
        await _activityService.updateActivity(updatedActivity);
        if(!mounted) return;
        Navigator.pop(context); // Go back to list
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Activity updated successfully!")),
        );
      } catch (e) {
        if(!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating activity: $e")),
        );
      } finally {
        if(mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5CFC7),
      appBar: AppBar(
        title: const Text("Edit Activity"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Activity Title",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) => value == null || value.isEmpty ? "Please enter a title" : null,
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(
                  labelText: "Description",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty ? "Please enter a description" : null,
              ),
              const SizedBox(height: 16),

              // Duration Dropdown
              _buildDropdown("Duration", _durations, _selectedDuration, (val) {
                setState(() => _selectedDuration = val!);
              }),
              const SizedBox(height: 16),

              // Energy Dropdown
              _buildDropdown("Energy Level", _energyLevels, _selectedEnergy, (val) {
                setState(() => _selectedEnergy = val!);
              }),
              const SizedBox(height: 16),

              // Location Dropdown
              // Location Dropdown
              _buildDropdown("Location", _locations, _selectedLocation, (val) {
                setState(() => _selectedLocation = val!);
              }),
              
              // Date Picker UI
              const SizedBox(height: 16),
              const Text("Date", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                   Icon(Icons.calendar_today, size: 20, color: Colors.grey[700]), 
                   const SizedBox(width: 10),
                   Text(
                    DateFormat('dd/MM/yyyy').format(_selectedDate), 
                    style: const TextStyle(fontSize: 16),
                   ),
                   const Spacer(),
                   TextButton(
                     onPressed: _pickDate,
                     child: const Text("Change Date"),
                   ),
                ],
              ),
              const SizedBox(height: 24),

              // Update Button
              ElevatedButton(
                onPressed: _isLoading ? null : _updateActivity,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Update Activity", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String currentValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentValue,
              isExpanded: true,
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
