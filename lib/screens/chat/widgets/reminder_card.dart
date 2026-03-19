// lib/screens/chat/widgets/reminder_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/app_theme.dart';
import '../../../models/aria_models.dart';

// ─────────────────────────────────────────────────────────────────────────
//  REMINDER CARD
// ─────────────────────────────────────────────────────────────────────────
class ReminderCard extends StatelessWidget {
  final ReminderModel reminder;
  final int index;
  final VoidCallback? onDone;
  final VoidCallback? onUndo;
  final VoidCallback? onDelete;

  const ReminderCard({
    super.key, required this.reminder, required this.index,
    this.onDone, this.onUndo, this.onDelete,
  });

  Color get _stateColor {
    if (reminder.isDone)    return AriaColors.success;
    if (reminder.isOverdue) return AriaColors.error;
    if (reminder.isToday)   return AriaColors.warning;
    return AriaColors.secondary;
  }

  Color get _stateBg {
    if (reminder.isDone)    return AriaColors.successBg;
    if (reminder.isOverdue) return AriaColors.errorBg;
    if (reminder.isToday)   return AriaColors.warningBg;
    return AriaColors.secondarySurface;
  }

  IconData get _stateIcon {
    if (reminder.isDone)    return Icons.check_circle_rounded;
    if (reminder.isOverdue) return Icons.warning_amber_rounded;
    if (reminder.isToday)   return Icons.schedule_rounded;
    return Icons.notifications_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: reminder.isDone ? 0.55 : 1.0,
      duration: 250.ms,
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AriaColors.surface,
          borderRadius: BorderRadius.circular(Rad.lg),
          border: Border.all(
            color: reminder.isOverdue && !reminder.isDone
                ? AriaColors.error.withOpacity(0.4) : AriaColors.divider,
            width: reminder.isOverdue && !reminder.isDone ? 1.5 : 1,
          ),
          boxShadow: AriaShadow.subtle,
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          // Icon
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: _stateBg,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: _stateColor.withOpacity(0.3)),
            ),
            child: Icon(_stateIcon, size: 20, color: _stateColor),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(reminder.title,
                style: AriaText.titleMedium.copyWith(
                  decoration: reminder.isDone ? TextDecoration.lineThrough : null,
                  decorationColor: AriaColors.textHint,
                  color: reminder.isDone ? AriaColors.textHint : AriaColors.textPrimary,
                )),
              const SizedBox(height: 4),
              Row(children: [
                Icon(Icons.access_time_rounded, size: 11, color: _stateColor),
                const SizedBox(width: 4),
                Text(reminder.timeLabel,
                  style: AriaText.labelSmall.copyWith(
                    color: _stateColor, fontWeight: FontWeight.w600)),
                if (reminder.repeat != ReminderRepeat.none) ...[
                  const SizedBox(width: 8),
                  Container(width: 3, height: 3,
                    decoration: const BoxDecoration(
                      color: AriaColors.textHint, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text('${reminder.repeat.icon} ${reminder.repeat.label}',
                    style: AriaText.labelSmall),
                ],
              ]),
              if (reminder.note != null && reminder.note!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(reminder.note!,
                  style: AriaText.bodySmall.copyWith(color: AriaColors.textHint),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ],
          )),
          const SizedBox(width: 8),

          // Action buttons
          Column(mainAxisSize: MainAxisSize.min, children: [
            if (!reminder.isDone && onDone != null)
              _IconBtn(Icons.check_rounded, AriaColors.success, onDone!),
            if (reminder.isDone && onUndo != null)
              _IconBtn(Icons.undo_rounded, AriaColors.textHint, onUndo!),
            if (onDone != null || onUndo != null) const SizedBox(height: 5),
            if (onDelete != null)
              _IconBtn(Icons.delete_outline_rounded, AriaColors.error, onDelete!),
          ]),
        ]),
      ),
    )
    .animate(delay: Duration(milliseconds: index * 65))
    .fadeIn(duration: 380.ms)
    .slideY(begin: 0.12, duration: 380.ms, curve: Curves.easeOut);
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon; final Color color; final VoidCallback onTap;
  const _IconBtn(this.icon, this.color, this.onTap);
  @override Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Rad.sm),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Icon(icon, size: 15, color: color),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────
//  REMINDER LIST WIDGET
// ─────────────────────────────────────────────────────────────────────────
class ReminderListWidget extends StatelessWidget {
  final List<ReminderModel> reminders;
  final bool isLoading;
  final void Function(ReminderModel)? onDone;
  final void Function(ReminderModel)? onUndo;
  final void Function(ReminderModel)? onDelete;

