// lib/screens/chat/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../models/aria_models.dart';
import '../../providers/providers.dart';
import '../../auth/auth_providers.dart';
import '../settings/settings_screen.dart';
import 'widgets/email_card.dart';
import 'widgets/reminder_card.dart';
import 'widgets/calendar_event_card.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});
  @override ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with TickerProviderStateMixin {
  final _inputCtrl  = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _focusNode  = FocusNode();
  bool _showChips   = true;
  bool _inputFocused= false;
  late AnimationController _fabCtrl;

  @override
  void initState() {
    super.initState();
    _fabCtrl = AnimationController(vsync: this, duration: 200.ms);
    _focusNode.addListener(() {
      setState(() {
        _inputFocused = _focusNode.hasFocus;
        if (_focusNode.hasFocus) _showChips = false;
      });
    });
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    _fabCtrl.dispose();
    super.dispose();
  }

  void _send([String? override]) {
    final text = (override ?? _inputCtrl.text).trim();
    if (text.isEmpty) return;
    _inputCtrl.clear();
    setState(() => _showChips = false);
    final rn = ref.read(reminderProvider.notifier);
    ref.read(chatProvider.notifier).send(text, reminderNotifier: rn);
    _scrollToBottom();
  }

  void _scrollToBottom({int delay = 450}) {
    Future.delayed(Duration(milliseconds: delay), () {
      if (!mounted || !_scrollCtrl.hasClients) return;
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: 350.ms, curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final chat     = ref.watch(chatProvider);
    final settings = ref.watch(settingsProvider);
    final auth     = ref.watch(authProvider);
    final userName = auth.user?.name ?? settings.userName;
    final userEmail = auth.user?.email ?? settings.userEmail;
    final initials = _initialsFromName(userName);

    ref.listen(chatProvider, (_, __) => _scrollToBottom());
    ref.listen(authProvider, (_, next) {
      if (next.user != null) {
        ref.read(settingsProvider.notifier).updateName(next.user!.name);
        ref.read(settingsProvider.notifier).updateEmail(next.user!.email);
      }
    });

    return Scaffold(
      backgroundColor: AriaColors.background,
      appBar: _buildAppBar(userEmail),
      body: Column(children: [
        // Messages
        Expanded(
          child: ListView.builder(
            controller: _scrollCtrl,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            itemCount: chat.messages.length + (_showChips ? 1 : 0),
            itemBuilder: (ctx, i) {
              final msgCount = chat.messages.length;

              // Quick chips
              if (_showChips && i == msgCount) {
                return _QuickChipsPanel(
                  onChipTap: (chip) {
                    if (chip.fillInput) {
                      _inputCtrl.text = chip.message;
                      _inputCtrl.selection = TextSelection.fromPosition(
                          TextPosition(offset: _inputCtrl.text.length));
                      _focusNode.requestFocus();
                    } else {
                      _send(chip.message);
                    }
                  },
                );
              }

              return _buildMessageItem(chat.messages[i], initials, i);
            },
          ),
        ),

        // Input area
        _ChatInputBar(
          ctrl: _inputCtrl,
          focusNode: _focusNode,
          isTyping: chat.isTyping,
          isFocused: _inputFocused,
          onSend: _send,
        ),
      ]),
    );
  }

  Widget _buildMessageItem(ChatMessage msg, String initials, int idx) {
    if (msg.isLoading) return const _TypingIndicator();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: msg.isUser
          ? _UserMessage(msg: msg, initials: initials)
          : _ARIAMessage(
        msg: msg,
        onEmailReply:     (e)  => _send('Draft a reply to: ${e.subject}'),
        onEmailOpen:      (e)  => _snack('Opening Gmail for: ${e.subject}'),
        onReminderDone:   (r)  => ref.read(reminderProvider.notifier).markDone(r.id),
        onReminderUndo:   (r)  => ref.read(reminderProvider.notifier).markUndone(r.id),
        onReminderDelete: (r)  => ref.read(reminderProvider.notifier).delete(r.id),
        onJoinMeeting:    (ev) => _snack('Opening Meet: ${ev.title}'),
      ),
    );
  }

  AppBar _buildAppBar(String userEmail) => AppBar(
    automaticallyImplyLeading: false,
    titleSpacing: 16,
    title: Row(children: [
      // Avatar with gradient
      Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          gradient: AriaColors.primaryGradient,
          borderRadius: BorderRadius.circular(11),
          boxShadow: AriaShadow.button,
        ),
        child: const Center(child: Text('A', style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22))),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('ARIA', style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.w800,
              color: AriaColors.textPrimary, letterSpacing: 1.5)),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 7, height: 7, margin: const EdgeInsets.only(right: 5),
                decoration: const BoxDecoration(
                    color: AriaColors.success, shape: BoxShape.circle)),
            Flexible(
              child: Text(
                userEmail.isEmpty ? 'Online • Groq AI' : userEmail,
                overflow: TextOverflow.ellipsis,
                style: AriaText.bodySmall.copyWith(
                  color: AriaColors.success,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ]),
        ]),
      ),
    ]),
    actions: [
      // Clear chat
      IconButton(
        icon: const Icon(Icons.refresh_rounded, size: 20),
        tooltip: 'Clear chat',
        onPressed: () => _showClearDialog(),
      ),
      // Settings
      IconButton(
        icon: const Icon(Icons.person_rounded, size: 22),
        tooltip: 'Settings',
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const SettingsScreen())),
      ),
      const SizedBox(width: 4),
    ],
    bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AriaColors.divider)),
  );

  Future<void> _showClearDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear Chat', style: AriaText.headlineMedium),
        content: Text('Delete all messages and start fresh?', style: AriaText.bodyMedium),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: AriaColors.error),
              child: const Text('Clear')),
        ],
      ),
    );
    if (confirmed == true) {
      ref.read(chatProvider.notifier).clear();
      setState(() => _showChips = true);
    }
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: 2.seconds,
          margin: const EdgeInsets.all(16)));
}

