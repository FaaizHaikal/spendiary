import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendiary/features/dashboard/states/savings_state.dart';
import 'package:spendiary/features/dashboard/applications/savings_controller.dart';

final savingsControllerProvider =
    StateNotifierProvider<SavingsController, SavingsState>(
      (ref) => SavingsController(),
    );
