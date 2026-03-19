import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../auth/auth_providers.dart';
import '../../../data/app_database.dart';
import '../../../theme/app_theme.dart';

class MeetingIntelligenceScreen extends ConsumerWidget {
  const MeetingIntelligenceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = auth.user;
    if (user == null) return const Center(child: Text('Please login to use Meetings.'));

    final db = ref.watch(appDatabaseProvider);

    return StreamBuilder<List<DbMeeting>>(
      stream: db.watchMeetings(user.id),
      builder: (context, snap) {
        final items = snap.data ?? const [];
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Header(),
            const SizedBox(height: 12),
            if (items.isEmpty)
              _EmptyState(
                title: 'No meetings yet',
                subtitle: 'Tap + to add a meeting record and summary.',
              )
            else
              ...items.map((m) => _MeetingTile(
                    m: m,
                    onDelete: () => db.deleteMeeting(m.id, user.id),
                  )),
            const SizedBox(height: 80),
          ],
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AriaColors.surface,
          borderRadius: BorderRadius.circular(Rad.xl),
          border: Border.all(color: AriaColors.divider),
          boxShadow: AriaShadow.subtle,
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: AriaColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.mic_rounded, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Save meetings, participants, and AI summary locally.\n(Zoom/Meet auto-join + transcription is a later step.)',
                style: AriaText.bodySmall,
              ),
            ),
          ],
        ),
      );
}

class _MeetingTile extends StatelessWidget {
  final DbMeeting m;
  final VoidCallback onDelete;
  const _MeetingTile({required this.m, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final when = DateFormat('dd MMM • hh:mm a').format(m.startTime);
    final duration = m.endTime.difference(m.startTime);
    final mins = duration.inMinutes;
    final durLabel = mins < 60 ? '${mins}m' : '${mins ~/ 60}h ${mins % 60}m';
    final summary = (m.summary ?? '').trim();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AriaColors.surface,
        borderRadius: BorderRadius.circular(Rad.lg),
        border: Border.all(color: AriaColors.divider),
        boxShadow: AriaShadow.subtle,
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AriaColors.primarySurface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.meeting_room_rounded, color: AriaColors.primary),
        ),
        title: Text(m.title, style: AriaText.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '$when • $durLabel • ${m.platform}${summary.isEmpty ? '' : '\n$summary'}',
          style: AriaText.bodySmall,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        isThreeLine: summary.isNotEmpty,
        trailing: IconButton(
          tooltip: 'Delete',
          icon: const Icon(Icons.delete_outline_rounded, color: AriaColors.error),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  const _EmptyState({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AriaColors.surface,
          borderRadius: BorderRadius.circular(Rad.xl),
          border: Border.all(color: AriaColors.divider),
          boxShadow: AriaShadow.subtle,
        ),
        child: Column(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                gradient: AriaColors.primaryGradient,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.mic_rounded, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(title, style: AriaText.titleMedium.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(subtitle, style: AriaText.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      );
}

Future<void> showAddMeetingSheet(
  BuildContext context,
  AppDatabase db,
  int userId,
) async {
  final titleCtrl = TextEditingController();
  final platformCtrl = TextEditingController(text: 'Meet');
  final summaryCtrl = TextEditingController();
  DateTime start = DateTime.now().add(const Duration(hours: 1));
  DateTime end = DateTime.now().add(const Duration(hours: 2));

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) {
        final bottom = MediaQuery.of(context).viewInsets.bottom;
        return Container(
          padding: EdgeInsets.fromLTRB(16, 12, 16, bottom + 16),
          decoration: BoxDecoration(
            color: AriaColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(Rad.xl)),
            border: Border.all(color: AriaColors.divider),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AriaColors.divider,
                    borderRadius: BorderRadius.circular(Rad.full),
                  ),
                ),
              ),
              Text('Add meeting', style: AriaText.headlineSmall),
              const SizedBox(height: 12),
              _f(label: 'Title *', ctrl: titleCtrl),
              const SizedBox(height: 10),
              _f(label: 'Platform', ctrl: platformCtrl),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                          initialDate: start,
                        );
                        if (picked != null) {
                          setState(() {
                            start = DateTime(picked.year, picked.month, picked.day, start.hour, start.minute);
                            end = start.add(const Duration(hours: 1));
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_today_rounded, size: 18),
                      label: Text(DateFormat('dd MMM').format(start)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AriaColors.divider),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Rad.lg),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(start));
                        if (t != null) {
                          setState(() {
                            start = DateTime(start.year, start.month, start.day, t.hour, t.minute);
                            end = start.add(const Duration(hours: 1));
                          });
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AriaColors.divider),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Rad.lg)),
                      ),
                      child: Text(DateFormat('hh:mm a').format(start), style: AriaText.titleMedium),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _f(label: 'Summary (optional)', ctrl: summaryCtrl, maxLines: 2),
              const SizedBox(height: 14),
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: () async {
                    final title = titleCtrl.text.trim();
                    if (title.isEmpty) return;
                    if (!end.isAfter(start)) end = start.add(const Duration(minutes: 30));
                    await db.addMeeting(
                      userId: userId,
                      title: title,
                      startTime: start,
                      endTime: end,
                      platform: platformCtrl.text.trim().isEmpty ? 'Meet' : platformCtrl.text.trim(),
                      summary: summaryCtrl.text.trim(),
                    );
                    if (context.mounted) Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Rad.lg),
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: AriaColors.primaryGradient,
                      borderRadius: BorderRadius.circular(Rad.lg),
                    ),
                    child: Center(
                      child: Text('Save', style: AriaText.button.copyWith(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

Widget _f({
  required String label,
  required TextEditingController ctrl,
  int maxLines = 1,
}) {
  return TextField(
    controller: ctrl,
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AriaColors.inputFill,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Rad.lg),
        borderSide: const BorderSide(color: AriaColors.divider),
      ),
    ),
  );
}

