import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import 'cartoon_button.dart';

class EmptyStateView extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyStateView({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.blur_on_rounded,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustrated Soft Portal Visual
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer warm halo
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.warmSurface.withValues(alpha: 0.6),
                  ),
                ),
                // Mid glow ring
                Container(
                  width: 116,
                  height: 116,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.portalGreenLight,
                        AppTheme.turquoiseLight,
                        AppTheme.dimensionPurpleLight,
                      ],
                    ),
                    boxShadow: AppTheme.softShadow,
                  ),
                ),
                // Portal swirl inner circle
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        AppTheme.portalGreen,
                        AppTheme.turquoise,
                        AppTheme.cardDark,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.portalGreen.withValues(alpha: 0.3),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 44,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textDark,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              CartoonButton(
                text: buttonText!,
                onPressed: onButtonPressed,
                width: 200,
                height: 48,
                backgroundColor: AppTheme.cardDark,
                textColor: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
