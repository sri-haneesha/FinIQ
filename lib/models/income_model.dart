class IncomeModel {
  double _income = 0.0;

  void initialize(double initialIncome) {
    _income = initialIncome;
  }

  double get income => _income;

  void updateIncome(double newIncome) {
    _income = newIncome;
  }
/*
  // Singleton pattern: Private constructor and instance
  static final IncomeModel _instance = IncomeModel._internal();

  factory IncomeModel() {
    return _instance;
  }

  IncomeModel._internal();

  // Initialize income if not already initialized
  Future<void> initialize(double initialIncome) async {
    if (!_initialized) {
      _income = initialIncome;
      _initialized = true;
    }
  }

  // Getter for current income
  double get income => _income;

  // Update income
  void updateIncome(double newIncome) {
    _income = newIncome;
  }*/
}