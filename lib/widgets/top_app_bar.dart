import 'dart:ui';

import 'package:aura_quote/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../constants/constants.dart';

class AuraTopAppBar extends StatelessWidget {
  const AuraTopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AuraQuoteColors.background.withValues(alpha: 0.6),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.06),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: AuraQuoteColors.primary,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'AURAQUOTE',
                style: AuraQuoteTypography.labelCaps.copyWith(
                  color: AuraQuoteColors.onSurface,
                ),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.account_circle,
                  color: AuraQuoteColors.onSurfaceVariant,
                  size: 24,
                ),
                color: AuraQuoteColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                ),
                onSelected: (value) {
                  if (value == 'signout') {
                    context.read<AuthBloc>().add(SignOutRequested());
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'signout',
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },

                          icon: Icon(Icons.logout),

                          color: AuraQuoteColors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Sign Out',
                          style: AuraQuoteTypography.uiControl.copyWith(
                            color: AuraQuoteColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
