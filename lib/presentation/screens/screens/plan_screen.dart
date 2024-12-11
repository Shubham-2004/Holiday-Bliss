import 'package:flutter/material.dart';
import 'package:holiday_bliss/presentation/screens/eventplanner/event_plan_ai_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({Key? key}) : super(key: key);

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cityController = TextEditingController();
  final _budgetController = TextEditingController();
  final _tripPurposeController = TextEditingController();
  final _prioritiesController = TextEditingController();
  final _guestsController = TextEditingController();

  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _tripPlans = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTripPlans();
  }

  @override
  void dispose() {
    _cityController.dispose();
    _budgetController.dispose();
    _tripPurposeController.dispose();
    _prioritiesController.dispose();
    _guestsController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _cityController.clear();
    _budgetController.clear();
    _tripPurposeController.clear();
    _prioritiesController.clear();
    _guestsController.clear();
  }

  Future<void> _fetchTripPlans() async {
    setState(() => _isLoading = true);
    try {
      final response = await supabase
          .from('Trip_plan')
          .select()
          .order('id', ascending: false);

      setState(() {
        _tripPlans = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading trips: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addTripPlan() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final newTrip = {
        'City': _cityController.text,
        'Budget': int.parse(_budgetController.text),
        'Trip Purpose': _tripPurposeController.text,
        'Priorities': _prioritiesController.text,
        'Number of Guests': int.parse(_guestsController.text),
      };

      await supabase.from('Trip_plan').insert(newTrip);

      Navigator.of(context).pop();
      _clearForm();
      _fetchTripPlans();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trip created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating trip: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteTripPlan(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this trip?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await supabase.from('Trip_plan').delete().eq('id', id);
      _fetchTripPlans();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trip deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting trip: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCreateTripDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create a Trip'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a city';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _budgetController,
                    decoration: const InputDecoration(
                      labelText: 'Budget',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a budget';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _tripPurposeController,
                    decoration: const InputDecoration(
                      labelText: 'Trip Purpose',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter trip purpose';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _prioritiesController,
                    decoration: const InputDecoration(
                      labelText: 'Priorities',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter priorities';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _guestsController,
                    decoration: const InputDecoration(
                      labelText: 'Number of Guests',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter number of guests';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearForm();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _addTripPlan,
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Trip Planner',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        toolbarHeight: 120,
        backgroundColor: Colors.black87,
        actions: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: ElevatedButton.icon(
                  onPressed: _showCreateTripDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Create Trip'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EventPlanAiScreen()));
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Trip Plan AI'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchTripPlans,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _tripPlans.isEmpty
                ? const Center(child: Text('No trips planned yet'))
                : ListView.builder(
                    itemCount: _tripPlans.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final trip = _tripPlans[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            trip['City'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text('Budget: \$${trip['Budget']}'),
                              Text('Purpose: ${trip['Trip Purpose']}'),
                              Text('Priorities: ${trip['Priorities']}'),
                              Text('Guests: ${trip['Number of Guests']}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTripPlan(trip['id']),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
