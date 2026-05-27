import 'dart:math';

import '../models/quote.dart';

class QuoteRepository {
  final _quotes = <Quote>[
    Quote(
      id: '1',
      text: 'The happiness of your life depends upon the quality of your thoughts.',
      author: 'Marcus Aurelius',
      tags: ['STOICISM', 'MINDSET'],
    ),
    Quote(
      id: '2',
      text: 'You have power over your mind — not outside events. Realize this, and you will find strength.',
      author: 'Marcus Aurelius',
      tags: ['STOICISM', 'INNER STRENGTH'],
    ),
    Quote(
      id: '3',
      text: 'Waste no more time arguing about what a good man should be. Be one.',
      author: 'Marcus Aurelius',
      tags: ['STOICISM', 'ACTION'],
    ),
    Quote(
      id: '4',
      text: 'We suffer more often in imagination than in reality.',
      author: 'Seneca',
      tags: ['STOICISM', 'WISDOM'],
    ),
    Quote(
      id: '5',
      text: 'Sometimes even to live is an act of courage.',
      author: 'Seneca',
      tags: ['STOICISM', 'COURAGE'],
    ),
    Quote(
      id: '6',
      text: 'Luck is what happens when preparation meets opportunity.',
      author: 'Seneca',
      tags: ['STOICISM', 'OPPORTUNITY'],
    ),
    Quote(
      id: '7',
      text: 'The wound is the place where the Light enters you.',
      author: 'Rumi',
      tags: ['SUFISM', 'HEALING'],
    ),
    Quote(
      id: '8',
      text: 'Let yourself be silently drawn by the strange pull of what you really love. It will not lead you astray.',
      author: 'Rumi',
      tags: ['SUFISM', 'LOVE'],
    ),
    Quote(
      id: '9',
      text: 'You are not a drop in the ocean. You are the entire ocean in a drop.',
      author: 'Rumi',
      tags: ['SUFISM', 'AWAKENING'],
    ),
    Quote(
      id: '10',
      text: 'The only way to make sense out of change is to plunge into it, move with it, and join the dance.',
      author: 'Alan Watts',
      tags: ['ZEN', 'MINDFULNESS'],
    ),
    Quote(
      id: '11',
      text: 'You are the universe experiencing itself.',
      author: 'Alan Watts',
      tags: ['ZEN', 'AWAKENING'],
    ),
    Quote(
      id: '12',
      text: 'The meaning of life is just to be alive. It is so plain and so obvious and so simple.',
      author: 'Alan Watts',
      tags: ['ZEN', 'MINDFULNESS'],
    ),
    Quote(
      id: '13',
      text: 'The journey of a thousand miles begins with a single step.',
      author: 'Lao Tzu',
      tags: ['TAOISM', 'WISDOM'],
    ),
    Quote(
      id: '14',
      text: 'When I let go of what I am, I become what I might be.',
      author: 'Lao Tzu',
      tags: ['TAOISM', 'TRANSFORMATION'],
    ),
    Quote(
      id: '15',
      text: 'Nature does not hurry, yet everything is accomplished.',
      author: 'Lao Tzu',
      tags: ['TAOISM', 'PATIENCE'],
    ),
    Quote(
      id: '16',
      text: 'First say to yourself what you would be; then do what you have to do.',
      author: 'Epictetus',
      tags: ['STOICISM', 'ACTION'],
    ),
    Quote(
      id: '17',
      text: 'It\'s not what happens to you, but how you react to it that matters.',
      author: 'Epictetus',
      tags: ['STOICISM', 'RESILIENCE'],
    ),
    Quote(
      id: '18',
      text: 'He who is not contented with what he has, would not be contented with what he would like to have.',
      author: 'Socrates',
      tags: ['PHILOSOPHY', 'CONTENTMENT'],
    ),
    Quote(
      id: '19',
      text: 'The unexamined life is not worth living.',
      author: 'Socrates',
      tags: ['PHILOSOPHY', 'WISDOM'],
    ),
    Quote(
      id: '20',
      text: 'We are what we repeatedly do. Excellence, then, is not an act, but a habit.',
      author: 'Aristotle',
      tags: ['PHILOSOPHY', 'EXCELLENCE'],
    ),
    Quote(
      id: '21',
      text: 'Peace comes from within. Do not seek it without.',
      author: 'Buddha',
      tags: ['MINDFULNESS', 'INNER PEACE'],
    ),
    Quote(
      id: '22',
      text: 'The mind is everything. What you think you become.',
      author: 'Buddha',
      tags: ['MINDFULNESS', 'MINDSET'],
    ),
    Quote(
      id: '23',
      text: 'In the midst of movement and chaos, keep stillness inside of you.',
      author: 'Deepak Chopra',
      tags: ['MINDFULNESS', 'STILLNESS'],
    ),
    Quote(
      id: '24',
      text: 'Your task is not to seek for love, but merely to seek and find all the barriers within yourself that you have built against it.',
      author: 'Rumi',
      tags: ['SUFISM', 'LOVE'],
    ),
    Quote(
      id: '25',
      text: 'The quieter you become, the more you can hear.',
      author: 'Rumi',
      tags: ['SUFISM', 'STILLNESS'],
    ),
    Quote(
      id: '26',
      text: 'What you seek is seeking you.',
      author: 'Rumi',
      tags: ['SUFISM', 'AWAKENING'],
    ),
    Quote(
      id: '27',
      text: 'No man is free who is not master of himself.',
      author: 'Epictetus',
      tags: ['STOICISM', 'FREEDOM'],
    ),
    Quote(
      id: '28',
      text: 'Man conquers the world by conquering himself.',
      author: 'Zeno of Citium',
      tags: ['STOICISM', 'MASTERY'],
    ),
    Quote(
      id: '29',
      text: 'Difficulties strengthen the mind, as labor does the body.',
      author: 'Seneca',
      tags: ['STOICISM', 'RESILIENCE'],
    ),
    Quote(
      id: '30',
      text: 'He who fears death will never do anything worth of a man who is alive.',
      author: 'Seneca',
      tags: ['STOICISM', 'COURAGE'],
    ),
  ];

  final _random = Random();

  Quote getRandomQuote({String? excludeId}) {
    final candidates = excludeId != null
        ? _quotes.where((q) => q.id != excludeId).toList()
        : _quotes;
    return candidates[_random.nextInt(candidates.length)];
  }
}
