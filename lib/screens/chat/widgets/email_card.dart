// lib/screens/chat/widgets/email_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/app_theme.dart';
import '../../../models/aria_models.dart';

// ─────────────────────────────────────────────────────────────────────────
//  EMAIL CARD
// ─────────────────────────────────────────────────────────────────────────
class EmailCard extends StatefulWidget {
  final EmailModel email;
  final int index;
  final void Function(EmailModel)? onReply;
  final void Function(EmailModel)? onOpen;

  const EmailCard({
    super.key, required this.email, required this.index,
    this.onReply, this.onOpen,
  });

  @override
  State<EmailCard> createState() => _EmailCardState();
}

class _EmailCardState extends State<EmailCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _expandCtrl;

  Color get _pColor => switch(widget.email.priority) {
    EmailPriority.urgent => AriaColors.urgent,
    EmailPriority.high   => AriaColors.high,
    EmailPriority.normal => AriaColors.secondary,
    EmailPriority.low    => AriaColors.textHint,
  };

  Color get _pBg => switch(widget.email.priority) {
    EmailPriority.urgent => AriaColors.urgentBg,
    EmailPriority.high   => AriaColors.warningBg,
    EmailPriority.normal => AriaColors.secondarySurface,
    EmailPriority.low    => AriaColors.inputFill,
  };

  @override
  void initState() {
    super.initState();
    _expandCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 250));
  }

  @override
  void dispose() { _expandCtrl.dispose(); super.dispose(); }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) _expandCtrl.forward();
      else _expandCtrl.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: 250.ms,
        decoration: BoxDecoration(
          color: AriaColors.surface,
          borderRadius: BorderRadius.circular(Rad.lg),
          border: Border.all(
            color: widget.email.isImportant ? _pColor.withOpacity(0.4) : AriaColors.divider,
            width: widget.email.isImportant ? 1.5 : 1,
          ),
          boxShadow: AriaShadow.card,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Header ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _EmailAvatar(name: widget.email.fromName, color: _pColor),
              const SizedBox(width: 10),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(child: Text(widget.email.fromName,
                      style: AriaText.titleMedium,
                      overflow: TextOverflow.ellipsis)),
                    Text(widget.email.timeAgo, style: AriaText.labelSmall),
                  ]),
                  const SizedBox(height: 3),
                  Text(widget.email.subject,
                    style: AriaText.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AriaColors.textPrimary),
                    maxLines: _expanded ? null : 1,
                    overflow: _expanded ? null : TextOverflow.ellipsis),
                ],
              )),
              const SizedBox(width: 6),
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0,
                duration: 250.ms,
                child: const Icon(Icons.keyboard_arrow_down_rounded,
                  size: 20, color: AriaColors.textHint),
              ),
            ]),
          ),

          // ── Preview (collapsed) ───────────────────────────────
          if (!_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
              child: Text(widget.email.preview,
                style: AriaText.bodySmall.copyWith(color: AriaColors.textHint),
                maxLines: 1, overflow: TextOverflow.ellipsis)),

          // ── Priority badges row ───────────────────────────────
          if (widget.email.priority != EmailPriority.low || !widget.email.isRead)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
              child: Row(children: [
                if (widget.email.priority != EmailPriority.low)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _pBg, borderRadius: BorderRadius.circular(Rad.full)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(_priorityIcon, size: 10, color: _pColor),
                      const SizedBox(width: 4),
                      Text(widget.email.priority.label,
                        style: AriaText.labelSmall.copyWith(
                          color: _pColor, fontWeight: FontWeight.w700)),
                    ]),
                  ),
                if (!widget.email.isRead) ...[
                  const SizedBox(width: 8),
                  Container(width: 6, height: 6,
                    decoration: const BoxDecoration(
                      color: AriaColors.secondary, shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  Text('Unread', style: AriaText.labelSmall.copyWith(
                    color: AriaColors.secondary)),
                ],
                const Spacer(),
                // Labels
                ...widget.email.labels.take(2).map((l) => Container(
                  margin: const EdgeInsets.only(left: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AriaColors.inputFill,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(l, style: const TextStyle(fontSize: 9,
                    color: AriaColors.textHint, fontWeight: FontWeight.w500)),
                )),
              ]),
            ),

          // ── Expanded content ──────────────────────────────────
          if (_expanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // AI importance reason
                if (widget.email.importanceReason.isNotEmpty)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: _pColor.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(Rad.md),
                      border: Border.all(color: _pColor.withOpacity(0.2)),
                    ),
                    child: Row(children: [
                      Icon(Icons.auto_awesome_rounded, size: 14, color: _pColor),
                      const SizedBox(width: 8),
                      Expanded(child: Text(
                        '🤖 ${widget.email.importanceReason}',
                        style: AriaText.bodySmall.copyWith(color: _pColor))),
                    ]),
                  ),

                // Email body
                Text(widget.email.body,
                  style: AriaText.bodyMedium.copyWith(
                    color: AriaColors.textPrimary, height: 1.7)),

                const SizedBox(height: 16),

                // Actions
                Row(children: [
                  Expanded(child: _ActionButton(
                    icon: Icons.reply_rounded,
                    label: 'Draft Reply',
                    color: AriaColors.secondary,
                    onTap: () => widget.onReply?.call(widget.email),
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: _ActionButton(
                    icon: Icons.open_in_new_rounded,
                    label: 'Open Gmail',
                    color: AriaColors.textSecondary,
                    outlined: true,
                    onTap: () => widget.onOpen?.call(widget.email),
                  )),
                ]),
              ]),
            ),
          ],
        ]),
      ),
    )
    .animate(delay: Duration(milliseconds: widget.index * 70))
    .fadeIn(duration: 400.ms)
    .slideY(begin: 0.15, duration: 400.ms, curve: Curves.easeOut);
  }

  IconData get _priorityIcon => switch(widget.email.priority) {
    EmailPriority.urgent => Icons.priority_high_rounded,
    EmailPriority.high   => Icons.arrow_upward_rounded,
    EmailPriority.normal => Icons.remove_rounded,
    EmailPriority.low    => Icons.arrow_downward_rounded,
  };
}

