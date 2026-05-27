import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../constants/constants.dart';
import '../widgets/glass_panel.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignUp() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(SignUpRequested(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraQuoteColors.background,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.of(context).pop();
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: Stack(
          children: [
            _buildAuraBackground(),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GlassPanel(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          final isLoading = state is AuthLoading;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                size: 40,
                                color: AuraQuoteColors.primary,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Create Account',
                                style: AuraQuoteTypography.headlineLg.copyWith(
                                  color: AuraQuoteColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Begin your journey inward',
                                style: AuraQuoteTypography.bodyMain.copyWith(
                                  color: AuraQuoteColors.onSurfaceVariant,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 32),
                              _buildNameField(),
                              const SizedBox(height: 16),
                              _buildEmailField(),
                              const SizedBox(height: 16),
                              _buildPasswordField(),
                              const SizedBox(height: 28),
                              _buildSignUpButton(isLoading),
                              const SizedBox(height: 20),
                              _buildLoginLink(),
                              if (isLoading)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AuraQuoteColors.primary,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuraBackground() {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: -120,
            left: -60,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AuraQuoteColors.primaryContainer.withValues(alpha: 0.25),
                  AuraQuoteColors.primaryContainer.withValues(alpha: 0.0),
                ]),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -40,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AuraQuoteColors.secondaryContainer.withValues(alpha: 0.2),
                  AuraQuoteColors.secondaryContainer.withValues(alpha: 0.0),
                ]),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Container(color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      style: AuraQuoteTypography.uiControl.copyWith(
        color: AuraQuoteColors.onSurface,
      ),
      decoration: InputDecoration(
        labelText: 'Full Name',
        prefixIcon: Icon(Icons.person, color: AuraQuoteColors.onSurfaceVariant),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.03),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AuraQuoteColors.outline.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AuraQuoteColors.outline.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AuraQuoteColors.primary, width: 1.5),
        ),
        labelStyle: AuraQuoteTypography.uiControl.copyWith(
          color: AuraQuoteColors.onSurfaceVariant,
        ),
      ),
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your name';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      style: AuraQuoteTypography.uiControl.copyWith(
        color: AuraQuoteColors.onSurface,
      ),
      decoration: InputDecoration(
        labelText: 'Email Address',
        prefixIcon: Icon(Icons.mail, color: AuraQuoteColors.onSurfaceVariant),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.03),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AuraQuoteColors.outline.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AuraQuoteColors.outline.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AuraQuoteColors.primary, width: 1.5),
        ),
        labelStyle: AuraQuoteTypography.uiControl.copyWith(
          color: AuraQuoteColors.onSurfaceVariant,
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: AuraQuoteTypography.uiControl.copyWith(
        color: AuraQuoteColors.onSurface,
      ),
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: Icon(Icons.lock, color: AuraQuoteColors.onSurfaceVariant),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: AuraQuoteColors.onSurfaceVariant,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.03),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AuraQuoteColors.outline.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AuraQuoteColors.outline.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AuraQuoteColors.primary, width: 1.5),
        ),
        labelStyle: AuraQuoteTypography.uiControl.copyWith(
          color: AuraQuoteColors.onSurfaceVariant,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildSignUpButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: isLoading ? null : _onSignUp,
        child: AnimatedScale(
          scale: isLoading ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AuraQuoteColors.primaryContainer,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AuraQuoteColors.primaryContainer.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AuraQuoteColors.onPrimaryContainer,
                    ),
                  )
                else ...[
                  Icon(Icons.auto_awesome,
                      size: 20, color: AuraQuoteColors.onPrimaryContainer),
                  const SizedBox(width: 10),
                ],
                Text(
                  isLoading ? 'Creating Account...' : 'Create Account',
                  style: AuraQuoteTypography.uiControl.copyWith(
                    color: AuraQuoteColors.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: AuraQuoteTypography.uiControl.copyWith(
            color: AuraQuoteColors.onSurfaceVariant,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text(
            'Sign In',
            style: AuraQuoteTypography.uiControl.copyWith(
              color: AuraQuoteColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
