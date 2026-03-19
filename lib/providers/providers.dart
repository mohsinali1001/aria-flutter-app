// lib/providers/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/aria_models.dart';
import '../services/grok_service.dart';

const _uuid = Uuid();

// ── Settings Provider ──────────────────────────────────────────────
class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings());
  void updateName(String n)        => state = state.copyWith(userName: n.trim().isEmpty ? 'User' : n.trim());
  void updateEmail(String e)       => state = state.copyWith(userEmail: e.trim());
  void toggleNotifications(bool v) => state = state.copyWith(notificationsEnabled: v);
  void toggleMorningBrief(bool v)  => state = state.copyWith(morningBriefEnabled: v);
  void setBriefTime(String t)      => state = state.copyWith(morningBriefTime: t);
  void toggleDarkMode(bool v)      => state = state.copyWith(isDarkMode: v);
  void toggleCompactMode(bool v)   => state = state.copyWith(compactMode: v);
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(
        (_) => SettingsNotifier());

// ── Reminder Provider ──────────────────────────────────────────────
class ReminderNotifier extends StateNotifier<List<ReminderModel>> {
  ReminderNotifier() : super(ReminderModel.samples);

  List<ReminderModel> get pending      => state.where((r) => !r.isDone).toList();
  List<ReminderModel> get overdue      => state.where((r) => r.isOverdue).toList();
  List<ReminderModel> get done         => state.where((r) => r.isDone).toList();
  List<ReminderModel> get today        => state.where((r) => r.isToday && !r.isDone).toList();
  int get pendingCount => pending.length;
  int get overdueCount => overdue.length;

  ReminderModel add({
    required String title, String? note,
    required DateTime remindAt, ReminderRepeat repeat = ReminderRepeat.none,
  }) {
    final r = ReminderModel(
      id: _uuid.v4(), title: title.trim(), note: note?.trim(),
      remindAt: remindAt, createdAt: DateTime.now(), repeat: repeat,
    );
    state = [...state, r]..sort((a, b) => a.remindAt.compareTo(b.remindAt));
    return r;
  }

  void markDone(String id)   => state = state.map((r) => r.id == id ? r.copyWith(isDone: true)  : r).toList();
  void markUndone(String id) => state = state.map((r) => r.id == id ? r.copyWith(isDone: false) : r).toList();
  void delete(String id)     => state = state.where((r) => r.id != id).toList();
  void deleteAll()           => state = [];
  void deleteAllDone()       => state = state.where((r) => !r.isDone).toList();
}

final reminderProvider = StateNotifierProvider<ReminderNotifier, List<ReminderModel>>(
        (_) => ReminderNotifier());