// ─────────────────────────────────────────────────────────────────────────
//  USER MESSAGE BUBBLE
// ─────────────────────────────────────────────────────────────────────────
class _UserMessage extends StatelessWidget {
  final ChatMessage msg;
  final String initials;
  const _UserMessage({required this.msg, required this.initials});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Flexible(
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
            decoration: BoxDecoration(
              gradient: AriaColors.primaryGradient,
              borderRadius: const BorderRadius.only(
                topLeft:     Radius.circular(20),
                topRight:    Radius.circular(20),
                bottomLeft:  Radius.circular(20),
                bottomRight: Radius.circular(5),
              ),
              boxShadow: AriaShadow.button,
            ),
            child: Text(msg.content,
                style: AriaText.bodyMedium.copyWith(color: Colors.white, height: 1.55)),
          ),
          const SizedBox(height: 5),
          Text(msg.timeLabel, style: AriaText.bodySmall),
        ]),
      ),
      const SizedBox(width: 10),
      Container(
        width: 34, height: 34,
        decoration: BoxDecoration(
          gradient: AriaColors.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: AriaShadow.button,
        ),
        child: Center(child: Text(initials, style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13))),
      ),
    ],
  ).animate().fadeIn(duration: 250.ms).slideX(begin: 0.15, duration: 300.ms);
}

String _initialsFromName(String userName) {
  final parts = userName.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return 'U';
  if (parts.length == 1) return parts.first[0].toUpperCase();
  return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
}

// ─────────────────────────────────────────────────────────────────────────
//  ARIA MESSAGE BUBBLE
// ─────────────────────────────────────────────────────────────────────────
class _ARIAMessage extends StatelessWidget {
  final ChatMessage msg;
  final void Function(EmailModel)    onEmailReply;
  final void Function(EmailModel)    onEmailOpen;
  final void Function(ReminderModel) onReminderDone;
  final void Function(ReminderModel) onReminderUndo;
  final void Function(ReminderModel) onReminderDelete;
  final void Function(CalendarEvent) onJoinMeeting;

