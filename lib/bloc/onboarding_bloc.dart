import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingEvent {}

class NextPage extends OnboardingEvent {}

class PreviousPage extends OnboardingEvent {}

class CompleteOnboarding extends OnboardingEvent {}

class OnboardingState {
  final int currentPage;
  final int totalPages;
  final bool isCompleted;

  bool get isLastPage => currentPage == totalPages - 1;

  OnboardingState({
    required this.currentPage,
    this.totalPages = 3,
    this.isCompleted = false,
  });
}

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingState(currentPage: 0)) {
    on<NextPage>(_onNextPage);
    on<PreviousPage>(_onPreviousPage);
    on<CompleteOnboarding>(_onComplete);
  }

  void _onNextPage(NextPage event, Emitter<OnboardingState> emit) {
    if (!state.isLastPage) {
      emit(OnboardingState(currentPage: state.currentPage + 1));
    }
  }

  void _onPreviousPage(PreviousPage event, Emitter<OnboardingState> emit) {
    if (state.currentPage > 0) {
      emit(OnboardingState(currentPage: state.currentPage - 1));
    }
  }

  Future<void> _onComplete(
    CompleteOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTimeUser', false);
    emit(OnboardingState(
      currentPage: state.currentPage,
      isCompleted: true,
    ));
  }
}