class _EmailAvatar extends StatelessWidget {
  final String name;
  final Color color;
  const _EmailAvatar({required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().split(' ').take(2)
        .map((w) => w.isNotEmpty ? w[0] : '').join().toUpperCase();
    return Container(
      width: 40, height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: color.withOpacity(0.3), width: 1.2),
      ),
      child: Center(child: Text(initials.isEmpty ? '?' : initials,
        style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700))),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool outlined;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon, required this.label, required this.color,
    this.outlined = false, this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 38,
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : color,
        borderRadius: BorderRadius.circular(Rad.sm),
        border: Border.all(color: outlined ? color : Colors.transparent),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 15, color: outlined ? color : Colors.white),
        const SizedBox(width: 6),
        Text(label, style: AriaText.buttonSmall.copyWith(
          color: outlined ? color : Colors.white)),
      ]),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────
//  EMAIL LIST WIDGET
// ─────────────────────────────────────────────────────────────────────────
class EmailListWidget extends StatelessWidget {
  final List<EmailModel> emails;
  final bool isLoading;
  final void Function(EmailModel)? onReply;
  final void Function(EmailModel)? onOpen;

  const EmailListWidget({
    super.key, required this.emails,
    this.isLoading = false, this.onReply, this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Header
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AriaColors.secondarySurface,
              borderRadius: BorderRadius.circular(Rad.sm),
              border: Border.all(color: AriaColors.secondaryBorder),
            ),
            child: const Icon(Icons.mark_email_unread_rounded,
              size: 16, color: AriaColors.secondary),
          ),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(isLoading ? 'Fetching emails...' : 'Important Emails',
              style: AriaText.titleMedium.copyWith(color: AriaColors.secondary)),
            if (!isLoading && emails.isNotEmpty)
              Text('${emails.length} emails • AI-ranked',
                style: AriaText.bodySmall.copyWith(color: AriaColors.textHint)),
          ])),
          if (!isLoading && emails.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AriaColors.secondarySurface,
                borderRadius: BorderRadius.circular(Rad.full),
                border: Border.all(color: AriaColors.secondaryBorder),
              ),
              child: Text('${emails.length}',
                style: AriaText.labelMedium.copyWith(color: AriaColors.secondary)),
            ),
        ]),
      ),

      if (isLoading)
        ..._buildLoadingList()
      else if (emails.isEmpty)
        _buildEmptyState()
      else
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: emails.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) => EmailCard(
            email: emails[i], index: i,
            onReply: onReply, onOpen: onOpen,
          ),
        ),
    ]);
  }

  List<Widget> _buildLoadingList() => List.generate(3, (i) =>
    Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AriaColors.surface,
          borderRadius: BorderRadius.circular(Rad.lg),
          border: Border.all(color: AriaColors.divider),
        ),
        child: Row(children: [
          ShimmerBox(width: 40, height: 40, radius: 11),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ShimmerBox(width: 130, height: 13, radius: 4),
            const SizedBox(height: 7),
            ShimmerBox(width: double.infinity, height: 12, radius: 4),
            const SizedBox(height: 5),
            ShimmerBox(width: 180, height: 10, radius: 4),
          ])),
        ]),
      )
      .animate(delay: Duration(milliseconds: i * 80))
      .fadeIn(duration: 300.ms),
    ),
  );

  Widget _buildEmptyState() => Container(
    padding: const EdgeInsets.symmetric(vertical: 32),
    child: Center(child: Column(children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AriaColors.successBg, shape: BoxShape.circle),
        child: const Icon(Icons.inbox_rounded, size: 40, color: AriaColors.success)),
      const SizedBox(height: 14),
      Text('Inbox is clear! 🎉',
        style: AriaText.headlineSmall.copyWith(color: AriaColors.textPrimary)),
      const SizedBox(height: 4),
      Text('No important emails right now',
        style: AriaText.bodySmall.copyWith(color: AriaColors.textHint)),
    ])),
  );
}