  const _ARIAMessage({
    required this.msg,
    required this.onEmailReply, required this.onEmailOpen,
    required this.onReminderDone, required this.onReminderUndo,
    required this.onReminderDelete, required this.onJoinMeeting,
  });

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // ARIA Avatar
      Container(
        width: 34, height: 34,
        decoration: BoxDecoration(
          gradient: AriaColors.primaryGradient,
          borderRadius: BorderRadius.circular(9),
          boxShadow: AriaShadow.button,
        ),
        child: const Center(child: Text('A', style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18))),
      ),
      const SizedBox(width: 10),

      Flexible(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Text bubble
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.78),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
            decoration: BoxDecoration(
              color: msg.isError ? AriaColors.errorBg : AriaColors.ariaMessage,
              borderRadius: const BorderRadius.only(
                topLeft:     Radius.circular(5),
                topRight:    Radius.circular(20),
                bottomLeft:  Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(
                  color: msg.isError ? AriaColors.errorBorder : AriaColors.divider),
              boxShadow: AriaShadow.subtle,
            ),
            child: _buildTextContent(),
          ),

          // Structured data
          if (msg.emails != null && msg.emails!.isNotEmpty)
            Padding(padding: const EdgeInsets.only(top: 12),
                child: EmailListWidget(
                    emails: msg.emails!,
                    onReply: onEmailReply, onOpen: onEmailOpen)),

          if (msg.reminders != null)
            Padding(padding: const EdgeInsets.only(top: 12),
                child: ReminderListWidget(
                    reminders: msg.reminders!,
                    onDone: onReminderDone, onUndo: onReminderUndo,
                    onDelete: onReminderDelete)),

          if (msg.events != null && msg.events!.isNotEmpty)
            Padding(padding: const EdgeInsets.only(top: 12),
                child: CalendarListWidget(
                    events: msg.events!, onJoin: onJoinMeeting)),

          const SizedBox(height: 5),
          Text(msg.timeLabel, style: AriaText.bodySmall),
        ]),
      ),
    ],
  ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1, duration: 350.ms);

  Widget _buildTextContent() {
    if (msg.content.isEmpty) return const SizedBox.shrink();

    // Render **bold** text
    final parts = msg.content.split('**');
    if (parts.length <= 1) {
      return Text(msg.content, style: AriaText.bodyMedium.copyWith(
          color: msg.isError ? AriaColors.error : AriaColors.textPrimary, height: 1.6));
    }
    return RichText(
      text: TextSpan(
        style: AriaText.bodyMedium.copyWith(
            color: AriaColors.textPrimary, height: 1.6),
        children: parts.asMap().entries.map((e) => TextSpan(
          text: e.value,
          style: TextStyle(
            fontWeight: e.key.isOdd ? FontWeight.w700 : FontWeight.w400,
            color: e.key.isOdd ? AriaColors.textPrimary : null,
          ),
        )).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
//  TYPING INDICATOR
// ─────────────────────────────────────────────────────────────────────────
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();
  @override State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: 1200.ms)..repeat();
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
        width: 34, height: 34,
        decoration: BoxDecoration(
          gradient: AriaColors.primaryGradient,
          borderRadius: BorderRadius.circular(9),
          boxShadow: AriaShadow.button,
        ),
        child: const Center(child: Text('A', style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18))),
      ),
      const SizedBox(width: 10),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: AriaColors.ariaMessage,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
          border: Border.all(color: AriaColors.divider),
          boxShadow: AriaShadow.subtle,
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          ...List.generate(3, (i) => AnimatedBuilder(
            animation: _c,
            builder: (_, __) {
              final phase = (_c.value - i * 0.18).clamp(0.0, 1.0);
              final t     = phase < 0.5 ? phase * 2 : (1 - phase) * 2;
              final scale = 1.0 + 0.5 * t;
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 8, height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                      color: AriaColors.primary.withOpacity(0.5 + t * 0.5),
                      shape: BoxShape.circle),
                ),
              );
            },
          )),
          const SizedBox(width: 6),
          Text('ARIA is thinking...', style: AriaText.bodySmall.copyWith(
              color: AriaColors.textHint, fontStyle: FontStyle.italic)),
        ]),
      ),
    ]),
  ).animate().fadeIn(duration: 250.ms);
}

