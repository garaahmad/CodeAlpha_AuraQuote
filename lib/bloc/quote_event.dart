abstract class QuoteEvent {}

class LoadInitialQuote extends QuoteEvent {}

class GenerateNewQuote extends QuoteEvent {}

class GenerateAIQuote extends QuoteEvent {}
