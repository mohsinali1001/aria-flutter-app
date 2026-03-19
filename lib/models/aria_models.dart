// ═══════════════════════════════════════════════════════════════════════
//  lib/models/aria_models.dart  —  All ARIA Data Models
// ═══════════════════════════════════════════════════════════════════════

// ── Email Model ─────────────────────────────────────────────────────────
class EmailModel {
  final String id, fromName, fromEmail, subject, preview, body;
  final DateTime receivedAt;
  final bool isRead, isImportant;
  final String importanceReason;
  final EmailPriority priority;
  final List<String> labels;

  const EmailModel({
    required this.id, required this.fromName, required this.fromEmail,
    required this.subject, required this.preview, required this.body,
    required this.receivedAt, this.isRead = false, this.isImportant = false,
    this.importanceReason = '', this.priority = EmailPriority.normal,
    this.labels = const [],
  });

  String get timeAgo {
    final d = DateTime.now().difference(receivedAt);
    if (d.inSeconds < 60)  return 'just now';
    if (d.inMinutes < 60)  return '${d.inMinutes}m ago';
    if (d.inHours < 24)    return '${d.inHours}h ago';
    if (d.inDays < 7)      return '${d.inDays}d ago';
    return '${receivedAt.day}/${receivedAt.month}';
  }

  static List<EmailModel> get samples => [
    EmailModel(
      id: 'e1', fromName: 'Sarah Ahmed', fromEmail: 'sarah@company.com',
      subject: 'Q4 Budget Review — Action Required',
      preview: 'Please review the attached budget report before Friday\'s meeting...',
      body: 'Hi,\n\nPlease review the attached Q4 budget report before Friday\'s meeting at 3 PM.\n\nWe need your approval on the proposed changes:\n• Marketing budget: +15%\n• Infrastructure: -8%\n• HR allocation: +5%\n\nKindly confirm your availability.\n\nBest regards,\nSarah Ahmed\nFinance Lead',
      receivedAt: DateTime.now().subtract(const Duration(minutes: 12)),
      isImportant: true, priority: EmailPriority.urgent,
      importanceReason: 'Action required + upcoming deadline',
      labels: ['Finance', 'Action Required'],
    ),
    EmailModel(
      id: 'e2', fromName: 'Tech Operations', fromEmail: 'tech@company.com',
      subject: 'Server maintenance tonight 11 PM–1 AM',
      preview: 'Scheduled downtime for database migration. Please save your work.',
      body: 'Dear Team,\n\nWe will be performing scheduled maintenance on our primary database servers tonight:\n\n📅 Time: 11:00 PM – 1:00 AM\n⚠️ Impact: All company apps unavailable\n\nPlease save your work before 10:45 PM.\n\nApologies for the inconvenience.\n\nTech Operations Team',
      receivedAt: DateTime.now().subtract(const Duration(hours: 2)),
      isImportant: true, priority: EmailPriority.high,
      importanceReason: 'Affects everyone tonight',
      labels: ['IT', 'Alert'],
    ),
    EmailModel(
      id: 'e3', fromName: 'Ali Khan', fromEmail: 'ali@clientcorp.com',
      subject: 'Re: Project proposal — Very interested!',
      preview: 'Thanks for the detailed proposal. We\'d like to proceed with Phase 1...',
      body: 'Hi,\n\nThank you for the detailed project proposal. Our team reviewed it thoroughly and we\'re very interested in moving forward!\n\nWe\'d like to:\n• Start with Phase 1 immediately\n• Schedule a kickoff call this week\n• Review pricing for Phase 2\n\nCould we schedule a call this Thursday or Friday?\n\nBest,\nAli Khan | CTO, ClientCorp',
      receivedAt: DateTime.now().subtract(const Duration(hours: 5)),
      isImportant: true, priority: EmailPriority.high,
      importanceReason: 'Client response — potential deal',
      labels: ['Client', 'Opportunity'],
    ),
    EmailModel(
      id: 'e4', fromName: 'HR Department', fromEmail: 'hr@company.com',
      subject: 'Leave application approved ✓',
      preview: 'Your leave request for Dec 25–26 has been approved.',
      body: 'Dear Employee,\n\nYour leave application has been reviewed and approved:\n\n📅 Dates: December 25–26 (2 days)\n✅ Status: Approved\n💼 Remaining balance: 8 days\n\nPlease ensure handover is completed before your leave.\n\nEnjoy your time off!\n\nHR Team',
      receivedAt: DateTime.now().subtract(const Duration(hours: 7)),
      priority: EmailPriority.normal, isRead: true, labels: ['HR'],
    ),
    EmailModel(
      id: 'e5', fromName: 'Weekly Digest', fromEmail: 'news@techweekly.io',
      subject: 'This week in AI: GPT-5, Gemini 2.0, and more',
      preview: 'Top developments you should know about this week in AI...',
      body: 'This week in AI:\n\n🤖 GPT-5 rumors — OpenAI hints at Q1 release\n🔥 Gemini 2.0 Flash now available for all\n⚡ Claude usage surpasses 1M developers\n🚀 Mistral new open-source model released\n🏛️ EU AI regulation final vote next month\n\nRead more at techweekly.io',
      receivedAt: DateTime.now().subtract(const Duration(days: 1)),
      priority: EmailPriority.low, isRead: true, labels: ['Newsletter'],
    ),
  ];
}

