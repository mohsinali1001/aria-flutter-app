import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../auth/auth_providers.dart';
import '../../../data/app_database.dart';
import '../../../theme/app_theme.dart';

class PlannerScreen extends ConsumerWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = auth.user;
    if (user == null) {
      return const Center(child: Text('Please login to use Planner.'));
    }

    final db = ref.watch(appDatabaseProvider);

    return StreamBuilder<List<DbTask>>(
      stream: db.watchTasks(user.id),
      builder: (context, snap) {
        final tasks = snap.data ?? const [];
        final pending = tasks.where((t) => t.status != 'done').length;
        final done = tasks.where((t) => t.status == 'done').length;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _TopStats(pending: pending, done: done),
            const SizedBox(height: 12),
            if (tasks.isEmpty)
              _EmptyState(
                title: 'No tasks yet',
                subtitle: 'Tap + to add a task with optional due date.',
              )
            else
              ...tasks.map((t) => _TaskTile(
                    t: t,
                    onToggle: (v) => db.setTaskStatus(
                      id: t.id,
                      userId: user.id,
                      done: v,
                    ),
                    onDelete: () => db.deleteTask(t.id, user.id),
                  )),
            const SizedBox(height: 80),
          ],
        );
      },
    );
  }
}

class _TopStats extends StatelessWidget {
  final int pending;
  final int done;
  const _TopStats({required this.pending, required this.done});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: _StatCard(
              label: 'Pending',
              value: '$pending',
              color: AriaColors.warning,
              icon: Icons.notifications_rounded,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              label: 'Done',
              value: '$done',
              color: AriaColors.success,
              icon: Icons.check_circle_rounded,
            ),
          ),
        ],
      );
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(Rad.xl),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AriaText.bodySmall),
                  const SizedBox(height: 4),
                  Text(value,
                      style: AriaText.headlineSmall.copyWith(
                        fontWeight: FontWeight.w900,
                      )),
                ],
              ),
            ),
          ],
        ),
      );
}

class _TaskTile extends StatelessWidget {
  final DbTask t;
  final void Function(bool) onToggle;
  final VoidCallback onDelete;
  const _TaskTile({required this.t, required this.onToggle, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final due = t.dueDate == null ? '' : DateFormat('dd MMM').format(t.dueDate!);
    final isDone = t.status == 'done';
    final prioColor = switch (t.priority) {
      2 => AriaColors.error,
      1 => AriaColors.primary,
      _ => AriaColors.textHint,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AriaColors.surface,
        borderRadius: BorderRadius.circular(Rad.lg),
        border: Border.all(color: AriaColors.divider),
        boxShadow: AriaShadow.subtle,
      ),
      child: ListTile(
        leading: Checkbox(
          value: isDone,
          onChanged: (v) => onToggle(v ?? false),
          activeColor: AriaColors.success,
        ),
        title: Text(
          t.title,
          style: AriaText.titleMedium.copyWith(
            decoration: isDone ? TextDecoration.lineThrough : null,
            color: isDone ? AriaColors.textHint : AriaColors.textPrimary,
          ),
        ),
        subtitle: Text(
          [
            if (t.description != null && t.description!.trim().isNotEmpty) t.description!,
            if (due.isNotEmpty) 'Due: $due',
          ].join(' • '),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AriaText.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: prioColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(Rad.full),
                border: Border.all(color: prioColor.withOpacity(0.2)),
              ),
              child: Text(
                switch (t.priority) { 2 => 'High', 1 => 'Med', _ => 'Low' },
                style: AriaText.labelSmall.copyWith(
                  color: prioColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete_outline_rounded, color: AriaColors.error),
              onPressed: onDelete,
            ),
          ],
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
              child: const Icon(Icons.event_available_rounded, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(title, style: AriaText.titleMedium.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(subtitle, style: AriaText.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      );
}

Future<void> showAddTaskSheet(
  BuildContext context,
  AppDatabase db,
  int userId,
) async {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  DateTime? due;
  int priority = 1;

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
              Text('Add task', style: AriaText.headlineSmall),
              const SizedBox(height: 12),
              TextField(
                controller: titleCtrl,
                decoration: InputDecoration(
                  labelText: 'Title *',
                  filled: true,
                  fillColor: AriaColors.inputFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Rad.lg),
                    borderSide: const BorderSide(color: AriaColors.divider),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Description',
                  filled: true,
                  fillColor: AriaColors.inputFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Rad.lg),
                    borderSide: const BorderSide(color: AriaColors.divider),
                  ),
                ),
              ),
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
                          initialDate: due ?? DateTime.now(),
                        );
                        if (picked != null) setState(() => due = picked);
                      },
                      icon: const Icon(Icons.calendar_today_rounded, size: 18),
                      label: Text(
                        due == null ? 'No due date' : DateFormat('dd MMM').format(due!),
                      ),
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
                    child: DropdownButtonFormField<int>(
                      value: priority,
                      items: const [
                        DropdownMenuItem(value: 0, child: Text('Low')),
                        DropdownMenuItem(value: 1, child: Text('Medium')),
                        DropdownMenuItem(value: 2, child: Text('High')),
                      ],
                      onChanged: (v) => setState(() => priority = v ?? 1),
                      decoration: InputDecoration(
                        labelText: 'Priority',
                        filled: true,
                        fillColor: AriaColors.inputFill,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Rad.lg),
                          borderSide: const BorderSide(color: AriaColors.divider),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: () async {
                    final title = titleCtrl.text.trim();
                    if (title.isEmpty) return;
                    await db.addTask(
                      userId: userId,
                      title: title,
                      description: descCtrl.text.trim(),
                      dueDate: due == null ? null : DateTime(due!.year, due!.month, due!.day, 12),
                      priority: priority,
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

