// lib/screens/chat/widgets/calendar_event_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/app_theme.dart';
import '../../../models/aria_models.dart';

// ─────────────────────────────────────────────────────────────────────────
//  CALENDAR EVENT CARD
// ─────────────────────────────────────────────────────────────────────────
const _calAccent = Color(0xFF6B7FD7);
const _calBg     = Color(0xFFEEF0FB);

class CalendarEventCard extends StatelessWidget {
  final CalendarEvent event;
  final int index;
  final VoidCallback? onJoin;

  const CalendarEventCard({
    super.key, required this.event, required this.index, this.onJoin,
  });

  Color get _color {
    if (event.status == EventStatus.cancelled) return AriaColors.error;
    if (event.status == EventStatus.tentative)  return AriaColors.warning;
    if (event.isNow)                            return AriaColors.success;
    return _calAccent;
  }

  String get _badgeLabel {
    if (event.isNow)                            return 'NOW';
    if (event.status == EventStatus.cancelled)  return 'Cancelled';
    if (event.status == EventStatus.tentative)  return 'Tentative';
    return event.timeRangeLabel.split('—')[0].trim();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AriaColors.surface,
        borderRadius: BorderRadius.circular(Rad.lg),
        border: Border.all(
            color: event.isNow ? AriaColors.success.withOpacity(0.4) : AriaColors.divider,
            width: event.isNow ? 1.5 : 1),
        boxShadow: AriaShadow.card,
      ),
      child: IntrinsicHeight(
        child: Row(children: [
          // Left color strip
          Container(
            width: 5,
            decoration: BoxDecoration(
              color: _color,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(Rad.lg),
                  bottomLeft: Radius.circular(Rad.lg)),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(13),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Title + badge
                Row(children: [
                  Expanded(
                    child: Text(event.title,
                        style: AriaText.titleMedium.copyWith(
                            color: event.status == EventStatus.cancelled
                                ? AriaColors.textHint : AriaColors.textPrimary,
                            decoration: event.status == EventStatus.cancelled
                                ? TextDecoration.lineThrough : null)),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: event.isNow ? _color : _color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(Rad.full),
                    ),
                    child: Text(_badgeLabel, style: TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.3,
                        color: event.isNow ? Colors.white : _color)),
                  ),
                ]),

                const SizedBox(height: 7),

                // Time + duration
                Row(children: [
                  Icon(Icons.access_time_rounded, size: 13, color: AriaColors.textHint),
                  const SizedBox(width: 5),
                  Text(event.timeRangeLabel,
                      style: AriaText.bodySmall.copyWith(
                          color: AriaColors.textSecondary, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 10),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                          color: AriaColors.inputFill,
                          borderRadius: BorderRadius.circular(Rad.xs)),
                      child: Text(event.durationLabel, style: AriaText.bodySmall)),
                ]),

                // Location or online
                if (event.isOnline || (event.location?.isNotEmpty == true)) ...[
                  const SizedBox(height: 5),
                  Row(children: [
                    Icon(event.isOnline ? Icons.videocam_rounded : Icons.location_on_rounded,
                        size: 13, color: event.isOnline ? _color : AriaColors.textHint),
                    const SizedBox(width: 5),
                    Text(event.isOnline ? 'Google Meet' : event.location!,
                        style: AriaText.bodySmall.copyWith(
                            color: event.isOnline ? _color : AriaColors.textHint)),
                  ]),
                ],

                // Description
                if (event.description?.isNotEmpty == true) ...[
                  const SizedBox(height: 5),
                  Text(event.description!,
                      style: AriaText.bodySmall,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                ],

                // Attendees
                if (event.attendees.isNotEmpty) ...[
                  const SizedBox(height: 9),
                  _AttendeesRow(event.attendees),
                ],

                // Join button
                if (event.isOnline && event.status != EventStatus.cancelled &&
                    (event.isNow || event.isUpcoming)) ...[
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: onJoin,
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: event.isNow
                              ? [AriaColors.success, Color.lerp(AriaColors.success, Colors.black, 0.12)!]
                              : [_color, Color.lerp(_color, Colors.black, 0.15)!],
                          begin: Alignment.topLeft, end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(Rad.sm),
                        boxShadow: [BoxShadow(
                            color: (event.isNow ? AriaColors.success : _color).withOpacity(0.3),
                            blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Icon(Icons.videocam_rounded, size: 15, color: Colors.white),
                        const SizedBox(width: 7),
                        Text(event.isNow ? 'Join Now' : 'Join Meeting',
                            style: AriaText.buttonSmall.copyWith(color: Colors.white)),
                      ]),
                    ),
                  ),
                ],
              ]),
            ),
          ),
        ]),
      ),
    )
        .animate(delay: Duration(milliseconds: index * 75))
        .fadeIn(duration: 380.ms)
        .slideY(begin: 0.12, duration: 380.ms, curve: Curves.easeOut);
  }
}

