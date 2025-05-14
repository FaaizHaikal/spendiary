import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendiary/features/dashboard/states/expenses_state.dart';
import 'package:spendiary/features/dashboard/applications/expenses_controller.dart';

final expensesControllerProvider =
    StateNotifierProvider<ExpensesController, ExpensesState>(
      (ref) => ExpensesController(),
    );
