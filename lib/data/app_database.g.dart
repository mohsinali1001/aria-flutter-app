// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DbUsersTable extends DbUsers with TableInfo<$DbUsersTable, DbUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 254),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _passwordHashMeta =
      const VerificationMeta('passwordHash');
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
      'password_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passwordSaltMeta =
      const VerificationMeta('passwordSalt');
  @override
  late final GeneratedColumn<String> passwordSalt = GeneratedColumn<String>(
      'password_salt', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, email, passwordHash, passwordSalt, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_users';
  @override
  VerificationContext validateIntegrity(Insertable<DbUser> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
          _passwordHashMeta,
          passwordHash.isAcceptableOrUnknown(
              data['password_hash']!, _passwordHashMeta));
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('password_salt')) {
      context.handle(
          _passwordSaltMeta,
          passwordSalt.isAcceptableOrUnknown(
              data['password_salt']!, _passwordSaltMeta));
    } else if (isInserting) {
      context.missing(_passwordSaltMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {email},
      ];
  @override
  DbUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbUser(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      passwordHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password_hash'])!,
      passwordSalt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password_salt'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DbUsersTable createAlias(String alias) {
    return $DbUsersTable(attachedDatabase, alias);
  }
}

class DbUser extends DataClass implements Insertable<DbUser> {
  final int id;
  final String name;
  final String email;
  final String passwordHash;
  final String passwordSalt;
  final DateTime createdAt;
  const DbUser(
      {required this.id,
      required this.name,
      required this.email,
      required this.passwordHash,
      required this.passwordSalt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['password_hash'] = Variable<String>(passwordHash);
    map['password_salt'] = Variable<String>(passwordSalt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DbUsersCompanion toCompanion(bool nullToAbsent) {
    return DbUsersCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      passwordHash: Value(passwordHash),
      passwordSalt: Value(passwordSalt),
      createdAt: Value(createdAt),
    );
  }

  factory DbUser.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbUser(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      passwordSalt: serializer.fromJson<String>(json['passwordSalt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'passwordSalt': serializer.toJson<String>(passwordSalt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DbUser copyWith(
          {int? id,
          String? name,
          String? email,
          String? passwordHash,
          String? passwordSalt,
          DateTime? createdAt}) =>
      DbUser(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        passwordHash: passwordHash ?? this.passwordHash,
        passwordSalt: passwordSalt ?? this.passwordSalt,
        createdAt: createdAt ?? this.createdAt,
      );
  DbUser copyWithCompanion(DbUsersCompanion data) {
    return DbUser(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      passwordSalt: data.passwordSalt.present
          ? data.passwordSalt.value
          : this.passwordSalt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbUser(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('passwordSalt: $passwordSalt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, email, passwordHash, passwordSalt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbUser &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.passwordHash == this.passwordHash &&
          other.passwordSalt == this.passwordSalt &&
          other.createdAt == this.createdAt);
}

class DbUsersCompanion extends UpdateCompanion<DbUser> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String> passwordHash;
  final Value<String> passwordSalt;
  final Value<DateTime> createdAt;
  const DbUsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.passwordSalt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DbUsersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String email,
    required String passwordHash,
    required String passwordSalt,
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        email = Value(email),
        passwordHash = Value(passwordHash),
        passwordSalt = Value(passwordSalt);
  static Insertable<DbUser> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? passwordHash,
    Expression<String>? passwordSalt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (passwordSalt != null) 'password_salt': passwordSalt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DbUsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? email,
      Value<String>? passwordHash,
      Value<String>? passwordSalt,
      Value<DateTime>? createdAt}) {
    return DbUsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      passwordSalt: passwordSalt ?? this.passwordSalt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (passwordSalt.present) {
      map['password_salt'] = Variable<String>(passwordSalt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbUsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('passwordSalt: $passwordSalt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DbExpensesTable extends DbExpenses
    with TableInfo<$DbExpensesTable, DbExpense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 8),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('PKR'));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 60),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, amount, currency, category, notes, date, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_expenses';
  @override
  VerificationContext validateIntegrity(Insertable<DbExpense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbExpense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbExpense(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DbExpensesTable createAlias(String alias) {
    return $DbExpensesTable(attachedDatabase, alias);
  }
}

class DbExpense extends DataClass implements Insertable<DbExpense> {
  final int id;
  final int userId;
  final double amount;
  final String currency;
  final String category;
  final String? notes;
  final DateTime date;
  final DateTime createdAt;
  const DbExpense(
      {required this.id,
      required this.userId,
      required this.amount,
      required this.currency,
      required this.category,
      this.notes,
      required this.date,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['amount'] = Variable<double>(amount);
    map['currency'] = Variable<String>(currency);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['date'] = Variable<DateTime>(date);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DbExpensesCompanion toCompanion(bool nullToAbsent) {
    return DbExpensesCompanion(
      id: Value(id),
      userId: Value(userId),
      amount: Value(amount),
      currency: Value(currency),
      category: Value(category),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      date: Value(date),
      createdAt: Value(createdAt),
    );
  }

  factory DbExpense.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbExpense(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      amount: serializer.fromJson<double>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      category: serializer.fromJson<String>(json['category']),
      notes: serializer.fromJson<String?>(json['notes']),
      date: serializer.fromJson<DateTime>(json['date']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'amount': serializer.toJson<double>(amount),
      'currency': serializer.toJson<String>(currency),
      'category': serializer.toJson<String>(category),
      'notes': serializer.toJson<String?>(notes),
      'date': serializer.toJson<DateTime>(date),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DbExpense copyWith(
          {int? id,
          int? userId,
          double? amount,
          String? currency,
          String? category,
          Value<String?> notes = const Value.absent(),
          DateTime? date,
          DateTime? createdAt}) =>
      DbExpense(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        amount: amount ?? this.amount,
        currency: currency ?? this.currency,
        category: category ?? this.category,
        notes: notes.present ? notes.value : this.notes,
        date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt,
      );
  DbExpense copyWithCompanion(DbExpensesCompanion data) {
    return DbExpense(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      category: data.category.present ? data.category.value : this.category,
      notes: data.notes.present ? data.notes.value : this.notes,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbExpense(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('category: $category, ')
          ..write('notes: $notes, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, userId, amount, currency, category, notes, date, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbExpense &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.category == this.category &&
          other.notes == this.notes &&
          other.date == this.date &&
          other.createdAt == this.createdAt);
}

class DbExpensesCompanion extends UpdateCompanion<DbExpense> {
  final Value<int> id;
  final Value<int> userId;
  final Value<double> amount;
  final Value<String> currency;
  final Value<String> category;
  final Value<String?> notes;
  final Value<DateTime> date;
  final Value<DateTime> createdAt;
  const DbExpensesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.category = const Value.absent(),
    this.notes = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DbExpensesCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required double amount,
    this.currency = const Value.absent(),
    required String category,
    this.notes = const Value.absent(),
    required DateTime date,
    this.createdAt = const Value.absent(),
  })  : userId = Value(userId),
        amount = Value(amount),
        category = Value(category),
        date = Value(date);
  static Insertable<DbExpense> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<double>? amount,
    Expression<String>? currency,
    Expression<String>? category,
    Expression<String>? notes,
    Expression<DateTime>? date,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (category != null) 'category': category,
      if (notes != null) 'notes': notes,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DbExpensesCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<double>? amount,
      Value<String>? currency,
      Value<String>? category,
      Value<String?>? notes,
      Value<DateTime>? date,
      Value<DateTime>? createdAt}) {
    return DbExpensesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbExpensesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('category: $category, ')
          ..write('notes: $notes, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DbTasksTable extends DbTasks with TableInfo<$DbTasksTable, DbTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 140),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, title, description, dueDate, priority, status, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_tasks';
  @override
  VerificationContext validateIntegrity(Insertable<DbTask> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbTask(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date']),
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DbTasksTable createAlias(String alias) {
    return $DbTasksTable(attachedDatabase, alias);
  }
}

class DbTask extends DataClass implements Insertable<DbTask> {
  final int id;
  final int userId;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final int priority;
  final String status;
  final DateTime createdAt;
  const DbTask(
      {required this.id,
      required this.userId,
      required this.title,
      this.description,
      this.dueDate,
      required this.priority,
      required this.status,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    map['priority'] = Variable<int>(priority);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DbTasksCompanion toCompanion(bool nullToAbsent) {
    return DbTasksCompanion(
      id: Value(id),
      userId: Value(userId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      priority: Value(priority),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory DbTask.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbTask(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      priority: serializer.fromJson<int>(json['priority']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'priority': serializer.toJson<int>(priority),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DbTask copyWith(
          {int? id,
          int? userId,
          String? title,
          Value<String?> description = const Value.absent(),
          Value<DateTime?> dueDate = const Value.absent(),
          int? priority,
          String? status,
          DateTime? createdAt}) =>
      DbTask(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        priority: priority ?? this.priority,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );
  DbTask copyWithCompanion(DbTasksCompanion data) {
    return DbTask(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      priority: data.priority.present ? data.priority.value : this.priority,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbTask(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, userId, title, description, dueDate, priority, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbTask &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.description == this.description &&
          other.dueDate == this.dueDate &&
          other.priority == this.priority &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class DbTasksCompanion extends UpdateCompanion<DbTask> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime?> dueDate;
  final Value<int> priority;
  final Value<String> status;
  final Value<DateTime> createdAt;
  const DbTasksCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DbTasksCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String title,
    this.description = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : userId = Value(userId),
        title = Value(title);
  static Insertable<DbTask> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? dueDate,
    Expression<int>? priority,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (dueDate != null) 'due_date': dueDate,
      if (priority != null) 'priority': priority,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DbTasksCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<String>? title,
      Value<String?>? description,
      Value<DateTime?>? dueDate,
      Value<int>? priority,
      Value<String>? status,
      Value<DateTime>? createdAt}) {
    return DbTasksCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbTasksCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DbJobApplicationsTable extends DbJobApplications
    with TableInfo<$DbJobApplicationsTable, DbJobApplication> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbJobApplicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _companyMeta =
      const VerificationMeta('company');
  @override
  late final GeneratedColumn<String> company = GeneratedColumn<String>(
      'company', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _jobUrlMeta = const VerificationMeta('jobUrl');
  @override
  late final GeneratedColumn<String> jobUrl = GeneratedColumn<String>(
      'job_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Applied'));
  static const VerificationMeta _appliedAtMeta =
      const VerificationMeta('appliedAt');
  @override
  late final GeneratedColumn<DateTime> appliedAt = GeneratedColumn<DateTime>(
      'applied_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, company, role, jobUrl, status, appliedAt, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_job_applications';
  @override
  VerificationContext validateIntegrity(Insertable<DbJobApplication> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('company')) {
      context.handle(_companyMeta,
          company.isAcceptableOrUnknown(data['company']!, _companyMeta));
    } else if (isInserting) {
      context.missing(_companyMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('job_url')) {
      context.handle(_jobUrlMeta,
          jobUrl.isAcceptableOrUnknown(data['job_url']!, _jobUrlMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('applied_at')) {
      context.handle(_appliedAtMeta,
          appliedAt.isAcceptableOrUnknown(data['applied_at']!, _appliedAtMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbJobApplication map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbJobApplication(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      company: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}company'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      jobUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}job_url']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      appliedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}applied_at'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $DbJobApplicationsTable createAlias(String alias) {
    return $DbJobApplicationsTable(attachedDatabase, alias);
  }
}

class DbJobApplication extends DataClass
    implements Insertable<DbJobApplication> {
  final int id;
  final int userId;
  final String company;
  final String role;
  final String? jobUrl;
  final String status;
  final DateTime appliedAt;
  final String? notes;
  const DbJobApplication(
      {required this.id,
      required this.userId,
      required this.company,
      required this.role,
      this.jobUrl,
      required this.status,
      required this.appliedAt,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['company'] = Variable<String>(company);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || jobUrl != null) {
      map['job_url'] = Variable<String>(jobUrl);
    }
    map['status'] = Variable<String>(status);
    map['applied_at'] = Variable<DateTime>(appliedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  DbJobApplicationsCompanion toCompanion(bool nullToAbsent) {
    return DbJobApplicationsCompanion(
      id: Value(id),
      userId: Value(userId),
      company: Value(company),
      role: Value(role),
      jobUrl:
          jobUrl == null && nullToAbsent ? const Value.absent() : Value(jobUrl),
      status: Value(status),
      appliedAt: Value(appliedAt),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory DbJobApplication.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbJobApplication(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      company: serializer.fromJson<String>(json['company']),
      role: serializer.fromJson<String>(json['role']),
      jobUrl: serializer.fromJson<String?>(json['jobUrl']),
      status: serializer.fromJson<String>(json['status']),
      appliedAt: serializer.fromJson<DateTime>(json['appliedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'company': serializer.toJson<String>(company),
      'role': serializer.toJson<String>(role),
      'jobUrl': serializer.toJson<String?>(jobUrl),
      'status': serializer.toJson<String>(status),
      'appliedAt': serializer.toJson<DateTime>(appliedAt),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  DbJobApplication copyWith(
          {int? id,
          int? userId,
          String? company,
          String? role,
          Value<String?> jobUrl = const Value.absent(),
          String? status,
          DateTime? appliedAt,
          Value<String?> notes = const Value.absent()}) =>
      DbJobApplication(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        company: company ?? this.company,
        role: role ?? this.role,
        jobUrl: jobUrl.present ? jobUrl.value : this.jobUrl,
        status: status ?? this.status,
        appliedAt: appliedAt ?? this.appliedAt,
        notes: notes.present ? notes.value : this.notes,
      );
  DbJobApplication copyWithCompanion(DbJobApplicationsCompanion data) {
    return DbJobApplication(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      company: data.company.present ? data.company.value : this.company,
      role: data.role.present ? data.role.value : this.role,
      jobUrl: data.jobUrl.present ? data.jobUrl.value : this.jobUrl,
      status: data.status.present ? data.status.value : this.status,
      appliedAt: data.appliedAt.present ? data.appliedAt.value : this.appliedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbJobApplication(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('company: $company, ')
          ..write('role: $role, ')
          ..write('jobUrl: $jobUrl, ')
          ..write('status: $status, ')
          ..write('appliedAt: $appliedAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, company, role, jobUrl, status, appliedAt, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbJobApplication &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.company == this.company &&
          other.role == this.role &&
          other.jobUrl == this.jobUrl &&
          other.status == this.status &&
          other.appliedAt == this.appliedAt &&
          other.notes == this.notes);
}

class DbJobApplicationsCompanion extends UpdateCompanion<DbJobApplication> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> company;
  final Value<String> role;
  final Value<String?> jobUrl;
  final Value<String> status;
  final Value<DateTime> appliedAt;
  final Value<String?> notes;
  const DbJobApplicationsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.company = const Value.absent(),
    this.role = const Value.absent(),
    this.jobUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.appliedAt = const Value.absent(),
    this.notes = const Value.absent(),
  });
  DbJobApplicationsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String company,
    required String role,
    this.jobUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.appliedAt = const Value.absent(),
    this.notes = const Value.absent(),
  })  : userId = Value(userId),
        company = Value(company),
        role = Value(role);
  static Insertable<DbJobApplication> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? company,
    Expression<String>? role,
    Expression<String>? jobUrl,
    Expression<String>? status,
    Expression<DateTime>? appliedAt,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (company != null) 'company': company,
      if (role != null) 'role': role,
      if (jobUrl != null) 'job_url': jobUrl,
      if (status != null) 'status': status,
      if (appliedAt != null) 'applied_at': appliedAt,
      if (notes != null) 'notes': notes,
    });
  }

  DbJobApplicationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<String>? company,
      Value<String>? role,
      Value<String?>? jobUrl,
      Value<String>? status,
      Value<DateTime>? appliedAt,
      Value<String?>? notes}) {
    return DbJobApplicationsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      company: company ?? this.company,
      role: role ?? this.role,
      jobUrl: jobUrl ?? this.jobUrl,
      status: status ?? this.status,
      appliedAt: appliedAt ?? this.appliedAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (company.present) {
      map['company'] = Variable<String>(company.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (jobUrl.present) {
      map['job_url'] = Variable<String>(jobUrl.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (appliedAt.present) {
      map['applied_at'] = Variable<DateTime>(appliedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbJobApplicationsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('company: $company, ')
          ..write('role: $role, ')
          ..write('jobUrl: $jobUrl, ')
          ..write('status: $status, ')
          ..write('appliedAt: $appliedAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $DbMeetingsTable extends DbMeetings
    with TableInfo<$DbMeetingsTable, DbMeeting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbMeetingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 140),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
      'end_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _platformMeta =
      const VerificationMeta('platform');
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
      'platform', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Meet'));
  static const VerificationMeta _summaryMeta =
      const VerificationMeta('summary');
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
      'summary', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _participantsJsonMeta =
      const VerificationMeta('participantsJson');
  @override
  late final GeneratedColumn<String> participantsJson = GeneratedColumn<String>(
      'participants_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        title,
        startTime,
        endTime,
        platform,
        summary,
        participantsJson,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_meetings';
  @override
  VerificationContext validateIntegrity(Insertable<DbMeeting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('platform')) {
      context.handle(_platformMeta,
          platform.isAcceptableOrUnknown(data['platform']!, _platformMeta));
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta));
    }
    if (data.containsKey('participants_json')) {
      context.handle(
          _participantsJsonMeta,
          participantsJson.isAcceptableOrUnknown(
              data['participants_json']!, _participantsJsonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbMeeting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbMeeting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_time'])!,
      platform: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}platform'])!,
      summary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary']),
      participantsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}participants_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DbMeetingsTable createAlias(String alias) {
    return $DbMeetingsTable(attachedDatabase, alias);
  }
}

class DbMeeting extends DataClass implements Insertable<DbMeeting> {
  final int id;
  final int userId;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String platform;
  final String? summary;
  final String participantsJson;
  final DateTime createdAt;
  const DbMeeting(
      {required this.id,
      required this.userId,
      required this.title,
      required this.startTime,
      required this.endTime,
      required this.platform,
      this.summary,
      required this.participantsJson,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['title'] = Variable<String>(title);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    map['platform'] = Variable<String>(platform);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    map['participants_json'] = Variable<String>(participantsJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DbMeetingsCompanion toCompanion(bool nullToAbsent) {
    return DbMeetingsCompanion(
      id: Value(id),
      userId: Value(userId),
      title: Value(title),
      startTime: Value(startTime),
      endTime: Value(endTime),
      platform: Value(platform),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      participantsJson: Value(participantsJson),
      createdAt: Value(createdAt),
    );
  }

  factory DbMeeting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbMeeting(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      platform: serializer.fromJson<String>(json['platform']),
      summary: serializer.fromJson<String?>(json['summary']),
      participantsJson: serializer.fromJson<String>(json['participantsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'title': serializer.toJson<String>(title),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'platform': serializer.toJson<String>(platform),
      'summary': serializer.toJson<String?>(summary),
      'participantsJson': serializer.toJson<String>(participantsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DbMeeting copyWith(
          {int? id,
          int? userId,
          String? title,
          DateTime? startTime,
          DateTime? endTime,
          String? platform,
          Value<String?> summary = const Value.absent(),
          String? participantsJson,
          DateTime? createdAt}) =>
      DbMeeting(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        platform: platform ?? this.platform,
        summary: summary.present ? summary.value : this.summary,
        participantsJson: participantsJson ?? this.participantsJson,
        createdAt: createdAt ?? this.createdAt,
      );
  DbMeeting copyWithCompanion(DbMeetingsCompanion data) {
    return DbMeeting(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      platform: data.platform.present ? data.platform.value : this.platform,
      summary: data.summary.present ? data.summary.value : this.summary,
      participantsJson: data.participantsJson.present
          ? data.participantsJson.value
          : this.participantsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbMeeting(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('platform: $platform, ')
          ..write('summary: $summary, ')
          ..write('participantsJson: $participantsJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, title, startTime, endTime,
      platform, summary, participantsJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbMeeting &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.platform == this.platform &&
          other.summary == this.summary &&
          other.participantsJson == this.participantsJson &&
          other.createdAt == this.createdAt);
}

class DbMeetingsCompanion extends UpdateCompanion<DbMeeting> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> title;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<String> platform;
  final Value<String?> summary;
  final Value<String> participantsJson;
  final Value<DateTime> createdAt;
  const DbMeetingsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.platform = const Value.absent(),
    this.summary = const Value.absent(),
    this.participantsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DbMeetingsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    this.platform = const Value.absent(),
    this.summary = const Value.absent(),
    this.participantsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : userId = Value(userId),
        title = Value(title),
        startTime = Value(startTime),
        endTime = Value(endTime);
  static Insertable<DbMeeting> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? title,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<String>? platform,
    Expression<String>? summary,
    Expression<String>? participantsJson,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (platform != null) 'platform': platform,
      if (summary != null) 'summary': summary,
      if (participantsJson != null) 'participants_json': participantsJson,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DbMeetingsCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<String>? title,
      Value<DateTime>? startTime,
      Value<DateTime>? endTime,
      Value<String>? platform,
      Value<String?>? summary,
      Value<String>? participantsJson,
      Value<DateTime>? createdAt}) {
    return DbMeetingsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      platform: platform ?? this.platform,
      summary: summary ?? this.summary,
      participantsJson: participantsJson ?? this.participantsJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (participantsJson.present) {
      map['participants_json'] = Variable<String>(participantsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbMeetingsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('platform: $platform, ')
          ..write('summary: $summary, ')
          ..write('participantsJson: $participantsJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DbUsersTable dbUsers = $DbUsersTable(this);
  late final $DbExpensesTable dbExpenses = $DbExpensesTable(this);
  late final $DbTasksTable dbTasks = $DbTasksTable(this);
  late final $DbJobApplicationsTable dbJobApplications =
      $DbJobApplicationsTable(this);
  late final $DbMeetingsTable dbMeetings = $DbMeetingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [dbUsers, dbExpenses, dbTasks, dbJobApplications, dbMeetings];
}

typedef $$DbUsersTableCreateCompanionBuilder = DbUsersCompanion Function({
  Value<int> id,
  required String name,
  required String email,
  required String passwordHash,
  required String passwordSalt,
  Value<DateTime> createdAt,
});
typedef $$DbUsersTableUpdateCompanionBuilder = DbUsersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> email,
  Value<String> passwordHash,
  Value<String> passwordSalt,
  Value<DateTime> createdAt,
});

class $$DbUsersTableFilterComposer
    extends Composer<_$AppDatabase, $DbUsersTable> {
  $$DbUsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get passwordSalt => $composableBuilder(
      column: $table.passwordSalt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$DbUsersTableOrderingComposer
    extends Composer<_$AppDatabase, $DbUsersTable> {
  $$DbUsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get passwordSalt => $composableBuilder(
      column: $table.passwordSalt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$DbUsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $DbUsersTable> {
  $$DbUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => column);

  GeneratedColumn<String> get passwordSalt => $composableBuilder(
      column: $table.passwordSalt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DbUsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DbUsersTable,
    DbUser,
    $$DbUsersTableFilterComposer,
    $$DbUsersTableOrderingComposer,
    $$DbUsersTableAnnotationComposer,
    $$DbUsersTableCreateCompanionBuilder,
    $$DbUsersTableUpdateCompanionBuilder,
    (DbUser, BaseReferences<_$AppDatabase, $DbUsersTable, DbUser>),
    DbUser,
    PrefetchHooks Function()> {
  $$DbUsersTableTableManager(_$AppDatabase db, $DbUsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> passwordHash = const Value.absent(),
            Value<String> passwordSalt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DbUsersCompanion(
            id: id,
            name: name,
            email: email,
            passwordHash: passwordHash,
            passwordSalt: passwordSalt,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String email,
            required String passwordHash,
            required String passwordSalt,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DbUsersCompanion.insert(
            id: id,
            name: name,
            email: email,
            passwordHash: passwordHash,
            passwordSalt: passwordSalt,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DbUsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DbUsersTable,
    DbUser,
    $$DbUsersTableFilterComposer,
    $$DbUsersTableOrderingComposer,
    $$DbUsersTableAnnotationComposer,
    $$DbUsersTableCreateCompanionBuilder,
    $$DbUsersTableUpdateCompanionBuilder,
    (DbUser, BaseReferences<_$AppDatabase, $DbUsersTable, DbUser>),
    DbUser,
    PrefetchHooks Function()>;
typedef $$DbExpensesTableCreateCompanionBuilder = DbExpensesCompanion Function({
  Value<int> id,
  required int userId,
  required double amount,
  Value<String> currency,
  required String category,
  Value<String?> notes,
  required DateTime date,
  Value<DateTime> createdAt,
});
typedef $$DbExpensesTableUpdateCompanionBuilder = DbExpensesCompanion Function({
  Value<int> id,
  Value<int> userId,
  Value<double> amount,
  Value<String> currency,
  Value<String> category,
  Value<String?> notes,
  Value<DateTime> date,
  Value<DateTime> createdAt,
});

class $$DbExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $DbExpensesTable> {
  $$DbExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$DbExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $DbExpensesTable> {
  $$DbExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$DbExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DbExpensesTable> {
  $$DbExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DbExpensesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DbExpensesTable,
    DbExpense,
    $$DbExpensesTableFilterComposer,
    $$DbExpensesTableOrderingComposer,
    $$DbExpensesTableAnnotationComposer,
    $$DbExpensesTableCreateCompanionBuilder,
    $$DbExpensesTableUpdateCompanionBuilder,
    (DbExpense, BaseReferences<_$AppDatabase, $DbExpensesTable, DbExpense>),
    DbExpense,
    PrefetchHooks Function()> {
  $$DbExpensesTableTableManager(_$AppDatabase db, $DbExpensesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DbExpensesCompanion(
            id: id,
            userId: userId,
            amount: amount,
            currency: currency,
            category: category,
            notes: notes,
            date: date,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required double amount,
            Value<String> currency = const Value.absent(),
            required String category,
            Value<String?> notes = const Value.absent(),
            required DateTime date,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DbExpensesCompanion.insert(
            id: id,
            userId: userId,
            amount: amount,
            currency: currency,
            category: category,
            notes: notes,
            date: date,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DbExpensesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DbExpensesTable,
    DbExpense,
    $$DbExpensesTableFilterComposer,
    $$DbExpensesTableOrderingComposer,
    $$DbExpensesTableAnnotationComposer,
    $$DbExpensesTableCreateCompanionBuilder,
    $$DbExpensesTableUpdateCompanionBuilder,
    (DbExpense, BaseReferences<_$AppDatabase, $DbExpensesTable, DbExpense>),
    DbExpense,
    PrefetchHooks Function()>;
typedef $$DbTasksTableCreateCompanionBuilder = DbTasksCompanion Function({
  Value<int> id,
  required int userId,
  required String title,
  Value<String?> description,
  Value<DateTime?> dueDate,
  Value<int> priority,
  Value<String> status,
  Value<DateTime> createdAt,
});
typedef $$DbTasksTableUpdateCompanionBuilder = DbTasksCompanion Function({
  Value<int> id,
  Value<int> userId,
  Value<String> title,
  Value<String?> description,
  Value<DateTime?> dueDate,
  Value<int> priority,
  Value<String> status,
  Value<DateTime> createdAt,
});

class $$DbTasksTableFilterComposer
    extends Composer<_$AppDatabase, $DbTasksTable> {
  $$DbTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$DbTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $DbTasksTable> {
  $$DbTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$DbTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $DbTasksTable> {
  $$DbTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DbTasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DbTasksTable,
    DbTask,
    $$DbTasksTableFilterComposer,
    $$DbTasksTableOrderingComposer,
    $$DbTasksTableAnnotationComposer,
    $$DbTasksTableCreateCompanionBuilder,
    $$DbTasksTableUpdateCompanionBuilder,
    (DbTask, BaseReferences<_$AppDatabase, $DbTasksTable, DbTask>),
    DbTask,
    PrefetchHooks Function()> {
  $$DbTasksTableTableManager(_$AppDatabase db, $DbTasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DbTasksCompanion(
            id: id,
            userId: userId,
            title: title,
            description: description,
            dueDate: dueDate,
            priority: priority,
            status: status,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required String title,
            Value<String?> description = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DbTasksCompanion.insert(
            id: id,
            userId: userId,
            title: title,
            description: description,
            dueDate: dueDate,
            priority: priority,
            status: status,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DbTasksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DbTasksTable,
    DbTask,
    $$DbTasksTableFilterComposer,
    $$DbTasksTableOrderingComposer,
    $$DbTasksTableAnnotationComposer,
    $$DbTasksTableCreateCompanionBuilder,
    $$DbTasksTableUpdateCompanionBuilder,
    (DbTask, BaseReferences<_$AppDatabase, $DbTasksTable, DbTask>),
    DbTask,
    PrefetchHooks Function()>;
typedef $$DbJobApplicationsTableCreateCompanionBuilder
    = DbJobApplicationsCompanion Function({
  Value<int> id,
  required int userId,
  required String company,
  required String role,
  Value<String?> jobUrl,
  Value<String> status,
  Value<DateTime> appliedAt,
  Value<String?> notes,
});
typedef $$DbJobApplicationsTableUpdateCompanionBuilder
    = DbJobApplicationsCompanion Function({
  Value<int> id,
  Value<int> userId,
  Value<String> company,
  Value<String> role,
  Value<String?> jobUrl,
  Value<String> status,
  Value<DateTime> appliedAt,
  Value<String?> notes,
});

class $$DbJobApplicationsTableFilterComposer
    extends Composer<_$AppDatabase, $DbJobApplicationsTable> {
  $$DbJobApplicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get company => $composableBuilder(
      column: $table.company, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get jobUrl => $composableBuilder(
      column: $table.jobUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get appliedAt => $composableBuilder(
      column: $table.appliedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$DbJobApplicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $DbJobApplicationsTable> {
  $$DbJobApplicationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get company => $composableBuilder(
      column: $table.company, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jobUrl => $composableBuilder(
      column: $table.jobUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get appliedAt => $composableBuilder(
      column: $table.appliedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$DbJobApplicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DbJobApplicationsTable> {
  $$DbJobApplicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get company =>
      $composableBuilder(column: $table.company, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get jobUrl =>
      $composableBuilder(column: $table.jobUrl, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get appliedAt =>
      $composableBuilder(column: $table.appliedAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$DbJobApplicationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DbJobApplicationsTable,
    DbJobApplication,
    $$DbJobApplicationsTableFilterComposer,
    $$DbJobApplicationsTableOrderingComposer,
    $$DbJobApplicationsTableAnnotationComposer,
    $$DbJobApplicationsTableCreateCompanionBuilder,
    $$DbJobApplicationsTableUpdateCompanionBuilder,
    (
      DbJobApplication,
      BaseReferences<_$AppDatabase, $DbJobApplicationsTable, DbJobApplication>
    ),
    DbJobApplication,
    PrefetchHooks Function()> {
  $$DbJobApplicationsTableTableManager(
      _$AppDatabase db, $DbJobApplicationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbJobApplicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbJobApplicationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbJobApplicationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> company = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String?> jobUrl = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> appliedAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              DbJobApplicationsCompanion(
            id: id,
            userId: userId,
            company: company,
            role: role,
            jobUrl: jobUrl,
            status: status,
            appliedAt: appliedAt,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required String company,
            required String role,
            Value<String?> jobUrl = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> appliedAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              DbJobApplicationsCompanion.insert(
            id: id,
            userId: userId,
            company: company,
            role: role,
            jobUrl: jobUrl,
            status: status,
            appliedAt: appliedAt,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DbJobApplicationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DbJobApplicationsTable,
    DbJobApplication,
    $$DbJobApplicationsTableFilterComposer,
    $$DbJobApplicationsTableOrderingComposer,
    $$DbJobApplicationsTableAnnotationComposer,
    $$DbJobApplicationsTableCreateCompanionBuilder,
    $$DbJobApplicationsTableUpdateCompanionBuilder,
    (
      DbJobApplication,
      BaseReferences<_$AppDatabase, $DbJobApplicationsTable, DbJobApplication>
    ),
    DbJobApplication,
    PrefetchHooks Function()>;
typedef $$DbMeetingsTableCreateCompanionBuilder = DbMeetingsCompanion Function({
  Value<int> id,
  required int userId,
  required String title,
  required DateTime startTime,
  required DateTime endTime,
  Value<String> platform,
  Value<String?> summary,
  Value<String> participantsJson,
  Value<DateTime> createdAt,
});
typedef $$DbMeetingsTableUpdateCompanionBuilder = DbMeetingsCompanion Function({
  Value<int> id,
  Value<int> userId,
  Value<String> title,
  Value<DateTime> startTime,
  Value<DateTime> endTime,
  Value<String> platform,
  Value<String?> summary,
  Value<String> participantsJson,
  Value<DateTime> createdAt,
});

class $$DbMeetingsTableFilterComposer
    extends Composer<_$AppDatabase, $DbMeetingsTable> {
  $$DbMeetingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get platform => $composableBuilder(
      column: $table.platform, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get participantsJson => $composableBuilder(
      column: $table.participantsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$DbMeetingsTableOrderingComposer
    extends Composer<_$AppDatabase, $DbMeetingsTable> {
  $$DbMeetingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get platform => $composableBuilder(
      column: $table.platform, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get participantsJson => $composableBuilder(
      column: $table.participantsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$DbMeetingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DbMeetingsTable> {
  $$DbMeetingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get participantsJson => $composableBuilder(
      column: $table.participantsJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DbMeetingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DbMeetingsTable,
    DbMeeting,
    $$DbMeetingsTableFilterComposer,
    $$DbMeetingsTableOrderingComposer,
    $$DbMeetingsTableAnnotationComposer,
    $$DbMeetingsTableCreateCompanionBuilder,
    $$DbMeetingsTableUpdateCompanionBuilder,
    (DbMeeting, BaseReferences<_$AppDatabase, $DbMeetingsTable, DbMeeting>),
    DbMeeting,
    PrefetchHooks Function()> {
  $$DbMeetingsTableTableManager(_$AppDatabase db, $DbMeetingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbMeetingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbMeetingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbMeetingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<DateTime> startTime = const Value.absent(),
            Value<DateTime> endTime = const Value.absent(),
            Value<String> platform = const Value.absent(),
            Value<String?> summary = const Value.absent(),
            Value<String> participantsJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DbMeetingsCompanion(
            id: id,
            userId: userId,
            title: title,
            startTime: startTime,
            endTime: endTime,
            platform: platform,
            summary: summary,
            participantsJson: participantsJson,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required String title,
            required DateTime startTime,
            required DateTime endTime,
            Value<String> platform = const Value.absent(),
            Value<String?> summary = const Value.absent(),
            Value<String> participantsJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DbMeetingsCompanion.insert(
            id: id,
            userId: userId,
            title: title,
            startTime: startTime,
            endTime: endTime,
            platform: platform,
            summary: summary,
            participantsJson: participantsJson,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DbMeetingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DbMeetingsTable,
    DbMeeting,
    $$DbMeetingsTableFilterComposer,
    $$DbMeetingsTableOrderingComposer,
    $$DbMeetingsTableAnnotationComposer,
    $$DbMeetingsTableCreateCompanionBuilder,
    $$DbMeetingsTableUpdateCompanionBuilder,
    (DbMeeting, BaseReferences<_$AppDatabase, $DbMeetingsTable, DbMeeting>),
    DbMeeting,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DbUsersTableTableManager get dbUsers =>
      $$DbUsersTableTableManager(_db, _db.dbUsers);
  $$DbExpensesTableTableManager get dbExpenses =>
      $$DbExpensesTableTableManager(_db, _db.dbExpenses);
  $$DbTasksTableTableManager get dbTasks =>
      $$DbTasksTableTableManager(_db, _db.dbTasks);
  $$DbJobApplicationsTableTableManager get dbJobApplications =>
      $$DbJobApplicationsTableTableManager(_db, _db.dbJobApplications);
  $$DbMeetingsTableTableManager get dbMeetings =>
      $$DbMeetingsTableTableManager(_db, _db.dbMeetings);
}
