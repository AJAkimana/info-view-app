import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCubit extends Cubit<bool> {
  OnboardingCubit() : super(false);

  void completeOnboarding() => emit(true);
  void resetOnboarding() => emit(false);
}