// ── Chat Provider ──────────────────────────────────────────────────
class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(ChatState(messages: [
    ChatMessage(
      id: 'welcome', isUser: false, sentAt: DateTime.now(),
      content: 'Hello! 👋 I\'m ARIA, your AI personal secretary.\n\n'
          'I can help you with:\n'
          '✉️ Email summaries & replies\n'
          '🔔 Setting & viewing reminders\n'
          '📅 Calendar & meetings\n'
          '📊 Daily briefings\n\n'
          'Just type naturally — what would you like to do?',
    ),
  ]));

  final _grok = GrokService.instance;
  final List<Map<String, String>> _history = [];

  Future<void> send(String text, {required ReminderNotifier reminderNotifier}) async {
    if (text.trim().isEmpty || state.isTyping) return;

    final userMsg = ChatMessage(id: _uuid.v4(), content: text,
        isUser: true, sentAt: DateTime.now());
    final loading = ChatMessage(id: 'loading', content: '',
        isUser: false, sentAt: DateTime.now(), isLoading: true);

    state = state.copyWith(
      messages: [...state.messages, userMsg, loading],
      isTyping: true,
    );

    _history.add({'role': 'user', 'content': text});

    try {
      final intent = _grok.detectIntent(text);
      ChatMessage ariaMsg;

      switch (intent) {
        case ChatIntent.emailSummary:
          final aiText = await _grok.chat(text, history: _history);
          ariaMsg = ChatMessage(
            id: _uuid.v4(), content: aiText, isUser: false,
            sentAt: DateTime.now(), type: MessageType.emailList,
            emails: EmailModel.samples,
          );
          break;

        case ChatIntent.setReminder:
          final parsed = _grok.parseReminder(text);
          String aiText;
          List<ReminderModel>? createdReminders;
          if (parsed != null) {
            final r = reminderNotifier.add(title: parsed.title, remindAt: parsed.remindAt);
            createdReminders = [r];
            aiText = await _grok.chat(
              'I just set a reminder: "${parsed.title}" for ${r.fullDateLabel}. Confirm briefly.',
              history: _history,
            );
          } else {
            aiText = 'I couldn\'t parse the reminder. Try: "Remind me tomorrow at 3pm about client call"';
          }
          ariaMsg = ChatMessage(
            id: _uuid.v4(), content: aiText, isUser: false,
            sentAt: DateTime.now(), type: MessageType.action,
            reminders: createdReminders,
          );
          break;

        case ChatIntent.viewReminders:
          final all = reminderNotifier.state;
          final aiText = await _grok.chat(
            'User wants reminders. They have ${all.length} total, ${reminderNotifier.pendingCount} pending, ${reminderNotifier.overdueCount} overdue.',
            history: _history,
          );
          ariaMsg = ChatMessage(
            id: _uuid.v4(), content: aiText, isUser: false,
            sentAt: DateTime.now(), type: MessageType.reminderList,
            reminders: all,
          );
          break;

        case ChatIntent.dayBrief:
          final briefText = await _grok.generateDayBrief(
            pendingReminders: reminderNotifier.pendingCount,
            overdueReminders: reminderNotifier.overdueCount,
            urgentEmails: EmailModel.samples.where((e) => e.priority == EmailPriority.urgent).length,
            meetings: CalendarEvent.samples.length,
            nextMeeting: CalendarEvent.samples.isNotEmpty ? CalendarEvent.samples.first.title : '',
          );
          ariaMsg = ChatMessage(
            id: _uuid.v4(), content: briefText, isUser: false,
            sentAt: DateTime.now(), type: MessageType.dayBrief,
            emails: EmailModel.samples.take(2).toList(),
            events: CalendarEvent.samples,
          );
          break;

        case ChatIntent.calendarView:
          final aiText = await _grok.chat(text, history: _history);
          ariaMsg = ChatMessage(
            id: _uuid.v4(), content: aiText, isUser: false,
            sentAt: DateTime.now(), type: MessageType.calendarList,
            events: CalendarEvent.samples,
          );
          break;

        case ChatIntent.draftReply:
          final targetEmail = EmailModel.samples.first;
          final draft = await _grok.draftReply(targetEmail);
          ariaMsg = ChatMessage(
            id: _uuid.v4(),
            content: '✍️ Here\'s a draft reply to **${targetEmail.subject}**:\n\n$draft',
            isUser: false, sentAt: DateTime.now(), type: MessageType.action,
          );
          break;

        case ChatIntent.help:
          ariaMsg = ChatMessage(
            id: _uuid.v4(),
            content: '🤖 **ARIA — What I Can Do**\n\n'
                '✉️ **Email**\n'
                '  • "Show my emails" — top 5 important\n'
                '  • "Draft a reply to my latest email"\n'
                '  • "Search emails about budget"\n\n'
                '🔔 **Reminders**\n'
                '  • "Remind me tomorrow at 3pm about client call"\n'
                '  • "Show all my reminders"\n'
                '  • "Remind me Friday at 9am"\n\n'
                '📅 **Calendar**\n'
                '  • "Show my calendar today"\n'
                '  • "What meetings do I have?"\n\n'
                '📊 **Day Brief**\n'
                '  • "What\'s my day?"\n'
                '  • "Give me my morning brief"\n\n'
                'Just type naturally! 😊',
            isUser: false,
            sentAt: DateTime.now(),
          );
          break;

        default:
          final aiText = await _grok.chat(text, history: _history);
          ariaMsg = ChatMessage(id: _uuid.v4(), content: aiText,
              isUser: false, sentAt: DateTime.now());
      }

      _history.add({'role': 'assistant', 'content': ariaMsg.content});
      if (_history.length > 20) _history.removeRange(0, 2);

      final updated = state.messages
          .where((m) => m.id != 'loading')
          .toList()
        ..add(ariaMsg);

      state = state.copyWith(messages: updated, isTyping: false);
    } catch (e) {
      final errMsg = ChatMessage(
        id: _uuid.v4(),
        content: 'Something went wrong. Please try again.',
        isUser: false, sentAt: DateTime.now(), isError: true,
        type: MessageType.error,
      );
      final updated = state.messages.where((m) => m.id != 'loading').toList()..add(errMsg);
      state = state.copyWith(messages: updated, isTyping: false);
    }
  }

  void clear() {
    _history.clear();
    state = ChatState(messages: [
      ChatMessage(
          id: _uuid.v4(), isUser: false, sentAt: DateTime.now(),
          content: 'Chat cleared! 🧹 Ready to help. What would you like to do?'),
    ]);
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>(
        (_) => ChatNotifier());

// ── Chat State ─────────────────────────────────────────────────────
class ChatState {
  final List<ChatMessage> messages;
  final bool isTyping;
  const ChatState({required this.messages, this.isTyping = false});
  ChatState copyWith({List<ChatMessage>? messages, bool? isTyping}) => ChatState(
    messages: messages ?? this.messages,
    isTyping: isTyping ?? this.isTyping,
  );
}

// ── Onboarding Provider ────────────────────────────────────────────
class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier() : super(false);
  void complete() => state = true;
  void reset()    => state = false;
}

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>(
        (_) => OnboardingNotifier());
