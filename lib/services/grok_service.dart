// ═══════════════════════════════════════════════════════════════════════
//  lib/services/grok_service.dart
//  Grok AI Integration — xAI API
//  Endpoint: https://api.x.ai/v1/chat/completions
// ═══════════════════════════════════════════════════════════════════════

import 'package:dio/dio.dart';
import '../models/aria_models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GrokService {
  GrokService._();
  static final GrokService instance = GrokService._();

  // Grok API Configuration
  static String get _apiKey => dotenv.env['GROQ_API_KEY'] ?? '';
  static const String _baseUrl = 'https://api.x.ai/v1/chat/completions';
  static const String _model = 'grok-beta';
  static const Duration _timeout = Duration(seconds: 30);

  static const String _systemPrompt = '''
You are ARIA, an AI Personal Secretary app for a professional.
You help with: emails, calendar, reminders, and daily briefings.

RESPONSE RULES:
- Keep responses SHORT and CONVERSATIONAL (2-5 sentences max for regular chat)
- For reminders: extract date/time and confirm creation
- For emails: summarize key points
- For day brief: give a crisp 3-4 sentence summary
- Use emojis sparingly but meaningfully
- Be professional yet friendly
- If user asks to set a reminder, ALWAYS confirm the title and time
- If you can't do something (like actually send email), say you'll prepare it for review

SPECIAL COMMANDS you handle:
- "show emails" / "inbox" → acknowledge and note emails are shown below
- "set reminder" → parse and confirm the reminder details
- "what's my day" → give a day summary
- "show calendar" / "meetings" → acknowledge calendar shown below
- "draft reply" → write a professional email reply
- "search emails about X" → acknowledge search

Always respond in plain text. No markdown headers. Use **bold** only for key info.
Keep it under 100 words unless writing an email draft.
''';

  late final Dio _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: _timeout,
    receiveTimeout: _timeout,
    headers: {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
    },
  ));

  // ── Detect intent from user message ─────────────────────────────────
  ChatIntent detectIntent(String text) {
    final lower = text.toLowerCase().trim();

    // Email intents
    if (lower.contains('email') || lower.contains('inbox') || lower.contains('mail')) {
      if (lower.contains('reply') || lower.contains('respond') || lower.contains('draft')) return ChatIntent.draftReply;
      if (lower.contains('search') || lower.contains('find') || lower.contains('look for')) return ChatIntent.searchEmails;
      if (lower.contains('send')) return ChatIntent.sendEmail;
      return ChatIntent.emailSummary;
    }

    // Reminder intents
    if (lower.contains('remind') || lower.contains('reminder')) {
      if (lower.contains('show') || lower.contains('list') || lower.contains('all') || lower.contains('view')) {
        if (!lower.contains('set') && !lower.contains('create') && !lower.contains('add')) {
          return ChatIntent.viewReminders;
        }
      }
      return ChatIntent.setReminder;
    }
    if (lower.contains('task') && !lower.contains('email')) return ChatIntent.viewReminders;

    // Day / calendar
    if (lower.contains('day') || lower.contains('brief') || lower.contains('today') ||
        lower.contains('schedule') || lower.contains('morning') || lower.contains("what's up")) {
      return ChatIntent.dayBrief;
    }
    if (lower.contains('calendar') || lower.contains('meeting') || lower.contains('event') ||
        lower.contains('appointment')) return ChatIntent.calendarView;

    // Greetings
    if (RegExp(r'^(hi|hello|hey|good morning|good afternoon|good evening|salam|assalam|yo)').hasMatch(lower)) {
      return ChatIntent.greeting;
    }

    // Help
    if (lower.contains('help') || lower.contains('what can') || lower.contains('feature')) {
      return ChatIntent.help;
    }

    return ChatIntent.general;
  }

  // ── Parse reminder from text ─────────────────────────────────────────
  ParsedReminder? parseReminder(String text) {
    final lower = text.toLowerCase();
    final now = DateTime.now();
    DateTime? when;

    // Extract title
    String title = text
        .replaceAll(RegExp(r'^remind me\s*', caseSensitive: false), '')
        .replaceAll(RegExp(r'^set reminder\s*(for\s*)?', caseSensitive: false), '')
        .replaceAll(RegExp(r'^add reminder\s*(for\s*)?', caseSensitive: false), '')
        .trim();

    final aboutMatch = RegExp(r'\babout\s+(.+)$', caseSensitive: false).firstMatch(text);
    if (aboutMatch != null) title = aboutMatch.group(1)!.trim();

    // Parse time
    int hour = 9, minute = 0;
    final timeMatch = RegExp(
        r'(\d{1,2})(?::(\d{2}))?\s*(am|pm)', caseSensitive: false).firstMatch(lower);
    if (timeMatch != null) {
      hour = int.parse(timeMatch.group(1)!);
      minute = timeMatch.group(2) != null ? int.parse(timeMatch.group(2)!) : 0;
      if (timeMatch.group(3)!.toLowerCase() == 'pm' && hour != 12) hour += 12;
      if (timeMatch.group(3)!.toLowerCase() == 'am' && hour == 12) hour = 0;
    }

    // Parse date
    if (lower.contains('today')) {
      when = DateTime(now.year, now.month, now.day, hour, minute);
    } else if (lower.contains('tomorrow')) {
      final t = now.add(const Duration(days: 1));
      when = DateTime(t.year, t.month, t.day, hour, minute);
    } else if (lower.contains('monday')) {
      when = _nextWeekday(now, DateTime.monday, hour, minute);
    } else if (lower.contains('tuesday')) {
      when = _nextWeekday(now, DateTime.tuesday, hour, minute);
    } else if (lower.contains('wednesday')) {
      when = _nextWeekday(now, DateTime.wednesday, hour, minute);
    } else if (lower.contains('thursday')) {
      when = _nextWeekday(now, DateTime.thursday, hour, minute);
    } else if (lower.contains('friday')) {
      when = _nextWeekday(now, DateTime.friday, hour, minute);
    } else if (lower.contains('saturday')) {
      when = _nextWeekday(now, DateTime.saturday, hour, minute);
    } else if (lower.contains('sunday')) {
      when = _nextWeekday(now, DateTime.sunday, hour, minute);
    } else if (RegExp(r'in (\d+) hour').hasMatch(lower)) {
      final m = RegExp(r'in (\d+) hour').firstMatch(lower)!;
      when = now.add(Duration(hours: int.parse(m.group(1)!)));
    } else if (RegExp(r'in (\d+) min').hasMatch(lower)) {
      final m = RegExp(r'in (\d+) min').firstMatch(lower)!;
      when = now.add(Duration(minutes: int.parse(m.group(1)!)));
    } else {
      final t = now.add(const Duration(days: 1));
      when = DateTime(t.year, t.month, t.day, hour, minute);
    }

    // Clean title
    String clean = title
        .replaceAll(RegExp(r'\b(today|tomorrow|monday|tuesday|wednesday|thursday|friday|saturday|sunday)\b', caseSensitive: false), '')
        .replaceAll(RegExp(r'\d{1,2}(:\d{2})?\s*(am|pm)', caseSensitive: false), '')
        .replaceAll(RegExp(r'\bin\s+\d+\s+(hour|min)(ute)?s?\b', caseSensitive: false), '')
        .replaceAll(RegExp(r'\bat\b'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (clean.isEmpty) clean = title.trim().isNotEmpty ? title.trim() : 'Reminder';
    return ParsedReminder(title: clean, remindAt: when);
  }

  DateTime _nextWeekday(DateTime from, int weekday, int h, int m) {
    int days = weekday - from.weekday;
    if (days <= 0) days += 7;
    final t = from.add(Duration(days: days));
    return DateTime(t.year, t.month, t.day, h, m);
  }

  // ── Send message to Grok AI ──────────────────────────────────────────
  Future<String> chat(String userMessage, {
    List<Map<String, String>>? history,
  }) async {
    try {
      final messages = <Map<String, dynamic>>[
        {'role': 'system', 'content': _systemPrompt},
      ];

      // Add last 10 history messages for context
      if (history != null && history.isNotEmpty) {
        for (final h in history.take(10)) {
          messages.add(h);
        }
      }

      messages.add({'role': 'user', 'content': userMessage});

      final response = await _dio.post(
        '',
        data: {
          'model': _model,
          'messages': messages,
          'max_tokens': 300,
          'temperature': 0.7,
          'stream': false,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final choices = data['choices'] as List<dynamic>;
        if (choices.isNotEmpty) {
          final msg = choices[0]['message'] as Map<String, dynamic>;
          return msg['content'] as String? ?? 'Sorry, I couldn\'t process that.';
        }
      }
      return _fallbackResponse(userMessage);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return '⏱️ Request timed out. Please check your connection and try again.';
      }
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        return '🔑 API Authentication failed. Please check your Grok API key.';
      }
      if (e.response?.statusCode == 429) {
        return '⏳ Too many requests. Please wait a moment and try again.';
      }
      return _fallbackResponse(userMessage);
    } catch (e) {
      return _fallbackResponse(userMessage);
    }
  }

  // ── Draft email reply ────────────────────────────────────────────────
  Future<String> draftReply(EmailModel email) async {
    final prompt = '''
Write a professional email reply to this email:

From: ${email.fromName} <${email.fromEmail}>
Subject: ${email.subject}
Message: ${email.body}

Write a concise, professional reply. Match the tone. Keep it under 100 words.
Start with a greeting and end with a professional sign-off.
''';
    return chat(prompt);
  }

  // ── Generate day brief ───────────────────────────────────────────────
  Future<String> generateDayBrief({
    required int pendingReminders,
    required int overdueReminders,
    required int urgentEmails,
    required int meetings,
    required String nextMeeting,
  }) async {
    final prompt = '''
Generate a morning day brief for a professional. Be concise (3-4 sentences max).

Data:
- Meetings today: $meetings${nextMeeting.isNotEmpty ? ' (next: $nextMeeting)' : ''}
- Urgent emails: $urgentEmails
- Pending reminders: $pendingReminders${overdueReminders > 0 ? ' ($overdueReminders overdue!)' : ''}

Be upbeat and professional. Mention the most important items first.
Use emojis: 📅 for meetings, ✉️ for emails, 🔔 for reminders.
''';
    return chat(prompt);
  }

  // ── Fallback responses (offline) ─────────────────────────────────────
  String _fallbackResponse(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('email') || lower.contains('inbox')) {
      return '📬 Here are your most important emails. I\'ve sorted them by priority for you!';
    }
    if (lower.contains('remind')) {
      return '✅ Got it! I\'ve set your reminder. You\'ll be notified at the right time.';
    }
    if (lower.contains('day') || lower.contains('brief')) {
      return '📊 Here\'s your day summary! You have meetings, emails, and tasks waiting.';
    }
    if (lower.contains('calendar') || lower.contains('meeting')) {
      return '📅 Here are your calendar events for today!';
    }
    if (RegExp(r'^(hi|hello|hey|salam)').hasMatch(lower)) {
      return 'Hello! 👋 I\'m ARIA, your personal secretary. How can I help you today?';
    }
    return 'I\'m here to help! You can ask me about your emails, reminders, calendar, or say "help" for a full list of commands.';
  }
}

// ── Chat Intent ──────────────────────────────────────────────────────────
enum ChatIntent {
  emailSummary,
  draftReply,
  searchEmails,
  sendEmail,
  viewReminders,
  setReminder,
  dayBrief,
  calendarView,
  greeting,
  help,
  general,
}

// ── Parsed Reminder ──────────────────────────────────────────────────────
class ParsedReminder {
  final String title;
  final DateTime remindAt;
  const ParsedReminder({required this.title, required this.remindAt});
}
