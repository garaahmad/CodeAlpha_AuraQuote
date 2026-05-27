import '../models/quote.dart';

abstract class QuoteState {}

class QuoteInitial extends QuoteState {}

class QuoteLoading extends QuoteState {}

class QuoteDisplayState extends QuoteState {
  final Quote quote;
  final bool isAnimating;

  QuoteDisplayState({
    required this.quote,
    this.isAnimating = false,
  });
}

class QuoteError extends QuoteState {
  final String message;

  QuoteError({required this.message});
}