class _AttendeesRow extends StatelessWidget {
  final List<String> attendees;
  const _AttendeesRow(this.attendees);

  @override
  Widget build(BuildContext context) {
    final shown = attendees.take(5).toList();
    final extra = attendees.length - shown.length;
    return Row(children: [
      ...shown.asMap().entries.map((e) => Align(
        widthFactor: e.key == 0 ? 1.0 : 0.65,
        child: Container(
          width: 24, height: 24,
          decoration: BoxDecoration(
              color: _calBg,
              shape: BoxShape.circle,
              border: Border.all(color: AriaColors.surface, width: 1.5)),
          child: Center(child: Text(
              e.value.isNotEmpty ? e.value[0].toUpperCase() : '?',
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                  color: _calAccent))),
        ),
      )),
      if (extra > 0) ...[
        const SizedBox(width: 7),
        Text('+$extra more', style: AriaText.bodySmall),
      ],
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────
//  CALENDAR LIST WIDGET
// ─────────────────────────────────────────────────────────────────────────
class CalendarListWidget extends StatelessWidget {
  final List<CalendarEvent> events;
  final bool isLoading;
  final void Function(CalendarEvent)? onJoin;

  const CalendarListWidget({
    super.key, required this.events,
    this.isLoading = false, this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    final happening = events.where((e) => e.isNow).toList();
    final upcoming  = events.where((e) => e.isUpcoming && !e.isNow).toList();
    final past      = events.where((e) => e.isPast).toList();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Header
      Padding(padding: const EdgeInsets.only(bottom: 12),
          child: Row(children: [
            Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: _calBg,
                  borderRadius: BorderRadius.circular(Rad.sm),
                  border: Border.all(color: _calAccent.withOpacity(0.3)),
                ),
                child: const Icon(Icons.calendar_today_rounded,
                    size: 16, color: _calAccent)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Today's Schedule",
                  style: AriaText.titleMedium.copyWith(color: _calAccent)),
              if (!isLoading)
                Text('${events.length} event${events.length != 1 ? "s" : ""} today',
                    style: AriaText.bodySmall.copyWith(color: AriaColors.textHint)),
            ])),
            if (events.isNotEmpty)
              StatusBadge('${events.length}', color: _calAccent),
          ])),

      if (isLoading)
        ..._buildLoading()
      else if (events.isEmpty)
        _buildEmpty()
      else
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (happening.isNotEmpty) ...[
            _SecLabel('🟢 Happening Now', AriaColors.success),
            ...happening.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CalendarEventCard(event: e.value, index: e.key,
                    onJoin: onJoin != null ? () => onJoin!(e.value) : null))),
          ],
          if (upcoming.isNotEmpty) ...[
            if (happening.isNotEmpty) const SizedBox(height: 6),
            _SecLabel('📅 Coming Up', _calAccent),
            ...upcoming.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CalendarEventCard(event: e.value, index: e.key,
                    onJoin: onJoin != null ? () => onJoin!(e.value) : null))),
          ],
          if (past.isNotEmpty) ...[
            const SizedBox(height: 6),
            _SecLabel('⏱️ Earlier Today', AriaColors.textHint),
            ...past.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CalendarEventCard(event: e.value, index: e.key))),
          ],
        ]),
    ]);
  }

  List<Widget> _buildLoading() => List.generate(2, (i) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    height: 90,
    decoration: BoxDecoration(
        color: AriaColors.surface,
        borderRadius: BorderRadius.circular(Rad.lg),
        border: Border.all(color: AriaColors.divider)),
  ));

  Widget _buildEmpty() => Container(
    padding: const EdgeInsets.symmetric(vertical: 32),
    child: Center(child: Column(children: [
      Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: _calBg, shape: BoxShape.circle),
          child: const Icon(Icons.event_available_rounded, size: 40, color: _calAccent)),
      const SizedBox(height: 14),
      Text('No meetings today! 🎉', style: AriaText.headlineSmall),
      const SizedBox(height: 4),
      Text('Your schedule is clear', style: AriaText.bodySmall),
    ])),
  );
}

class _SecLabel extends StatelessWidget {
  final String label; final Color color;
  const _SecLabel(this.label, this.color);
  @override Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 9, left: 2),
      child: Text(label, style: AriaText.labelSmall.copyWith(
          color: color, fontWeight: FontWeight.w700, letterSpacing: 0.5)));
}