enum EmailPriority { urgent, high, normal, low }
extension EmailPriorityExt on EmailPriority {
  String get label => switch(this) {
    EmailPriority.urgent => 'Urgent',
    EmailPriority.high   => 'High',
    EmailPriority.normal => 'Normal',
    EmailPriority.low    => 'Low',
  };
  int get order => switch(this) {
    EmailPriority.urgent => 3, EmailPriority.high => 2,
    EmailPriority.normal => 1, EmailPriority.low  => 0,
  };
}

// ── Reminder Model ───────────────────────────────────────────────────────
class ReminderModel {
  final String id, title;
  final String? note;
  final DateTime remindAt, createdAt;
  final bool isDone;
  final ReminderRepeat repeat;

  const ReminderModel({
    required this.id, required this.title, this.note,
    required this.remindAt, required this.createdAt,
    this.isDone = false, this.repeat = ReminderRepeat.none,
  });

  ReminderModel copyWith({
    bool? isDone, String? title, String? note,
    DateTime? remindAt, ReminderRepeat? repeat,
  }) => ReminderModel(
    id: id, createdAt: createdAt,
    title:    title    ?? this.title,
    note:     note     ?? this.note,
    remindAt: remindAt ?? this.remindAt,
    isDone:   isDone   ?? this.isDone,
    repeat:   repeat   ?? this.repeat,
  );

  bool get isOverdue => !isDone && remindAt.isBefore(DateTime.now());
  bool get isToday {
    final n = DateTime.now();
    return remindAt.year == n.year && remindAt.month == n.month && remindAt.day == n.day;
  }
  bool get isTomorrow {
    final t = DateTime.now().add(const Duration(days: 1));
    return remindAt.year == t.year && remindAt.month == t.month && remindAt.day == t.day;
  }
  bool get isUpcoming => !isDone && !isOverdue;

  String get timeLabel {
    if (isDone)    return 'Completed';
    if (isOverdue) return 'Overdue';
    final diff = remindAt.difference(DateTime.now());
    if (diff.inMinutes < 60)  return 'In ${diff.inMinutes}m';
    if (diff.inHours < 24)    return 'In ${diff.inHours}h';
    if (isTomorrow)           return 'Tomorrow ${_fmt(remindAt)}';
    return '${remindAt.day}/${remindAt.month} ${_fmt(remindAt)}';
  }

  String _fmt(DateTime dt) {
    final h  = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final m  = dt.minute.toString().padLeft(2, '0');
    final ap = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ap';
  }

  String get fullDateLabel {
    const days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${days[remindAt.weekday - 1]}, ${months[remindAt.month - 1]} ${remindAt.day} • ${_fmt(remindAt)}';
  }

