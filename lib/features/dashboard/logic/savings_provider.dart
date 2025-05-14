import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendiary/features/dashboard/logic/savings_state.dart';
import 'package:spendiary/features/dashboard/logic/savings_controller.dart';

final savingsControllerProvider =
    StateNotifierProvider<SavingsController, SavingsState>(
      (ref) => SavingsController(),
    );
