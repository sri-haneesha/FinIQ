import 'dart:io';
import 'package:flutter/material.dart';

import './widgets/new_transaction_form.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './widgets/circular_chart.dart';
import './models/transaction.dart';
import './helpers/database_helper.dart';

class ExpenseTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List<Transaction> _userTransactions = [];
  bool _showChart = false;

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Set animation duration
    );

    // Slide animation for adding smooth transition
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1), // Start from above
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Fade animation for adding smooth transition
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Start animation when page loads
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose controller when not needed
    super.dispose();
  }

  List<Transaction> get _recentTransactions {
    DateTime lastDayOfPrevWeek = DateTime.now().subtract(Duration(days: 6));
    lastDayOfPrevWeek = DateTime(
        lastDayOfPrevWeek.year, lastDayOfPrevWeek.month, lastDayOfPrevWeek.day);
    return _userTransactions.where((element) {
      return element.txnDateTime.isAfter(lastDayOfPrevWeek);
    }).toList();
  }

  _MyHomePageState() {
    _updateUserTransactionsList();
  }

  void _updateUserTransactionsList() {
    Future<List<Transaction>> res =
        DatabaseHelper.instance.getAllTransactions();

    res.then((txnList) {
      setState(() {
        _userTransactions = txnList;
      });
    });
  }

  void _showChartHandler(bool show) {
    setState(() {
      _showChart = show;
    });
  }

  Future<void> _addNewTransaction(
      String title, double amount, String category, DateTime chosenDate) async {
    final newTxn = Transaction(
      DateTime.now().millisecondsSinceEpoch.toString(),
      title,
      amount,
      category,
      chosenDate,
    );
    int res = await DatabaseHelper.instance.insert(newTxn);

    if (res != 0) {
      _updateUserTransactionsList();
    }
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return SlideTransition(
          // Adding animation to modal bottom sheet
          position: _slideAnimation,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: NewTransactionForm(_addNewTransaction),
          ),
        );
      },
    );
  }

  Future<void> _deleteTransaction(String id) async {
    int parsedId = int.tryParse(id) ?? 0;
    int res = await DatabaseHelper.instance.deleteTransactionById(parsedId);
    if (res != 0) {
      _updateUserTransactionsList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppBar myAppBar = AppBar(
      title: FadeTransition(
        // Animated fade-in for title
        opacity: _fadeAnimation,
        child: Text(
          'Expense Tracker',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
          ),
        ),
      ),
      backgroundColor: Color(0xFF075E54), // WhatsApp dark green
    );

    MediaQueryData mediaQueryData = MediaQuery.of(context);
    final bool isLandscape =
        mediaQueryData.orientation == Orientation.landscape;

    final double availableHeight = mediaQueryData.size.height -
        myAppBar.preferredSize.height -
        mediaQueryData.padding.top -
        mediaQueryData.padding.bottom;

    final double availableWidth = mediaQueryData.size.width -
        mediaQueryData.padding.left -
        mediaQueryData.padding.right;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: myAppBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Show Chart",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  Switch.adaptive(
                    activeColor: Color(0xFF25D366), // WhatsApp light green
                    value: _showChart,
                    onChanged: (value) => _showChartHandler(value),
                  ),
                ],
              ),
            if (isLandscape)
              _showChart
                  ? myChartContainer(
                      height: availableHeight * 0.8,
                      width: 0.6 * availableWidth)
                  : myTransactionListContainer(
                      height: availableHeight * 0.8,
                      width: 0.6 * availableWidth),
            if (!isLandscape)
              myCircularChartContainer(
                  height: availableHeight * 0.2, width: availableWidth),
            myChartContainer(
                height: availableHeight * 0.3, width: availableWidth),
            if (!isLandscape)
              myTransactionListContainer(
                  height: availableHeight * 0.7, width: availableWidth),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : SlideTransition(
              position: _slideAnimation, // Animate floating action button
              child: FloatingActionButton(
                backgroundColor: Color(0xFF25D366), // WhatsApp light green
                child: Icon(Icons.add),
                tooltip: "Add New Transaction",
                onPressed: () => _startAddNewTransaction(context),
              ),
            ),
    );
  }

  Widget myCircularChartContainer(
      {required double height, required double width}) {
    return FadeTransition(
      // Animate chart appearance
      opacity: _fadeAnimation,
      child: Container(
        height: height,
        width: width,
        child: CategoryChart(_userTransactions),
      ),
    );
  }

  Widget myChartContainer({required double height, required double width}) {
    return FadeTransition(
      // Animate chart container
      opacity: _fadeAnimation,
      child: Container(
        height: height,
        width: width,
        child: Chart(_recentTransactions),
      ),
    );
  }

  Widget myTransactionListContainer(
      {required double height, required double width}) {
    return FadeTransition(
      // Animate transaction list
      opacity: _fadeAnimation,
      child: Container(
        height: height,
        width: width,
        child: TransactionList(_userTransactions, _deleteTransaction),
      ),
    );
  }
}