  static List<ReminderModel> get samples => [
    ReminderModel(
        id: 'r1', title: 'Call client about project proposal',
        note: 'Discuss timeline, budget, and next steps',
        createdAt: DateTime.now(),
        remindAt: DateTime.now().add(const Duration(hours: 1))),
    ReminderModel(
        id: 'r2', title: 'Team standup meeting',
        note: 'Share sprint progress and blockers',
        createdAt: DateTime.now(),
        remindAt: DateTime.now().add(const Duration(hours: 3))),
    ReminderModel(
        id: 'r3', title: 'Submit expense report',
        note: 'Must submit before 5 PM deadline',
        createdAt: DateTime.now(),
        remindAt: DateTime.now().add(const Duration(hours: 5))),
    ReminderModel(
        id: 'r4', title: 'Doctor appointment — Annual checkup',
        createdAt: DateTime.now(),
        remindAt: DateTime.now().add(const Duration(days: 1))),
    ReminderModel(
        id: 'r5', title: 'Pay electricity bill',
        note: 'Amount: ~Rs 3,500',
        createdAt: DateTime.now(),
        remindAt: DateTime.now().subtract(const Duration(hours: 2))),
    ReminderModel(
        id: 'r6', title: 'Review ARIA project code',
        note: 'Check Mohsin\'s chat screen implementation',
        createdAt: DateTime.now(),
        remindAt: DateTime.now().add(const Duration(days: 2))),
  ];
}

enum ReminderRepeat { none, daily, weekly, monthly }
extension ReminderRepeatExt on ReminderRepeat {
  String get label => switch(this) {
    ReminderRepeat.none    => 'Once',
    ReminderRepeat.daily   => 'Daily',
    ReminderRepeat.weekly  => 'Weekly',
    ReminderRepeat.monthly => 'Monthly',
  };
  String get icon => switch(this) {
    ReminderRepeat.none    => '🔔',
    ReminderRepeat.daily   => '📅',
    ReminderRepeat.weekly  => '📆',
    ReminderRepeat.monthly => '🗓️',
  };
}

// ── Calendar Event Model ─────────────────────────────────────────────────
class CalendarEvent {
  final String id, title;
  final String? description, location, meetLink;
  final DateTime startTime, endTime;
  final List<String> attendees;
  final bool isOnline;
  final EventStatus status;
  final String? colorHex;

  const CalendarEvent({
    required this.id, required this.title,
    this.description, this.location, this.meetLink,
    required this.startTime, required this.endTime,
    this.attendees = const [], this.isOnline = false,
    this.status = EventStatus.confirmed, this.colorHex,
  });

  bool get isNow =>
      DateTime.now().isAfter(startTime) && DateTime.now().isBefore(endTime);
  bool get isUpcoming => startTime.isAfter(DateTime.now());
  bool get isPast    => endTime.isBefore(DateTime.now());

  String get durationLabel {
    final mins = endTime.difference(startTime).inMinutes;
    if (mins < 60) return '${mins}m';
    final h = mins ~/ 60;
    final m = mins % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }

  String get timeRangeLabel {
    String f(DateTime dt) {
      final h  = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final m  = dt.minute.toString().padLeft(2, '0');
      final ap = dt.hour >= 12 ? 'PM' : 'AM';
      return '$h:$m $ap';
    }
    return '${f(startTime)} — ${f(endTime)}';
  }

  static List<CalendarEvent> get samples => [
    CalendarEvent(
      id: 'c1', title: 'Team Standup',
      description: 'Daily sync — sprint progress and blockers',
      startTime: DateTime.now().add(const Duration(hours: 1)),
      endTime:   DateTime.now().add(const Duration(hours: 1, minutes: 30)),
      attendees: ['Mohsin', 'Junaid', 'Abdullah', 'Huzaifa'],
      isOnline: true, meetLink: 'https://meet.google.com/abc-def-ghi',
    ),
    CalendarEvent(
      id: 'c2', title: 'Client Demo — ARIA v1',
      description: 'Present ARIA features to client stakeholders',
      location: 'Conference Room B, Floor 3',
      startTime: DateTime.now().add(const Duration(hours: 3)),
      endTime:   DateTime.now().add(const Duration(hours: 4, minutes: 30)),
      attendees: ['Mohsin', 'Huzaifa', 'Sarah (Client)', 'John (Client)'],
    ),
    CalendarEvent(
      id: 'c3', title: 'Sprint Review & Retro',
      description: 'Review Week 2 delivered tasks + retrospective',
      startTime: DateTime.now().add(const Duration(hours: 6)),
      endTime:   DateTime.now().add(const Duration(hours: 7, minutes: 30)),
      attendees: ['Whole Team'],
      isOnline: true, status: EventStatus.tentative,
    ),
  ];
}

