import 'package:drift/drift.dart';

import 'connection/connection.dart';

part 'app_database.g.dart';

@DataClassName('DbUser')
class DbUsers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get email => text().withLength(min: 3, max: 254)();
  TextColumn get passwordHash => text()();
  TextColumn get passwordSalt => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column<Object>>>? get uniqueKeys => [
        {email},
      ];
}

@DataClassName('DbExpense')
class DbExpenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  RealColumn get amount => real()();
  TextColumn get currency => text().withLength(min: 1, max: 8).withDefault(const Constant('PKR'))();
  TextColumn get category => text().withLength(min: 1, max: 60)();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('DbTask')
class DbTasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get title => text().withLength(min: 1, max: 140)();
  TextColumn get description => text().nullable()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  IntColumn get priority => integer().withDefault(const Constant(1))(); // 0 low, 1 med, 2 high
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending/done
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('DbJobApplication')
class DbJobApplications extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get company => text().withLength(min: 1, max: 120)();
  TextColumn get role => text().withLength(min: 1, max: 120)();
  TextColumn get jobUrl => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('Applied'))();
  DateTimeColumn get appliedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get notes => text().nullable()();
}

@DataClassName('DbMeeting')
class DbMeetings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get title => text().withLength(min: 1, max: 140)();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  TextColumn get platform => text().withDefault(const Constant('Meet'))();
  TextColumn get summary => text().nullable()();
  TextColumn get participantsJson => text().withDefault(const Constant('[]'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [DbUsers, DbExpenses, DbTasks, DbJobApplications, DbMeetings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from == 1) {
            await m.createTable(dbExpenses);
            await m.createTable(dbTasks);
            await m.createTable(dbJobApplications);
            await m.createTable(dbMeetings);
          }
        },
      );

  Future<DbUser?> getUserById(int id) {
    return (select(dbUsers)..where((u) => u.id.equals(id))).getSingleOrNull();
  }

  Future<DbUser?> getUserByEmail(String email) {
    final normalized = email.trim().toLowerCase();
    return (select(dbUsers)..where((u) => u.email.equals(normalized)))
        .getSingleOrNull();
  }

  Future<int> createUser({
    required String name,
    required String email,
    required String passwordHash,
    required String passwordSalt,
  }) async {
    return into(dbUsers).insert(DbUsersCompanion.insert(
      name: name.trim(),
      email: email.trim().toLowerCase(),
      passwordHash: passwordHash,
      passwordSalt: passwordSalt,
    ));
  }

  Future<bool> updateUserProfile({
    required int id,
    required String name,
    required String email,
  }) async {
    final rows = await (update(dbUsers)..where((u) => u.id.equals(id))).write(
      DbUsersCompanion(
        name: Value(name.trim()),
        email: Value(email.trim().toLowerCase()),
      ),
    );
    return rows > 0;
  }

  // ── Expenses ─────────────────────────────────────────────────────
  Stream<List<DbExpense>> watchExpenses(int userId) {
    return (select(dbExpenses)
          ..where((e) => e.userId.equals(userId))
          ..orderBy([(e) => OrderingTerm.desc(e.date)]))
        .watch();
  }

  Future<int> addExpense({
    required int userId,
    required double amount,
    required String category,
    required DateTime date,
    String currency = 'PKR',
    String? notes,
  }) {
    return into(dbExpenses).insert(DbExpensesCompanion.insert(
      userId: userId,
      amount: amount,
      category: category.trim(),
      currency: Value(currency.trim().isEmpty ? 'PKR' : currency.trim()),
      date: date,
      notes: Value(notes?.trim()),
    ));
  }

  Future<void> deleteExpense(int id, int userId) async {
    await (delete(dbExpenses)
          ..where((e) => e.id.equals(id) & e.userId.equals(userId)))
        .go();
  }

  // ── Tasks ────────────────────────────────────────────────────────
  Stream<List<DbTask>> watchTasks(int userId) {
    return (select(dbTasks)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.asc(t.dueDate), (t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<int> addTask({
    required int userId,
    required String title,
    String? description,
    DateTime? dueDate,
    int priority = 1,
  }) {
    return into(dbTasks).insert(DbTasksCompanion.insert(
      userId: userId,
      title: title.trim(),
      description: Value(description?.trim()),
      dueDate: Value(dueDate),
      priority: Value(priority),
    ));
  }

  Future<void> setTaskStatus({
    required int id,
    required int userId,
    required bool done,
  }) async {
    await (update(dbTasks)..where((t) => t.id.equals(id) & t.userId.equals(userId)))
        .write(DbTasksCompanion(status: Value(done ? 'done' : 'pending')));
  }

  Future<void> deleteTask(int id, int userId) async {
    await (delete(dbTasks)..where((t) => t.id.equals(id) & t.userId.equals(userId))).go();
  }

  // ── Job Applications ─────────────────────────────────────────────
  Stream<List<DbJobApplication>> watchJobApplications(int userId) {
    return (select(dbJobApplications)
          ..where((j) => j.userId.equals(userId))
          ..orderBy([(j) => OrderingTerm.desc(j.appliedAt)]))
        .watch();
  }

  Future<int> addJobApplication({
    required int userId,
    required String company,
    required String role,
    String? jobUrl,
    String status = 'Applied',
    String? notes,
  }) {
    return into(dbJobApplications).insert(DbJobApplicationsCompanion.insert(
      userId: userId,
      company: company.trim(),
      role: role.trim(),
      jobUrl: Value(jobUrl?.trim()),
      status: Value(status.trim()),
      notes: Value(notes?.trim()),
    ));
  }

  Future<void> deleteJobApplication(int id, int userId) async {
    await (delete(dbJobApplications)
          ..where((j) => j.id.equals(id) & j.userId.equals(userId)))
        .go();
  }

  // ── Meetings ────────────────────────────────────────────────────
  Stream<List<DbMeeting>> watchMeetings(int userId) {
    return (select(dbMeetings)
          ..where((m) => m.userId.equals(userId))
          ..orderBy([(m) => OrderingTerm.desc(m.startTime)]))
        .watch();
  }

  Future<int> addMeeting({
    required int userId,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    String platform = 'Meet',
    String? summary,
    String participantsJson = '[]',
  }) {
    return into(dbMeetings).insert(DbMeetingsCompanion.insert(
      userId: userId,
      title: title.trim(),
      startTime: startTime,
      endTime: endTime,
      platform: Value(platform.trim()),
      summary: Value(summary?.trim()),
      participantsJson: Value(participantsJson),
    ));
  }

  Future<void> deleteMeeting(int id, int userId) async {
    await (delete(dbMeetings)
          ..where((m) => m.id.equals(id) & m.userId.equals(userId)))
        .go();
  }
}

