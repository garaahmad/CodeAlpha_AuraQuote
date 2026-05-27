import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'glass_panel.dart';

class QuickCollections extends StatelessWidget {
  const QuickCollections({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COLLECTIONS',
          style: AuraQuoteTypography.labelCaps.copyWith(
            color: AuraQuoteColors.outline,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _CollectionCard(
                title: 'Stoicism\nSeries',
                icon: Icons.shield_outlined,
                color: AuraQuoteColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _CollectionCard(
                title: 'Mindfulness\nSeries',
                icon: Icons.self_improvement,
                color: AuraQuoteColors.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _CollectionCard({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AuraQuoteTypography.uiControl.copyWith(
              color: AuraQuoteColors.onSurface,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '12 quotes',
            style: AuraQuoteTypography.labelCaps.copyWith(
              color: AuraQuoteColors.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