enum EventStatus { confirmed, tentative, cancelled }

// ── Chat Message Model ───────────────────────────────────────────────────
class ChatMessage {
  final String id, content;
  final bool isUser, isLoading;
  final DateTime sentAt;
  final MessageType type;
  final List<EmailModel>? emails;
  final List<ReminderModel>? reminders;
  final List<CalendarEvent>? events;
  final bool isError;

  const ChatMessage({
    required this.id, required this.content,
    required this.isUser, required this.sentAt,
    this.isLoading = false, this.type = MessageType.text,
    this.emails, this.reminders, this.events, this.isError = false,
  });

  String get timeLabel {
    final h  = sentAt.hour > 12 ? sentAt.hour - 12 : (sentAt.hour == 0 ? 12 : sentAt.hour);
    final m  = sentAt.minute.toString().padLeft(2, '0');
    final ap = sentAt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ap';
  }

  bool get hasStructuredData => emails != null || reminders != null || events != null;
}

enum MessageType { text, emailList, reminderList, calendarList, action, error, dayBrief }

// ── Quick Chip Model ─────────────────────────────────────────────────────
class QuickChip {
  final String label, message, emoji;
  final bool fillInput; // true = fills input, false = sends directly

  const QuickChip({
    required this.label, required this.message,
    required this.emoji, this.fillInput = false,
  });

  static const List<QuickChip> all = [
    QuickChip(label: 'My emails',    message: 'Show my important emails',        emoji: '✉️'),
    QuickChip(label: 'My day',       message: "What's my day today?",            emoji: '📅'),
    QuickChip(label: 'Reminders',    message: 'Show all my reminders',           emoji: '🔔'),
    QuickChip(label: 'Set reminder', message: 'Remind me ',                      emoji: '⏰', fillInput: true),
    QuickChip(label: 'Calendar',     message: 'Show my calendar meetings today', emoji: '🗓️'),
    QuickChip(label: 'Search email', message: 'Search emails about ',            emoji: '🔍', fillInput: true),
    QuickChip(label: 'Draft reply',  message: 'Draft a reply to my latest email',emoji: '✍️'),
    QuickChip(label: 'Help',         message: 'What can you do?',                emoji: '❓'),
  ];
}

// ── Settings Model ───────────────────────────────────────────────────────
class AppSettings {
  final String userName, userEmail;
  final bool notificationsEnabled, morningBriefEnabled;
  final String morningBriefTime;
  final bool isDarkMode, compactMode;
  final String language;

  const AppSettings({
    this.userName = 'User',
    this.userEmail = 'user@gmail.com',
    this.notificationsEnabled = true,
    this.morningBriefEnabled  = true,
    this.morningBriefTime     = '08:00',
    this.isDarkMode           = false,
    this.compactMode          = false,
    this.language             = 'English',
  });

  AppSettings copyWith({
    String? userName, String? userEmail,
    bool? notificationsEnabled, bool? morningBriefEnabled,
    String? morningBriefTime, bool? isDarkMode, bool? compactMode,
    String? language,
  }) => AppSettings(
    userName:             userName             ?? this.userName,
    userEmail:            userEmail            ?? this.userEmail,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    morningBriefEnabled:  morningBriefEnabled  ?? this.morningBriefEnabled,
    morningBriefTime:     morningBriefTime     ?? this.morningBriefTime,
    isDarkMode:           isDarkMode           ?? this.isDarkMode,
    compactMode:          compactMode          ?? this.compactMode,
    language:             language             ?? this.language,
  );

  String get initials {
    final parts = userName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return userName.isNotEmpty ? userName[0].toUpperCase() : 'U';
  }
}
