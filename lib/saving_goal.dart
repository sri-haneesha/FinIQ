import 'package:flutter/material.dart';
import './helpers/database_helper.dart';

class SavingGoal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GoalHomePage();
  }
}

class GoalHomePage extends StatefulWidget {
  @override
  _GoalHomePageState createState() => _GoalHomePageState();
}

class _GoalHomePageState extends State<GoalHomePage> {
  final GoalModel goalModel = GoalModel(); // Initialize GoalModel
  TextEditingController _goalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadGoalFromDatabase();
  }

  Future<void> _loadGoalFromDatabase() async {
    try {
      double? savedGoal = await DatabaseHelper.instance.getGoal();
      if (savedGoal != null) {
        goalModel.updateGoal(savedGoal);
        setState(() {});
      } else {
        goalModel.initialize(0.0); // Set initial default goal
        setState(() {});
      }
    } catch (e) {
      print('Error loading goal: $e');
    }
  }

  void _saveGoal(BuildContext context) async {
    double newGoal = double.tryParse(_goalController.text) ?? 0.0;
    goalModel.updateGoal(newGoal);

    double? savedGoal = await DatabaseHelper.instance.getGoal();
    try {
      if (savedGoal != null) {
        await DatabaseHelper.instance.updateGoal(newGoal);
      } else {
        await DatabaseHelper.instance.insertGoal(newGoal);
      }

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Goal saved: \$${newGoal.toStringAsFixed(2)}')),
      );
    } catch (error) {
      print('Error saving goal: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Savings Goal'),
        backgroundColor: Color(0xFF075E54), // WhatsApp dark green
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Current Goal: \$${goalModel.goal.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF075E54), // WhatsApp dark green
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _goalController,
              decoration: InputDecoration(
                labelText: 'Enter New Goal',
                labelStyle:
                    TextStyle(color: Color(0xFF075E54)), // WhatsApp dark green
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: Color(0xFF25D366)), // WhatsApp light green
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF075E54), width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF25D366), // WhatsApp light green
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), // Rounded corners for button
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              onPressed: () => _saveGoal(context),
              child: Text(
                'Save Goal',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text on green button
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }
}

class GoalModel {
  double _goal = 0.0;

  void initialize(double initialGoal) {
    _goal = initialGoal;
  }

  double get goal => _goal;

  void updateGoal(double newGoal) {
    _goal = newGoal;
  }
}
