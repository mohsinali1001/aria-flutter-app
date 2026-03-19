// lib/screens/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../models/aria_models.dart';
import '../../providers/providers.dart';
import '../../auth/auth_providers.dart';
import '../auth/auth_gate.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  bool _editingName  = false;
  bool _editingEmail = false;

  @override
  void initState() {
    super.initState();
    final auth = ref.read(authProvider);
    final s = ref.read(settingsProvider);
    _nameCtrl = TextEditingController(text: auth.user?.name ?? s.userName);
    _emailCtrl = TextEditingController(text: auth.user?.email ?? s.userEmail);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final s     = ref.read(settingsProvider);
    final parts = s.morningBriefTime.split(':');
    final time  = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour:   int.parse(parts[0]),
        minute: int.parse(parts[1]),
      ),
      builder: (ctx, child) => Theme(
          data: Theme.of(ctx).copyWith(
              colorScheme: const ColorScheme.light(primary: AriaColors.primary)),
          child: child!),
    );
    if (time != null) {
      final t = '${time.hour.toString().padLeft(2,'0')}:${time.minute.toString().padLeft(2,'0')}';
      ref.read(settingsProvider.notifier).setBriefTime(t);
      _snack('Morning brief time updated to $t');
    }
  }

  Future<void> _clearChat() async {
    final ok = await _confirmDialog(
      'Clear Chat History',
      'This will delete all your chat messages. You\'ll start fresh.',
      'Clear History',
    );
    if (!ok) return;
    ref.read(chatProvider.notifier).clear();
    _snack('Chat history cleared ✓');
  }

  Future<void> _clearReminders() async {
    final ok = await _confirmDialog(
      'Delete All Reminders',
      'This will permanently delete all your reminders.',
      'Delete All',
      destructive: true,
    );
    if (!ok) return;
    ref.read(reminderProvider.notifier).deleteAll();
    _snack('All reminders deleted');
  }

  Future<void> _clearDoneReminders() async {
    ref.read(reminderProvider.notifier).deleteAllDone();
    _snack('Completed reminders cleared');
  }

  Future<bool> _confirmDialog(String title, String content, String btnLabel,
      {bool destructive = false}) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Rad.xl)),
        title: Text(title, style: AriaText.headlineMedium),
        content: Text(content, style: AriaText.bodyMedium),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(
                  foregroundColor: destructive ? AriaColors.error : AriaColors.primary),
              child: Text(btnLabel)),
        ],
      ),
    );
    return result ?? false;
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(msg),
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Rad.md))));

  @override
  Widget build(BuildContext context) {
    final s         = ref.watch(settingsProvider);
    final auth      = ref.watch(authProvider);
    final reminders = ref.watch(reminderProvider);
    final chat      = ref.watch(chatProvider);
    final pending   = reminders.where((r) => !r.isDone).length;
    final done      = reminders.where((r) => r.isDone).length;

    return Scaffold(
      backgroundColor: AriaColors.background,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            onPressed: () => Navigator.pop(context)),
        title: const Text('Settings'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: AriaColors.primarySurface,
                borderRadius: BorderRadius.circular(Rad.full),
                border: Border.all(color: AriaColors.primaryBorder)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 6, height: 6,
                  margin: const EdgeInsets.only(right: 5),
                  decoration: const BoxDecoration(
                      color: AriaColors.success, shape: BoxShape.circle)),
              Text('v1.0.0', style: AriaText.labelSmall.copyWith(
                  color: AriaColors.primary, fontWeight: FontWeight.w600)),
            ]),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          // ── Profile ───────────────────────────────────────────
          SectionHeader('Profile'),
          _ProfileCard(
            settings: s,
            userName: auth.user?.name ?? s.userName,
            userEmail: auth.user?.email ?? s.userEmail,
            nameCtrl: _nameCtrl,
            emailCtrl: _emailCtrl,
            editingName: _editingName, editingEmail: _editingEmail,
            onToggleName:  () => setState(() => _editingName = !_editingName),
            onToggleEmail: () => setState(() => _editingEmail = !_editingEmail),
            onSaveName: () async {
              final ok = await ref.read(authProvider.notifier).updateProfile(
                name: _nameCtrl.text,
                email: _emailCtrl.text,
              );
              if (!mounted) return;
              if (ok) {
                ref.read(settingsProvider.notifier).updateName(_nameCtrl.text);
                setState(() => _editingName = false);
                _snack('Name updated!');
              } else {
                _snack('Could not update profile');
              }
            },
            onSaveEmail: () async {
              final ok = await ref.read(authProvider.notifier).updateProfile(
                name: _nameCtrl.text,
                email: _emailCtrl.text,
              );
              if (!mounted) return;
              if (ok) {
                ref.read(settingsProvider.notifier).updateEmail(_emailCtrl.text);
                setState(() => _editingEmail = false);
                _snack('Email updated!');
              } else {
                _snack('Could not update profile');
              }
            },
          ).animate().fadeIn(delay: const Duration(milliseconds: 100))
              .slideY(begin: 0.1, delay: const Duration(milliseconds: 100)),

          const SizedBox(height: 28),

          // ── Stats ─────────────────────────────────────────────
          SectionHeader('Usage Stats'),
          _StatsGrid(
            messages: chat.messages.length,
            pending: pending, done: done, emails: 5,
          ).animate().fadeIn(delay: const Duration(milliseconds: 150)),

          const SizedBox(height: 28),

          // ── AI Integration ────────────────────────────────────
          SectionHeader('AI Integration'),
          SettingsCard(children: [
            _InfoTile(
                icon: Icons.bolt_rounded, iconColor: const Color(0xFF9B59B6),
                title: 'AI Model', subtitle: 'llama3-70b-8192 via Groq',
                trailing: StatusBadge('Active',
                    color: AriaColors.success, bgColor: AriaColors.successBg)),
            const Divider(height: 1),
            _InfoTile(
                icon: Icons.api_rounded, iconColor: AriaColors.secondary,
                title: 'API Status', subtitle: 'Connected to Groq API',
                trailing: StatusBadge('Live',
                    color: AriaColors.secondary, bgColor: AriaColors.secondarySurface)),
            const Divider(height: 1),
            _InfoTile(
                icon: Icons.speed_rounded, iconColor: AriaColors.success,
                title: 'Response Speed', subtitle: 'Sub-second AI responses',
                trailing: StatusBadge('Fast',
                    color: AriaColors.success, bgColor: AriaColors.successBg)),
          ]).animate().fadeIn(delay: const Duration(milliseconds: 200)),

          const SizedBox(height: 28),

          // ── Notifications ─────────────────────────────────────
          SectionHeader('Notifications'),
          SettingsCard(children: [
            _SwitchTile(
              icon: Icons.notifications_rounded, iconColor: AriaColors.primary,
              title: 'Push Notifications',
              subtitle: 'Reminder alerts & morning brief',
              value: s.notificationsEnabled,
              onChanged: ref.read(settingsProvider.notifier).toggleNotifications,
            ),
            const Divider(height: 1),
            _SwitchTile(
              icon: Icons.wb_sunny_rounded, iconColor: AriaColors.warning,
              title: 'Morning Brief',
              subtitle: 'Daily AI summary notification',
              value: s.morningBriefEnabled,
              onChanged: ref.read(settingsProvider.notifier).toggleMorningBrief,
            ),
            const Divider(height: 1),
            _TapTile(
              icon: Icons.alarm_rounded, iconColor: AriaColors.secondary,
              title: 'Brief Time', subtitle: 'Receive daily summary at',
              onTap: _pickTime,
              trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      gradient: AriaColors.primaryGradient,
                      borderRadius: BorderRadius.circular(Rad.sm)),
                  child: Text(s.morningBriefTime,
                      style: AriaText.labelLarge.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w700))),
            ),
          ]).animate().fadeIn(delay: const Duration(milliseconds: 250)),

          const SizedBox(height: 28),

          // ── Data Management ───────────────────────────────────
          SectionHeader('Data Management'),
          SettingsCard(children: [
            _TapTile(
              icon: Icons.chat_bubble_outline_rounded, iconColor: AriaColors.warning,
              title: 'Clear Chat History',
              subtitle: '${chat.messages.length} messages',
              onTap: _clearChat,
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                StatusBadge('${chat.messages.length}',
                    color: AriaColors.warning, bgColor: AriaColors.warningBg),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right_rounded, size: 18, color: AriaColors.textHint),
              ]),
            ),
            const Divider(height: 1),
            _TapTile(
              icon: Icons.check_circle_outline_rounded, iconColor: AriaColors.success,
              title: 'Clear Completed Reminders',
              subtitle: '$done completed reminders',
              onTap: _clearDoneReminders,
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                StatusBadge('$done',
                    color: AriaColors.success, bgColor: AriaColors.successBg),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right_rounded, size: 18, color: AriaColors.textHint),
              ]),
            ),
            const Divider(height: 1),
            _TapTile(
              icon: Icons.delete_sweep_rounded, iconColor: AriaColors.error,
              title: 'Delete All Reminders',
              subtitle: '$pending pending reminders',
              onTap: _clearReminders,
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                StatusBadge('$pending',
                    color: AriaColors.error, bgColor: AriaColors.errorBg),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right_rounded, size: 18, color: AriaColors.textHint),
              ]),
            ),
          ]).animate().fadeIn(delay: const Duration(milliseconds: 300)),

          const SizedBox(height: 28),

          // ── About ─────────────────────────────────────────────
          SectionHeader('About ARIA'),
          SettingsCard(children: [
            _InfoTile(icon: Icons.info_outline_rounded, iconColor: AriaColors.secondary,
                title: 'Version', subtitle: 'ARIA v1.0.0 Beta'),
            const Divider(height: 1),
            _InfoTile(icon: Icons.storage_rounded, iconColor: AriaColors.primary,
                title: 'Storage', subtitle: 'In-memory state (Riverpod)'),
            const Divider(height: 1),
            _InfoTile(icon: Icons.bolt_rounded, iconColor: const Color(0xFF9B59B6),
                title: 'AI Engine', subtitle: 'Groq — llama3-70b-8192'),
            const Divider(height: 1),
            _InfoTile(icon: Icons.people_rounded, iconColor: AriaColors.textSecondary,
                title: 'Team', subtitle: 'Mohsin + Huzaifa + Junaid + Abdullah'),
            const Divider(height: 1),
            _InfoTile(icon: Icons.attach_money_rounded, iconColor: AriaColors.success,
                title: 'Cost', subtitle: '\$0/month — completely free'),
          ]).animate().fadeIn(delay: const Duration(milliseconds: 350)),

          const SizedBox(height: 40),

          // ── Logout ────────────────────────────────────────────
          if (auth.isAuthenticated)
            SettingsCard(children: [
              _TapTile(
                icon: Icons.logout_rounded,
                iconColor: AriaColors.error,
                title: 'Logout',
                subtitle: 'Sign out from this device',
                onTap: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const AuthGate()),
                    (_) => false,
                  );
                },
              ),
            ]).animate().fadeIn(delay: const Duration(milliseconds: 370)),

          // ── Footer ────────────────────────────────────────────
          Center(
            child: Column(children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                    gradient: AriaColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: AriaShadow.button),
                child: const Center(child: Text('A', style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w900, fontSize: 28))),
              ),
              const SizedBox(height: 12),
              Text('ARIA', style: AriaText.headlineMedium.copyWith(
                  letterSpacing: 3, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text('AI Personal Secretary',
                  style: AriaText.bodySmall.copyWith(color: AriaColors.textHint)),
              const SizedBox(height: 4),
              Text('Made with ❤️  —  4 Weeks, 4 Developers, Zero Cost',
                  style: AriaText.caption, textAlign: TextAlign.center),
            ]),
          ).animate().fadeIn(delay: const Duration(milliseconds: 400)),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// ── Profile Card ─────────────────────────────────────────────────────────
