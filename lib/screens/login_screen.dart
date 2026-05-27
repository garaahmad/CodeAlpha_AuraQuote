import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../constants/constants.dart';
import '../widgets/glass_panel.dart';
import 'dashboard_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignInRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraQuoteColors.background,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            _isLoading = true;
            _showLoadingDialog();
          } else if (state is AuthSuccess) {
            _isLoading = false;
            _dismissLoadingDialog();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
              (route) => false,
            );
          } else if (state is AuthFailure) {
            _isLoading = false;
            _dismissLoadingDialog();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
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
                              AnimatedBuilder(
                                animation: _floatAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(0, _floatAnimation.value),
                                    child: Icon(
                                      Icons.auto_awesome,
                                      size: 48,
                                      color: AuraQuoteColors.primary,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'AuraQuote',
                                style: AuraQuoteTypography.headlineLg.copyWith(
                                  color: AuraQuoteColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Find your inner light',
                                style: AuraQuoteTypography.bodyMain.copyWith(
                                  color: AuraQuoteColors.onSurfaceVariant,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 32),
                              _buildEmailField(),
                              const SizedBox(height: 16),
                              _buildPasswordField(),
                              const SizedBox(height: 28),
                              _buildLoginButton(isLoading),
                              const SizedBox(height: 24),
                              _buildSocialRow(isLoading),
                              const SizedBox(height: 24),
                              _buildSignUpLink(),
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

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AuraQuoteColors.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E5BFF).withValues(alpha: 0.15),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              color: Color(0xFF2E5BFF),
              strokeWidth: 3,
            ),
          ),
        ),
      ),
    );
  }

  void _dismissLoadingDialog() {
    if (_isLoading) {
      return;
    }
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Widget _buildAuraBackground() {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: -100,
            left: -60,
            child: Container(
              width: 300,
              height: 300,
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
          ),
          Positioned(
            bottom: -80,
            right: -40,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AuraQuoteColors.secondaryContainer.withValues(alpha: 0.15),
                    AuraQuoteColors.secondaryContainer.withValues(alpha: 0.0),
                  ],
                ),
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
          borderSide: BorderSide(
            color: AuraQuoteColors.outline.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AuraQuoteColors.outline.withValues(alpha: 0.3),
          ),
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
          borderSide: BorderSide(
            color: AuraQuoteColors.outline.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AuraQuoteColors.outline.withValues(alpha: 0.3),
          ),
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
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: isLoading ? null : _onLogin,
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
                  color: AuraQuoteColors.primaryContainer.withValues(
                    alpha: 0.4,
                  ),
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
                  Icon(
                    Icons.auto_awesome,
                    size: 20,
                    color: AuraQuoteColors.onPrimaryContainer,
                  ),
                  const SizedBox(width: 10),
                ],
                Text(
                  isLoading ? 'Signing In...' : 'Sign In',
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

  Widget _buildSocialRow(bool isLoading) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider(color: AuraQuoteColors.outline)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR',
                style: AuraQuoteTypography.labelCaps.copyWith(
                  color: AuraQuoteColors.outline,
                ),
              ),
            ),
            const Expanded(child: Divider(color: AuraQuoteColors.outline)),
          ],
        ),
        const SizedBox(height: 20),
        _GlassmorphicSocialButton(
          icon: Icons.g_mobiledata_rounded,
          label: 'Continue with Google',
          isLoading: isLoading,
          onTap: () =>
              context.read<AuthBloc>().add(SignInWithGoogleRequested()),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: AuraQuoteTypography.uiControl.copyWith(
            color: AuraQuoteColors.onSurfaceVariant,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SignUpScreen()),
          ),
          child: Text(
            'Sign Up',
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

class _GlassmorphicSocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isLoading;
  final VoidCallback onTap;

  const _GlassmorphicSocialButton({
    required this.icon,
    required this.label,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.white.withValues(alpha: 0.08),
          highlightColor: Colors.white.withValues(alpha: 0.04),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AuraQuoteColors.onSurfaceVariant, size: 22),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: AuraQuoteTypography.uiControl.copyWith(
                    color: AuraQuoteColors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
