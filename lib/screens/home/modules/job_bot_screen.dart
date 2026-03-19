import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../auth/auth_providers.dart';
import '../../../data/app_database.dart';
import '../../../theme/app_theme.dart';

class JobBotScreen extends ConsumerWidget {
  const JobBotScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = auth.user;
    if (user == null) return const Center(child: Text('Please login to use Job Bot.'));

    final db = ref.watch(appDatabaseProvider);

    return StreamBuilder<List<DbJobApplication>>(
      stream: db.watchJobApplications(user.id),
      builder: (context, snap) {
        final items = snap.data ?? const [];
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Header(),
            const SizedBox(height: 12),
            if (items.isEmpty)
              _EmptyState(
                title: 'No applications yet',
                subtitle: 'Tap + to add a job application record.',
              )
            else
              ...items.map((j) => _JobTile(
                    j: j,
                    onDelete: () => db.deleteJobApplication(j.id, user.id),
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
              child: const Icon(Icons.work_rounded, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Track your job applications locally.\n(Automation via LinkedIn/Puppeteer is a later step.)',
                style: AriaText.bodySmall,
              ),
            ),
          ],
        ),
      );
}

class _JobTile extends StatelessWidget {
  final DbJobApplication j;
  final VoidCallback onDelete;
  const _JobTile({required this.j, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final when = DateFormat('dd MMM').format(j.appliedAt);
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
            color: AriaColors.secondarySurface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.work_rounded, color: AriaColors.secondary),
        ),
        title: Text('${j.role} @ ${j.company}',
            style: AriaText.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text('${j.status} • $when${(j.jobUrl ?? '').trim().isEmpty ? '' : '\n${j.jobUrl}'}',
            style: AriaText.bodySmall),
        isThreeLine: (j.jobUrl ?? '').trim().isNotEmpty,
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
              child: const Icon(Icons.work_rounded, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(title, style: AriaText.titleMedium.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(subtitle, style: AriaText.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      );
}

Future<void> showAddJobSheet(
  BuildContext context,
  AppDatabase db,
  int userId,
) async {
  final companyCtrl = TextEditingController();
  final roleCtrl = TextEditingController();
  final urlCtrl = TextEditingController();
  final statusCtrl = TextEditingController(text: 'Applied');
  final notesCtrl = TextEditingController();

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
              Text('Add job application', style: AriaText.headlineSmall),
              const SizedBox(height: 12),
              _f(label: 'Company *', ctrl: companyCtrl),
              const SizedBox(height: 10),
              _f(label: 'Role *', ctrl: roleCtrl),
              const SizedBox(height: 10),
              _f(label: 'Job URL', ctrl: urlCtrl),
              const SizedBox(height: 10),
              _f(label: 'Status', ctrl: statusCtrl),
              const SizedBox(height: 10),
              _f(label: 'Notes', ctrl: notesCtrl, maxLines: 2),
              const SizedBox(height: 14),
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: () async {
                    if (companyCtrl.text.trim().isEmpty || roleCtrl.text.trim().isEmpty) return;
                    await db.addJobApplication(
                      userId: userId,
                      company: companyCtrl.text,
                      role: roleCtrl.text,
                      jobUrl: urlCtrl.text.trim(),
                      status: statusCtrl.text.trim().isEmpty ? 'Applied' : statusCtrl.text.trim(),
                      notes: notesCtrl.text.trim(),
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