// ─────────────────────────────────────────────────────────────────────────
//  QUICK CHIPS
// ─────────────────────────────────────────────────────────────────────────
class _QuickChipsPanel extends StatelessWidget {
  final void Function(QuickChip) onChipTap;
  const _QuickChipsPanel({required this.onChipTap});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 6, bottom: 20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(children: [
          Container(width: 4, height: 16, margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                  gradient: AriaColors.primaryGradient,
                  borderRadius: BorderRadius.circular(2))),
          Text('What would you like to do?',
              style: AriaText.bodySmall.copyWith(
                  color: AriaColors.textHint, fontWeight: FontWeight.w500)),
        ]),
      ),
      Wrap(
        spacing: 9, runSpacing: 9,
        children: QuickChip.all.asMap().entries.map((entry) =>
            GestureDetector(
              onTap: () => onChipTap(entry.value),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AriaColors.surface,
                  borderRadius: BorderRadius.circular(Rad.full),
                  border: Border.all(color: AriaColors.divider),
                  boxShadow: AriaShadow.subtle,
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(entry.value.emoji, style: const TextStyle(fontSize: 15)),
                  const SizedBox(width: 7),
                  Text(entry.value.label,
                      style: AriaText.labelMedium.copyWith(color: AriaColors.textPrimary)),
                  if (entry.value.fillInput) ...[
                    const SizedBox(width: 4),
                    Icon(Icons.edit_rounded, size: 10, color: AriaColors.textHint),
                  ],
                ]),
              )
                  .animate(delay: Duration(milliseconds: entry.key * 55))
                  .fadeIn(duration: 300.ms)
                  .scale(begin: const Offset(0.82, 0.82), duration: 350.ms,
                  curve: Curves.easeOutBack),
            ),
        ).toList(),
      ),
    ]),
  );
}

// ─────────────────────────────────────────────────────────────────────────
//  INPUT BAR
// ─────────────────────────────────────────────────────────────────────────
class _ChatInputBar extends StatelessWidget {
  final TextEditingController ctrl;
  final FocusNode focusNode;
  final bool isTyping, isFocused;
  final void Function([String?]) onSend;

  const _ChatInputBar({
    required this.ctrl, required this.focusNode,
    required this.isTyping, required this.isFocused, required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return AnimatedContainer(
      duration: 200.ms,
      decoration: BoxDecoration(
        color: AriaColors.surface,
        border: Border(top: BorderSide(
          color: isFocused ? AriaColors.primary.withOpacity(0.3) : AriaColors.divider,
          width: isFocused ? 1.5 : 1,
        )),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16, offset: const Offset(0, -6)),
        ],
      ),
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottom + 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        // Text field
        Expanded(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 130),
            child: TextField(
              controller: ctrl,
              focusNode: focusNode,
              enabled: !isTyping,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              maxLines: null,
              style: AriaText.bodyMedium.copyWith(color: AriaColors.textPrimary),
              decoration: InputDecoration(
                hintText: isTyping ? 'ARIA is thinking...' : 'Ask ARIA anything...',
                hintStyle: AriaText.bodyMedium.copyWith(color: AriaColors.textHint),
                filled: true,
                fillColor: isFocused ? AriaColors.primarySurface : AriaColors.inputFill,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Rad.full),
                    borderSide: const BorderSide(color: AriaColors.divider)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Rad.full),
                    borderSide: const BorderSide(color: AriaColors.divider)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Rad.full),
                    borderSide: const BorderSide(
                        color: AriaColors.primary, width: 1.8)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),

        // Send button
        GestureDetector(
          onTap: isTyping ? null : () => onSend(),
          child: AnimatedContainer(
            duration: 200.ms,
            width: 50, height: 50,
            decoration: BoxDecoration(
              gradient: isTyping
                  ? null
                  : AriaColors.primaryGradient,
              color: isTyping ? AriaColors.divider : null,
              shape: BoxShape.circle,
              boxShadow: isTyping ? null : AriaShadow.fab,
            ),
            child: isTyping
                ? const Padding(padding: EdgeInsets.all(13),
                child: CircularProgressIndicator(
                    color: AriaColors.textHint, strokeWidth: 2.5))
                : const Icon(Icons.send_rounded, color: Colors.white, size: 22),
          ),
        ),
      ]),
    );
  }
}
