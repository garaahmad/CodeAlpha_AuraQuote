import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'action_button.dart';
import 'glass_panel.dart';

class HeroCard extends StatefulWidget {
  final VoidCallback onGenerate;

  const HeroCard({super.key, required this.onGenerate});

  @override
  State<HeroCard> createState() => _HeroCardState();
}

class _HeroCardState extends State<HeroCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(32),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AuraQuoteColors.primaryContainer.withValues(alpha: 0.2),
                          AuraQuoteColors.primaryContainer.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Column(
            children: [
              Text(
                'Channel Your\nInner Light',
                textAlign: TextAlign.center,
                style: AuraQuoteTypography.headlineLg.copyWith(
                  color: AuraQuoteColors.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Set your intention and let the wisdom\nof the ages guide your spirit.',
                textAlign: TextAlign.center,
                style: AuraQuoteTypography.bodyMain.copyWith(
                  color: AuraQuoteColors.onSurfaceVariant,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 28),
              ActionButton(
                label: 'Generate My Aura',
                icon: Icons.auto_awesome,
                onPressed: widget.onGenerate,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
