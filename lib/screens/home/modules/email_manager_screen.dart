import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/auth_providers.dart';
import '../../../theme/app_theme.dart';
import '../../../models/aria_models.dart';

class EmailManagerScreen extends ConsumerWidget {
  const EmailManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = auth.user;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _HeaderCard(
          title: 'AI Email Manager',
          subtitle:
              'View important emails, draft replies, and track status (local demo).',
        ),
        const SizedBox(height: 12),
        if (user == null)
          _InfoCard(
            title: 'Not logged in',
            subtitle: 'Please login to use email features.',
          )
        else ...[
          _InfoCard(
            title: 'Top emails (demo)',
            subtitle:
                'This build shows sample emails inside Chat. Next step is Gmail OAuth.',
          ),
          const SizedBox(height: 12),
          ...EmailModel.samples.map((e) => _EmailTile(e)),
        ],
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  const _HeaderCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AriaColors.surface,
          borderRadius: BorderRadius.circular(Rad.xl),
          border: Border.all(color: AriaColors.divider),
          boxShadow: AriaShadow.subtle,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AriaText.headlineSmall),
            const SizedBox(height: 6),
            Text(subtitle, style: AriaText.bodySmall),
          ],
        ),
      );
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  const _InfoCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AriaColors.primarySurface,
          borderRadius: BorderRadius.circular(Rad.xl),
          border: Border.all(color: AriaColors.primaryBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AriaText.titleMedium.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(subtitle, style: AriaText.bodySmall),
          ],
        ),
      );
}

class _EmailTile extends StatelessWidget {
  final EmailModel e;
  const _EmailTile(this.e);

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AriaColors.surface,
          borderRadius: BorderRadius.circular(Rad.lg),
          border: Border.all(color: AriaColors.divider),
          boxShadow: AriaShadow.subtle,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AriaColors.secondarySurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.email_rounded, color: AriaColors.secondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.subject, style: AriaText.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text(e.preview, style: AriaText.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text('${e.fromName} • ${e.timeAgo}', style: AriaText.caption),
                ],
              ),
            ),
          ],
        ),
      );
}

