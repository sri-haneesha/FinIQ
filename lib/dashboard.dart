import 'package:flutter/material.dart';
import 'expense_tracker.dart';
import 'investment_tracker.dart';
import 'income.dart';
import 'saving_goal.dart';
import 'helpers/database_helper.dart';
import 'Reports.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double currentGoal = 0.0;
  double currentIncome = 0.0;
  double totalExpense = 0.0;
  double totalInvestment = 0.0;

  @override
  void initState() {
    super.initState();
    _loadGoal();
    _loadIncome();
    _loadExpenses();
  }

  Future<void> _loadGoal() async {
    try {
      double goal = await DatabaseHelper.instance.getGoal() as double;
      setState(() {
        currentGoal = goal;
      });
    } catch (error) {
      print('Error loading goal: $error');
    }
  }

  Future<void> _loadIncome() async {
    try {
      double income = await DatabaseHelper.instance.getIncome() as double;
      setState(() {
        currentIncome = income;
      });
    } catch (error) {
      print('Error loading income: $error');
    }
  }

  Future<void> _loadExpenses() async {
    try {
      double expenseAmount =
          await DatabaseHelper.instance.calculateTotalExpenseAmount() as double;
      setState(() {
        totalExpense = expenseAmount;
      });
    } catch (error) {
      print('Error loading total expenses: $error');
    }
  }

  Future<void> _loadInvestments() async {
    try {
      double investmentAmount = await DatabaseHelper.instance
          .calculateTotalInvestmentAmount() as double;
      setState(() {
        totalInvestment = investmentAmount;
      });
    } catch (error) {
      print('Error loading total investments: $error');
    }
  }

  void _navigateToExpenseTracker(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExpenseTracker()),
    );
    await _loadExpenses();
    print('Total expenses are $totalExpense');
  }

  void _navigateToInvestmentTracker(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InvestmentTracker()),
    );
    await _loadInvestments();
    print('Total investments are $totalInvestment');
  }

  void _navigateToIncomeTracker(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Income()),
    );
    await _loadIncome();
    print('Current income is $currentIncome');
  }

  void _navigateToSavingGoal(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SavingGoal()),
    );
    await _loadGoal();
    print('Current goal is $currentGoal');
  }

  void _getReport() async {
    await _loadGoal();
    await _loadIncome();
    await _loadInvestments();
    await _loadExpenses();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Reports(currentIncome, totalExpense, totalInvestment, currentGoal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FinIQ'),
        backgroundColor: Color(0xFF075E54), // WhatsApp green color
      ),
      backgroundColor: Colors.white, // WhatsApp style white background
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Expense Tracker Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color(0xFF25D366), // WhatsApp green color for button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () => _navigateToExpenseTracker(context),
                child: Text(
                  'Expense management',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
              SizedBox(height: 20.0),

              // Investment Tracker Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF25D366), // WhatsApp green
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () => _navigateToInvestmentTracker(context),
                child: Text(
                  'Investment management',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
              SizedBox(height: 20.0),

              // Income Entry Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF25D366),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () => _navigateToIncomeTracker(context),
                child: Text(
                  'Income source',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
              SizedBox(height: 20.0),

              // Budget Goal Setting Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF25D366),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () => _navigateToSavingGoal(context),
                child: Text(
                  'Budget Goal Setting',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
              SizedBox(height: 20.0),

              // Reports Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF25D366),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () => _getReport(),
                child: Text(
                  'Reports',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