class _ProfileCard extends StatelessWidget {
  final AppSettings settings;
  final String userName;
  final String userEmail;
  final TextEditingController nameCtrl, emailCtrl;
  final bool editingName, editingEmail;
  final VoidCallback onToggleName, onToggleEmail, onSaveName, onSaveEmail;

  const _ProfileCard({
    required this.settings, required this.nameCtrl, required this.emailCtrl,
    required this.userName, required this.userEmail,
    required this.editingName, required this.editingEmail,
    required this.onToggleName, required this.onToggleEmail,
    required this.onSaveName, required this.onSaveEmail,
  });

  @override
  Widget build(BuildContext context) => SettingsCard(children: [
    Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [AriaColors.primarySurface, AriaColors.secondarySurface],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(Rad.xl))),
      child: Row(children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
              gradient: AriaColors.primaryGradient,
              shape: BoxShape.circle, boxShadow: AriaShadow.fab),
          child: Center(child: Text(settings.initials,
              style: const TextStyle(color: Colors.white,
                  fontWeight: FontWeight.w800, fontSize: 24))),
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(userName,
              style: AriaText.headlineSmall.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(userEmail, style: AriaText.bodySmall),
          const SizedBox(height: 8),
          StatusBadge('Pro User 🌟',
              color: AriaColors.primary, bgColor: Colors.white.withOpacity(0.8)),
        ])),
      ]),
    ),
    _EditableTile(
      icon: Icons.person_rounded, iconColor: AriaColors.primary,
      label: 'Display Name', ctrl: nameCtrl, editing: editingName,
      onEdit: onToggleName, onSave: onSaveName,
    ),
    const Divider(height: 1),
    _EditableTile(
      icon: Icons.email_rounded, iconColor: AriaColors.secondary,
      label: 'Email Address', ctrl: emailCtrl, editing: editingEmail,
      keyboardType: TextInputType.emailAddress,
      onEdit: onToggleEmail, onSave: onSaveEmail,
    ),
  ]);
}

