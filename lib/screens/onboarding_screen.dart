import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/onboarding_bloc.dart';
import '../constants/constants.dart';
import '../widgets/glass_panel.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  late OnboardingBloc _bloc;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _bloc = context.read<OnboardingBloc>();
    _bloc.stream.listen((state) {
      if (state.isCompleted && mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    final state = _bloc.state;
    if (state.isLastPage) {
      _bloc.add(CompleteOnboarding());
    } else {
      _bloc.add(NextPage());
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraQuoteColors.background,
      body: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          return Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  if (page != _bloc.state.currentPage) {
                    _bloc.add(page > _bloc.state.currentPage
                        ? NextPage()
                        : PreviousPage());
                  }
                },
                children: [
                  _EnlightenmentPage(onNext: _goNext),
                  _MuseNodePage(onNext: _goNext),
                  _SanctuaryPage(onNext: _goNext),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: MediaQuery.of(context).padding.bottom + 32,
                child: _PageIndicator(
                  currentPage: state.currentPage,
                  totalPages: state.totalPages,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EnlightenmentPage extends StatefulWidget {
  final VoidCallback onNext;
  const _EnlightenmentPage({required this.onNext});

  @override
  State<_EnlightenmentPage> createState() => _EnlightenmentPageState();
}

class _EnlightenmentPageState extends State<_EnlightenmentPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _ringController;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildGlow(),
        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text(
                'AuraQuote',
                style: AuraQuoteTypography.labelCaps.copyWith(
                  color: AuraQuoteColors.outline,
                  fontSize: 13,
                ),
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 240,
                    height: 240,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        RotationTransition(
                          turns: _ringController,
                          child: Container(
                            width: 240,
                            height: 240,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.06),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                        RotationTransition(
                          turns: Tween(begin: 1.0, end: 0.0)
                              .animate(_ringController),
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: 25, sigmaY: 25),
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.03),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                              child: Icon(
                                Icons.auto_awesome,
                                size: 48,
                                color: AuraQuoteColors.primary
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GlassPanel(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'Discover ',
                          style:
                              AuraQuoteTypography.displayQuote.copyWith(
                            fontSize: 26,
                            color: AuraQuoteColors.onSurface,
                          ),
                          children: [
                            TextSpan(
                              text: 'AI Wisdom',
                              style:
                                  AuraQuoteTypography.displayQuote.copyWith(
                                fontSize: 26,
                                color: AuraQuoteColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Where ancient reflections from Stoics, '
                        'Sufis, and sages meet artificial intelligence '
                        'to illuminate your path.',
                        style: AuraQuoteTypography.bodyMain.copyWith(
                          color: AuraQuoteColors.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(child: _OnboardingButton(
                        label: 'Next',
                        onTap: widget.onNext,
                      )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGlow() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.08,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [
              AuraQuoteColors.primaryContainer.withValues(alpha: 0.15),
              AuraQuoteColors.primaryContainer.withValues(alpha: 0.0),
            ]),
          ),
        ),
      ),
    );
  }
}

class _MuseNodePage extends StatelessWidget {
  final VoidCallback onNext;
  const _MuseNodePage({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _AuraDecor(
          top: 0.12,
          left: 0.5,
          size: 260,
          color: AuraQuoteColors.primaryContainer,
        ),
        _AuraDecor(
          top: 0.5,
          left: 0.8,
          size: 200,
          color: AuraQuoteColors.secondaryContainer,
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _SynapsePainter(),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 1),
              GlassPanel(
                width: 140,
                height: 140,
                padding: EdgeInsets.zero,
                borderRadius: 70,
                child: Icon(
                  Icons.auto_awesome,
                  size: 52,
                  color: AuraQuoteColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              _ChipRow(),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GlassPanel(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'Spark Your ',
                          style:
                              AuraQuoteTypography.displayQuote.copyWith(
                            fontSize: 26,
                            color: AuraQuoteColors.onSurface,
                          ),
                          children: [
                            TextSpan(
                              text: 'Muse',
                              style:
                                  AuraQuoteTypography.displayQuote.copyWith(
                                fontSize: 26,
                                color: AuraQuoteColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'AuraSpark translates your inner frequency '
                        'into constellations of wisdom. Each quote '
                        'resonates with your unique energy.',
                        style: AuraQuoteTypography.bodyMain.copyWith(
                          color: AuraQuoteColors.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(child: _OnboardingButton(
                        label: 'Next',
                        onTap: onNext,
                      )),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ],
    );
  }
}

class _SynapsePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    final nodes = [
      Offset(size.width * 0.2, size.height * 0.15),
      Offset(size.width * 0.75, size.height * 0.1),
      Offset(size.width * 0.85, size.height * 0.35),
      Offset(size.width * 0.3, size.height * 0.45),
      Offset(size.width * 0.6, size.height * 0.55),
      Offset(size.width * 0.15, size.height * 0.7),
      Offset(size.width * 0.7, size.height * 0.8),
      Offset(size.width * 0.9, size.height * 0.65),
    ];

    for (var i = 0; i < nodes.length; i++) {
      for (var j = i + 1; j < nodes.length; j++) {
        final dx = nodes[j].dx - nodes[i].dx;
        final dy = nodes[j].dy - nodes[i].dy;
        final dist = (dx * dx + dy * dy);
        if (dist < size.width * size.width * 0.25) {
          canvas.drawLine(nodes[i], nodes[j], paint);
        }
      }
    }

    final dotPaint = Paint()..style = PaintingStyle.fill;
    for (final node in nodes) {
      dotPaint.color = AuraQuoteColors.primary.withValues(alpha: 0.3);
      canvas.drawCircle(node, 3, dotPaint);
      dotPaint.color = Colors.white.withValues(alpha: 0.1);
      canvas.drawCircle(node, 5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SanctuaryPage extends StatelessWidget {
  final VoidCallback onNext;
  const _SanctuaryPage({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _AuraDecor(
          top: 0.05,
          left: 0.5,
          size: 300,
          color: AuraQuoteColors.primaryContainer,
        ),
        _AuraDecor(
          top: 0.6,
          left: 0.15,
          size: 220,
          color: AuraQuoteColors.secondaryContainer,
        ),
        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, right: 24),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Step 3 of 3',
                    style: AuraQuoteTypography.labelCaps.copyWith(
                      color: AuraQuoteColors.outline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildBentoGrid(),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GlassPanel(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'Build Your ',
                          style:
                              AuraQuoteTypography.displayQuote.copyWith(
                            fontSize: 26,
                            color: AuraQuoteColors.onSurface,
                          ),
                          children: [
                            TextSpan(
                              text: 'Soul Library',
                              style:
                                  AuraQuoteTypography.displayQuote.copyWith(
                                fontSize: 26,
                                color: AuraQuoteColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Catalog your generated insights by mood and '
                        'theme. Build a personal archive of wisdom '
                        'that grows with you.',
                        style: AuraQuoteTypography.bodyMain.copyWith(
                          color: AuraQuoteColors.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(child: _OnboardingButton(
                        label: 'Get Started',
                        onTap: onNext,
                      )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBentoGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GlassPanel(
                padding: const EdgeInsets.all(16),
                borderRadius: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.folder_outlined,
                        color: AuraQuoteColors.primary, size: 24),
                    const SizedBox(height: 10),
                    Text('Wisdom',
                        style: AuraQuoteTypography.uiControl.copyWith(
                          color: AuraQuoteColors.onSurface,
                        )),
                    const SizedBox(height: 4),
                    Text('8 quotes',
                        style: AuraQuoteTypography.labelCaps.copyWith(
                          color: AuraQuoteColors.onSurfaceVariant,
                          fontSize: 10,
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GlassPanel(
                padding: const EdgeInsets.all(16),
                borderRadius: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('24 SAVED',
                        style: AuraQuoteTypography.labelCaps.copyWith(
                          color: AuraQuoteColors.secondary,
                        )),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox(
                        height: 6,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 7,
                              child: Container(
                                color: AuraQuoteColors.primaryContainer,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                color: AuraQuoteColors.outline
                                    .withValues(alpha: 0.2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Daily Collection',
                        style: AuraQuoteTypography.labelCaps.copyWith(
                          color: AuraQuoteColors.onSurfaceVariant,
                          fontSize: 10,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GlassPanel(
          padding: const EdgeInsets.all(16),
          borderRadius: 16,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AuraQuoteColors.secondaryContainer
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.auto_awesome,
                    color: AuraQuoteColors.secondary, size: 18),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Stoicism Series',
                      style: AuraQuoteTypography.uiControl.copyWith(
                        color: AuraQuoteColors.onSurface,
                      )),
                  Text('12 quotes · Marcus, Seneca, Epictetus',
                      style: AuraQuoteTypography.labelCaps.copyWith(
                        color: AuraQuoteColors.onSurfaceVariant,
                        fontSize: 10,
                      )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OnboardingButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _OnboardingButton({required this.label, required this.onTap});

  @override
  State<_OnboardingButton> createState() => _OnboardingButtonState();
}

class _OnboardingButtonState extends State<_OnboardingButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          decoration: BoxDecoration(
            color: AuraQuoteColors.primaryContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: AuraQuoteTypography.uiControl.copyWith(
                  color: AuraQuoteColors.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward,
                  size: 18, color: AuraQuoteColors.onPrimaryContainer),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  const _PageIndicator({
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (i) {
        final isActive = i == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? AuraQuoteColors.primary
                : Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class _AuraDecor extends StatelessWidget {
  final double top;
  final double left;
  final double size;
  final Color color;
  const _AuraDecor({
    required this.top,
    required this.left,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * top - size / 2,
      left: MediaQuery.of(context).size.width * left - size / 2,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.0),
          ]),
        ),
      ),
    );
  }
}

class _ChipRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chips = ['NEURAL SYNTHESIS', 'COGNITIVE LIGHT'];
    return Wrap(
      spacing: 8,
      alignment: WrapAlignment.center,
      children: chips.map((chip) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 0.5,
            ),
          ),
          child: Text(
            chip,
            style: AuraQuoteTypography.labelCaps.copyWith(
              color: AuraQuoteColors.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        );
      }).toList(),
    );
  }
}
