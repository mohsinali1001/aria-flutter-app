import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../auth/auth_providers.dart';
import '../../../data/app_database.dart';
import '../../../theme/app_theme.dart';

class ExpenseTrackerScreen extends ConsumerWidget {
  const ExpenseTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = auth.user;
    if (user == null) {
      return const Center(child: Text('Please login to use Expense Tracker.'));
    }

    final db = ref.watch(appDatabaseProvider);

    return StreamBuilder<List<DbExpense>>(
      stream: db.watchExpenses(user.id),
      builder: (context, snap) {
        final items = snap.data ?? const [];
        final total = items.fold<double>(0, (s, e) => s + e.amount);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SummaryCard(
              title: 'This device (local DB)',
              value: '${total.toStringAsFixed(0)} PKR',
              subtitle: '${items.length} expenses saved',
              icon: Icons.payments_rounded,
              color: AriaColors.success,
            ),
            const SizedBox(height: 12),
            if (items.isEmpty)
              _EmptyState(
                title: 'No expenses yet',
                subtitle: 'Tap + to add your first expense.',
              )
            else
              ...items.map((e) => _ExpenseTile(
                    e: e,
                    onDelete: () async => db.deleteExpense(e.id, user.id),
                  )),
            const SizedBox(height: 80),
          ],
        );
      },
    );
  }
}

class _ExpenseTile extends StatelessWidget {
  final DbExpense e;
  final VoidCallback onDelete;
  const _ExpenseTile({required this.e, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd MMM, yyyy').format(e.date);
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
            color: AriaColors.successBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AriaColors.success.withOpacity(0.2)),
          ),
          child: const Icon(Icons.receipt_long_rounded, color: AriaColors.success),
        ),
        title: Text('${e.amount.toStringAsFixed(0)} ${e.currency}',
            style: AriaText.titleMedium.copyWith(fontWeight: FontWeight.w800)),
        subtitle: Text('${e.category} • $date${(e.notes ?? '').trim().isEmpty ? '' : '\n${e.notes}'}',
            style: AriaText.bodySmall),
        isThreeLine: (e.notes ?? '').trim().isNotEmpty,
        trailing: IconButton(
          tooltip: 'Delete',
          icon: const Icon(Icons.delete_outline_rounded, color: AriaColors.error),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(Rad.xl),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AriaText.bodySmall),
                  const SizedBox(height: 4),
                  Text(value, style: AriaText.headlineSmall.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AriaText.caption),
                ],
              ),
            ),
          ],
        ),
      );
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
              child: const Icon(Icons.payments_rounded, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(title, style: AriaText.titleMedium.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(subtitle, style: AriaText.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      );
}

Future<void> showAddExpenseSheet(
  BuildContext context,
  WidgetRef ref,
  AppDatabase db,
  int userId,
) async {
  final amountCtrl = TextEditingController();
  final categoryCtrl = TextEditingController(text: 'Food');
  final currencyCtrl = TextEditingController(text: 'PKR');
  final notesCtrl = TextEditingController();
  DateTime date = DateTime.now();

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
              Text('Add expense', style: AriaText.headlineSmall),
              const SizedBox(height: 12),
              _sheetField(
                label: 'Amount *',
                ctrl: amountCtrl,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              _sheetField(label: 'Category *', ctrl: categoryCtrl),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _sheetField(label: 'Currency', ctrl: currencyCtrl)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                          initialDate: date,
                        );
                        if (picked != null) setState(() => date = picked);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AriaColors.divider),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Rad.lg),
                        ),
                      ),
                      child: Text(DateFormat('dd MMM').format(date),
                          style: AriaText.titleMedium),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _sheetField(label: 'Notes', ctrl: notesCtrl, maxLines: 2),
              const SizedBox(height: 14),
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: () async {
                    final amount = double.tryParse(amountCtrl.text.trim());
                    final category = categoryCtrl.text.trim();
                    if (amount == null || amount <= 0 || category.isEmpty) return;
                    await db.addExpense(
                      userId: userId,
                      amount: amount,
                      category: category,
                      currency: currencyCtrl.text.trim().isEmpty ? 'PKR' : currencyCtrl.text.trim(),
                      date: DateTime(date.year, date.month, date.day, 12),
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

Widget _sheetField({
  required String label,
  required TextEditingController ctrl,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
}) {
  return TextField(
    controller: ctrl,
    keyboardType: keyboardType,
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