class _EditableTile extends StatelessWidget {
  final IconData icon; final Color iconColor;
  final String label;
  final TextEditingController ctrl;
  final bool editing;
  final TextInputType keyboardType;
  final VoidCallback onEdit, onSave;

  const _EditableTile({
    required this.icon, required this.iconColor, required this.label,
    required this.ctrl, required this.editing,
    this.keyboardType = TextInputType.text,
    required this.onEdit, required this.onSave,
  });

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(9)),
        child: Icon(icon, size: 18, color: iconColor)),
    title: Text(label, style: AriaText.bodySmall.copyWith(color: AriaColors.textHint)),
    subtitle: editing
        ? TextField(
        controller: ctrl, autofocus: true,
        keyboardType: keyboardType,
        style: AriaText.titleMedium,
        decoration: const InputDecoration(
            isDense: true, contentPadding: EdgeInsets.zero,
            border: InputBorder.none, filled: false),
        onSubmitted: (_) => onSave())
        : Text(ctrl.text.isEmpty ? 'Tap to set' : ctrl.text,
        style: AriaText.titleMedium),
    trailing: GestureDetector(
      onTap: editing ? onSave : onEdit,
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
            color: editing ? AriaColors.primarySurface : AriaColors.inputFill,
            borderRadius: BorderRadius.circular(Rad.sm)),
        child: Icon(
            editing ? Icons.check_rounded : Icons.edit_rounded,
            size: 15,
            color: editing ? AriaColors.primary : AriaColors.textHint),
      ),
    ),
  );
}

