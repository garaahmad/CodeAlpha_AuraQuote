import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../data/quote_repository.dart';
import '../models/quote.dart';
import '../services/gemini_service.dart';
import 'quote_event.dart';
import 'quote_state.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final QuoteRepository _repository;
  String? _lastQuoteId;

  QuoteBloc({required QuoteRepository repository})
    : _repository = repository,
      super(QuoteInitial()) {
    on<LoadInitialQuote>(_onLoadInitialQuote);
    on<GenerateNewQuote>(_onGenerateNewQuote);
    on<GenerateAIQuote>(_onGenerateAIQuote);
  }

  void _onLoadInitialQuote(LoadInitialQuote event, Emitter<QuoteState> emit) {
    final quote = _repository.getRandomQuote();
    _lastQuoteId = quote.id;
    emit(QuoteDisplayState(quote: quote, isAnimating: false));
  }

  Future<void> _onGenerateNewQuote(
    GenerateNewQuote event,
    Emitter<QuoteState> emit,
  ) async {
    if (state is QuoteDisplayState) {
      emit(
        QuoteDisplayState(
          quote: (state as QuoteDisplayState).quote,
          isAnimating: true,
        ),
      );
      await Future.delayed(const Duration(milliseconds: 250));
    }
    final quote = _repository.getRandomQuote(excludeId: _lastQuoteId);
    _lastQuoteId = quote.id;
    emit(QuoteDisplayState(quote: quote, isAnimating: false));
  }

  Future<void> _onGenerateAIQuote(
    GenerateAIQuote event,
    Emitter<QuoteState> emit,
  ) async {
    if (state is QuoteDisplayState) {
      emit(
        QuoteDisplayState(
          quote: (state as QuoteDisplayState).quote,
          isAnimating: true,
        ),
      );
      await Future.delayed(const Duration(milliseconds: 200));
    }

    emit(QuoteLoading());

    final model = GeminiService.model;
    if (model == null) {
      final quote = _repository.getRandomQuote(excludeId: _lastQuoteId);
      _lastQuoteId = quote.id;
      emit(QuoteDisplayState(quote: quote, isAnimating: false));
      return;
    }

    try {
      final prompt =
          'Generate a single, deeply profound, inspiring quote '
          'about life, wisdom, and consciousness. '
          'Return the output strictly as a JSON object with two fields: '
          '"quote" and "author". Keep it short and elegant. '
          'Do not include any other text or markdown formatting.';

      final response = await model.generateContent([Content.text(prompt)]);
      final text = response.text;

      Quote quote;
      if (text != null) {
        final cleaned = text.replaceAll(RegExp(r'```json|```'), '').trim();
        final json = jsonDecode(cleaned) as Map<String, dynamic>;
        final quoteText = json['quote'] as String;
        final author = json['author'] as String;
        quote = Quote(
          id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
          text: quoteText,
          author: author,
          tags: ['AI GENERATED'],
        );
      } else {
        quote = _repository.getRandomQuote(excludeId: _lastQuoteId);
      }

      _lastQuoteId = quote.id;
      emit(QuoteDisplayState(quote: quote, isAnimating: false));
    } catch (e) {
      final quote = _repository.getRandomQuote(excludeId: _lastQuoteId);
      _lastQuoteId = quote.id;
      emit(QuoteDisplayState(quote: quote, isAnimating: false));
    }
  }
}
