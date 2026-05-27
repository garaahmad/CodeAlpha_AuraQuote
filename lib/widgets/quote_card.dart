import 'package:flutter/material.dart';

import '../bloc/quote_state.dart';
import '../constants/constants.dart';
import 'glass_panel.dart';

class QuoteCard extends StatelessWidget {
  final QuoteDisplayState state;

  const QuoteCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final quote = state.quote;

    return GlassPanel(
      child: AnimatedOpacity(
        opacity: state.isAnimating ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '"',
              style: AuraQuoteTypography.displayQuote.copyWith(
                fontSize: 64,
                height: 0.8,
                color: AuraQuoteColors.primaryContainer,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              quote.text,
              style: AuraQuoteTypography.displayQuote.copyWith(
                color: AuraQuoteColors.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
              quote.author,
                style: AuraQuoteTypography.bodyMain.copyWith(
                  color: AuraQuoteColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: quote.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AuraQuoteColors.secondaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AuraQuoteColors.secondaryContainer.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    tag,
                    style: AuraQuoteTypography.labelCaps.copyWith(
                      color: AuraQuoteColors.onSecondaryContainer,
                      fontSize: 10,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