// ── Stats Grid ────────────────────────────────────────────────────────────
class _StatsGrid extends StatelessWidget {
  final int messages, pending, done, emails;
  const _StatsGrid({required this.messages, required this.pending,
    required this.done, required this.emails});

  @override
  Widget build(BuildContext context) => GridView.count(
    crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12,
    shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
    childAspectRatio: 2.2,
    children: [
      _StatCard('Chat Messages', '$messages', Icons.chat_bubble_rounded, AriaColors.secondary),
      _StatCard('Pending Tasks', '$pending', Icons.notifications_rounded, AriaColors.primary),
      _StatCard('Completed', '$done', Icons.check_circle_rounded, AriaColors.success),
      _StatCard('Emails', '$emails', Icons.email_rounded, const Color(0xFF6B7FD7)),
    ],
  );
}

class _StatCard extends StatelessWidget {
  final String label, value; final IconData icon; final Color color;
  const _StatCard(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(Rad.lg),
        border: Border.all(color: color.withOpacity(0.2))),
    child: Row(children: [
      Container(width: 38, height: 38,
          decoration: BoxDecoration(
              color: color.withOpacity(0.12), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 18)),
      const SizedBox(width: 10),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: AriaText.headlineLarge.copyWith(
              color: color, fontWeight: FontWeight.w800)),
          Text(label, style: AriaText.bodySmall.copyWith(fontSize: 10),
              overflow: TextOverflow.ellipsis),
        ],
      )),
    ]),
  );
}

// ── Tile Components ───────────────────────────────────────────────────────
class _SwitchTile extends StatelessWidget {
  final IconData icon; final Color iconColor;
  final String title, subtitle;
  final bool value;
  final void Function(bool) onChanged;
  const _SwitchTile({required this.icon, required this.iconColor,
    required this.title, required this.subtitle,
    required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => ListTile(
    leading: _IconBox(icon, iconColor),
    title: Text(title, style: AriaText.titleMedium),
    subtitle: Text(subtitle, style: AriaText.bodySmall),
    trailing: Switch(value: value, onChanged: onChanged),
  );
}

class _TapTile extends StatelessWidget {
  final IconData icon; final Color iconColor;
  final String title, subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _TapTile({required this.icon, required this.iconColor,
    required this.title, required this.subtitle, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    leading: _IconBox(icon, iconColor),
    title: Text(title, style: AriaText.titleMedium),
    subtitle: Text(subtitle, style: AriaText.bodySmall),
    trailing: trailing ?? const Icon(Icons.chevron_right_rounded,
        size: 18, color: AriaColors.textHint),
  );
}

class _InfoTile extends StatelessWidget {
  final IconData icon; final Color iconColor;
  final String title, subtitle;
  final Widget? trailing;
  const _InfoTile({required this.icon, required this.iconColor,
    required this.title, required this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) => ListTile(
    leading: _IconBox(icon, iconColor),
    title: Text(title, style: AriaText.titleMedium),
    subtitle: Text(subtitle, style: AriaText.bodySmall),
    trailing: trailing,
  );
}

class _IconBox extends StatelessWidget {
  final IconData icon; final Color color;
  const _IconBox(this.icon, this.color);
  @override Widget build(BuildContext context) => Container(
    width: 36, height: 36,
    decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: color.withOpacity(0.2))),
    child: Icon(icon, size: 18, color: color),
  );
}