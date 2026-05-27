import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/quote_bloc.dart';
import '../bloc/quote_event.dart';
import '../bloc/quote_state.dart';
import '../constants/constants.dart';
import '../widgets/aura_background.dart';
import '../widgets/glass_panel.dart';
import '../widgets/hero_card.dart';
import '../widgets/quote_card.dart';
import '../widgets/top_app_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<QuoteBloc>().add(LoadInitialQuote());
  }

  void _onGenerateAura() {
    context.read<QuoteBloc>().add(GenerateAIQuote());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraQuoteColors.background,
      body: Stack(
        children: [
          const AuraBackground(),
          SafeArea(
            child: Column(
              children: [
                const AuraTopAppBar(),
                Expanded(
                  child: BlocBuilder<QuoteBloc, QuoteState>(
                    builder: (context, state) {
                      if (state is QuoteInitial) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AuraQuoteColors.primary,
                          ),
                        );
                      }

                      if (state is QuoteLoading) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              HeroCard(onGenerate: _onGenerateAura),
                              const SizedBox(height: 24),
                              _buildLoadingCard(),
                              const SizedBox(height: 24),
                              const SizedBox(height: 32),
                            ],
                          ),
                        );
                      }

                      if (state is QuoteDisplayState) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              HeroCard(onGenerate: _onGenerateAura),
                              const SizedBox(height: 24),
                              QuoteCard(state: state),
                              const SizedBox(height: 24),
                              const SizedBox(height: 32),
                            ],
                          ),
                        );
                      }

                      if (state is QuoteError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: AuraQuoteColors.onSurfaceVariant,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                  style: AuraQuoteTypography.bodyMain.copyWith(
                                    color: AuraQuoteColors.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                GestureDetector(
                                  onTap: _onGenerateAura,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AuraQuoteColors.primaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Try Again',
                                      style: AuraQuoteTypography.uiControl
                                          .copyWith(
                                            color: AuraQuoteColors
                                                .onPrimaryContainer,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return GlassPanel(
      child: Column(
        children: [
          Center(
            child: CircularProgressIndicator(
              color: AuraQuoteColors.primary.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Generating your aura...',
            style: AuraQuoteTypography.bodyMain.copyWith(
              color: AuraQuoteColors.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