  const ReminderListWidget({
    super.key, required this.reminders, this.isLoading = false,
    this.onDone, this.onUndo, this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final overdue  = reminders.where((r) => r.isOverdue && !r.isDone).toList();
    final today    = reminders.where((r) => r.isToday && !r.isOverdue && !r.isDone).toList();
    final upcoming = reminders.where((r) => !r.isToday && !r.isOverdue && !r.isDone).toList();
    final done     = reminders.where((r) => r.isDone).toList();
    final pending  = reminders.where((r) => !r.isDone).length;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Header
      Padding(padding: const EdgeInsets.only(bottom: 12),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AriaColors.primarySurface,
              borderRadius: BorderRadius.circular(Rad.sm),
              border: Border.all(color: AriaColors.primaryBorder),
            ),
            child: const Icon(Icons.notifications_active_rounded,
              size: 16, color: AriaColors.primary)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Your Reminders',
              style: AriaText.titleMedium.copyWith(color: AriaColors.primary)),
            if (!isLoading)
              Text('$pending pending${overdue.isNotEmpty ? ' • ${overdue.length} overdue' : ''}',
                style: AriaText.bodySmall.copyWith(color: AriaColors.textHint)),
          ])),
          if (pending > 0)
            StatusBadge('$pending', color: AriaColors.primary),
        ])),

      if (isLoading)
        ..._buildLoading()
      else if (reminders.isEmpty)
        _buildEmpty()
      else
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (overdue.isNotEmpty) ...[
            _SecLabel('⚠️ Overdue', AriaColors.error),
            ...overdue.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ReminderCard(reminder: e.value, index: e.key,
                onDone:   onDone   != null ? () => onDone!(e.value)   : null,
                onDelete: onDelete != null ? () => onDelete!(e.value) : null))),
          ],
          if (today.isNotEmpty) ...[
            if (overdue.isNotEmpty) const SizedBox(height: 6),
            _SecLabel('🌤️ Today', AriaColors.warning),
            ...today.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ReminderCard(reminder: e.value, index: e.key,
                onDone:   onDone   != null ? () => onDone!(e.value)   : null,
                onDelete: onDelete != null ? () => onDelete!(e.value) : null))),
          ],
          if (upcoming.isNotEmpty) ...[
            if (overdue.isNotEmpty || today.isNotEmpty) const SizedBox(height: 6),
            _SecLabel('📆 Upcoming', AriaColors.secondary),
            ...upcoming.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ReminderCard(reminder: e.value, index: e.key,
                onDone:   onDone   != null ? () => onDone!(e.value)   : null,
                onDelete: onDelete != null ? () => onDelete!(e.value) : null))),
          ],
          if (done.isNotEmpty) ...[
            const SizedBox(height: 6),
            _SecLabel('✅ Completed (${done.length})', AriaColors.success),
            ...done.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ReminderCard(reminder: e.value, index: e.key,
                onUndo:   onUndo   != null ? () => onUndo!(e.value)   : null,
                onDelete: onDelete != null ? () => onDelete!(e.value) : null))),
          ],
        ]),
    ]);
  }

  List<Widget> _buildLoading() => List.generate(3, (i) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: AriaColors.surface,
      borderRadius: BorderRadius.circular(Rad.lg),
      border: Border.all(color: AriaColors.divider)),
    child: Row(children: [
      ShimmerBox(width: 42, height: 42, radius: 11),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ShimmerBox(width: 160, height: 13, radius: 4),
        const SizedBox(height: 7),
        ShimmerBox(width: 90, height: 10, radius: 4),
      ])),
    ]),
  ));

  Widget _buildEmpty() => Container(
    padding: const EdgeInsets.symmetric(vertical: 32),
    child: Center(child: Column(children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AriaColors.primarySurface, shape: BoxShape.circle),
        child: const Icon(Icons.notifications_none_rounded,
          size: 40, color: AriaColors.primary)),
      const SizedBox(height: 14),
      Text('No reminders yet', style: AriaText.headlineSmall),
      const SizedBox(height: 6),
      Text('Say "Remind me tomorrow at 9am to call client"',
        style: AriaText.bodySmall.copyWith(
          color: AriaColors.textHint, fontStyle: FontStyle.italic),
        textAlign: TextAlign.center),
    ])),
  );
}

class _SecLabel extends StatelessWidget {
  final String label; final Color color;
  const _SecLabel(this.label, this.color);
  @override Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8, left: 2),
    child: Text(label, style: AriaText.labelSmall.copyWith(
      color: color, fontWeight: FontWeight.w700, letterSpacing: 0.5)));
}
