# 🔧 Backend e Persistência - Expense Control APP

## Visão Geral

O backend do **Expense Control APP** utiliza uma arquitetura **Offline-First** com sincronização bidirecional, combinando:

- **Drift 2.29** (SQLite) para persistência local
- **Firebase Auth 6.1.2** para autenticação
- **Cloud Firestore 6.1.0** para sincronização na nuvem
- **Firebase Core 4.2.1** como base do Firebase

---

## 🗄️ Drift 2.29 - Banco de Dados Local (SQLite)

### Por que Drift 2.29?

- ✅ **Type-safe:** Queries compiladas e verificadas
- ✅ **Reactive:** Streams para mudanças em tempo real
- ✅ **Performance:** Otimizado para Flutter com melhorias na v2.29
- ✅ **Migrations:** Controle robusto de versão do schema
- ✅ **Cross-platform:** Android, iOS, Web, Desktop
- ✅ **Better Code Generation:** Geração de código mais rápida e eficiente
- ✅ **Improved Type Safety:** Melhor inferência de tipos

---

### Estrutura do Banco de Dados

#### **1. Tabela: Transactions**

```dart
import 'package:drift/drift.dart';

@DataClassName('TransactionData')
class Transactions extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  RealColumn get amount => real()();
  TextColumn get category => text()();
  TextColumn get description => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get paymentMethod => intEnum<PaymentMethod>()();
  IntColumn get type => intEnum<TransactionType>()();
  TextColumn get userId => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
  
  @override
  List<Set<Column>>? get uniqueKeys => [
    {id},
  ];
}
```

**Campos:**
- `id`: UUID gerado automaticamente
- `amount`: Valor monetário (sempre > 0)
- `category`: Categoria da transação
- `description`: Descrição detalhada
- `date`: Data da transação
- `paymentMethod`: Método de pagamento (enum)
- `type`: Tipo (Income/Expense)
- `userId`: ID do usuário proprietário
- `createdAt`: Timestamp de criação
- `updatedAt`: Timestamp de atualização
- `isDeleted`: Soft-delete flag
- `syncedAt`: Última sincronização

---

#### **2. Tabela: Categories**

```dart
@DataClassName('CategoryData')
class Categories extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get name => text()();
  TextColumn get icon => text()();
  TextColumn get color => text()();
  RealColumn get budgetLimit => real().nullable()();
  TextColumn get userId => text()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
```

**Categorias Padrão:**
1. Alimentação
2. Transporte
3. Saúde
4. Lazer
5. Outros

---

#### **3. Tabela: SyncMetadata**

```dart
@DataClassName('SyncMetadataData')
class SyncMetadata extends Table {
  TextColumn get entityId => text()();
  TextColumn get entityType => text()();
  DateTimeColumn get lastSyncedAt => dateTime()();
  IntColumn get syncStatus => intEnum<SyncStatus>()();
  TextColumn get conflictData => text().nullable()();

  @override
  Set<Column> get primaryKey => {entityId, entityType};
}
```

**Enum SyncStatus:**
```dart
enum SyncStatus {
  synced,      // Sincronizado
  pending,     // Aguardando sincronização
  conflict,    // Conflito detectado
  error        // Erro na sincronização
}
```

---

### Configuração do Database (Drift 2.29)

```dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Transactions, Categories, SyncMetadata],
  daos: [TransactionDao, CategoryDao, SyncMetadataDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Exemplo de migração para versão 2
          // await m.addColumn(transactions, transactions.syncedAt);
        }
      },
      beforeOpen: (details) async {
        // Habilita foreign keys (se necessário)
        if (details.wasCreated) {
          // Database foi criado pela primeira vez
        }
      },
    );
  }

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'expense_control.sqlite'));
      
      return NativeDatabase.createInBackground(file);
    });
  }
}
```

---

### DAO (Data Access Objects) - Drift 2.29

#### **TransactionDao**

```dart
import 'package:drift/drift.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [Transactions])
class TransactionDao extends DatabaseAccessor<AppDatabase> 
    with _$TransactionDaoMixin {
  TransactionDao(AppDatabase db) : super(db);

  // Stream de todas transações não deletadas
  Stream<List<TransactionData>> watchAllTransactions() {
    return (select(transactions)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  // Get por ID
  Future<TransactionData?> getTransactionById(String id) {
    return (select(transactions)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // Inserir transação
  Future<int> insertTransaction(Insertable<TransactionData> transaction) {
    return into(transactions).insert(transaction);
  }

  // Atualizar transação
  Future<bool> updateTransaction(Insertable<TransactionData> transaction) {
    return update(transactions).replace(transaction);
  }

  // Soft-delete
  Future<int> softDeleteTransaction(String id) {
    return (update(transactions)..where((t) => t.id.equals(id)))
        .write(TransactionsCompanion(
      isDeleted: const Value(true),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // Filtrar por período
  Future<List<TransactionData>> getTransactionsByPeriod(
    DateTime startDate,
    DateTime endDate,
  ) {
    return (select(transactions)
          ..where((t) => 
              t.date.isBiggerOrEqualValue(startDate) &
              t.date.isSmallerOrEqualValue(endDate))
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  // Filtrar por categoria
  Stream<List<TransactionData>> watchTransactionsByCategory(String category) {
    return (select(transactions)
          ..where((t) => t.category.equals(category))
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  // Filtrar por tipo
  Future<List<TransactionData>> getTransactionsByType(TransactionType type) {
    return (select(transactions)
          ..where((t) => t.type.equalsValue(type))
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  // Obter transações pendentes de sincronização
  Future<List<TransactionData>> getPendingSync() {
    return (select(transactions)
          ..where((t) => t.syncedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.updatedAt)]))
        .get();
  }

  // Calcular saldo total
  Future<double> calculateTotalBalance() async {
    final income = await _calculateTotalByType(TransactionType.income);
    final expense = await _calculateTotalByType(TransactionType.expense);
    return income - expense;
  }

  Future<double> _calculateTotalByType(TransactionType type) async {
    final query = selectOnly(transactions)
      ..addColumns([transactions.amount.sum()])
      ..where(transactions.type.equalsValue(type))
      ..where(transactions.isDeleted.equals(false));

    final result = await query.getSingleOrNull();
    return result?.read(transactions.amount.sum()) ?? 0.0;
  }
}
```

---

## 🔥 Firebase - Backend na Nuvem

### **1. Firebase Authentication 6.1.2**

#### Configuração

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream do usuário atual
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Usuário atual
  User? get currentUser => _auth.currentUser;

  // Login
  Future<Either<AuthFailure, User>> signIn(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        return Left(UnknownAuthFailure());
      }
      
      return Right(credential.user!);
    } on FirebaseAuthException catch (e) {
      return Left(_handleAuthException(e));
    } catch (e) {
      return Left(UnknownAuthFailure());
    }
  }

  // Registro
  Future<Either<AuthFailure, User>> signUp(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        return Left(UnknownAuthFailure());
      }
      
      return Right(credential.user!);
    } on FirebaseAuthException catch (e) {
      return Left(_handleAuthException(e));
    } catch (e) {
      return Left(UnknownAuthFailure());
    }
  }

  // Recuperação de senha
  Future<Either<AuthFailure, void>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(_handleAuthException(e));
    } catch (e) {
      return Left(UnknownAuthFailure());
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Tratamento de exceções do Firebase Auth 6.x
  AuthFailure _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return UserNotFoundFailure();
      case 'wrong-password':
        return WrongPasswordFailure();
      case 'invalid-email':
        return InvalidEmailFailure();
      case 'user-disabled':
        return UserDisabledFailure();
      case 'email-already-in-use':
        return EmailAlreadyInUseFailure();
      case 'weak-password':
        return WeakPasswordFailure();
      case 'operation-not-allowed':
        return OperationNotAllowedFailure();
      case 'too-many-requests':
        return TooManyRequestsFailure();
      case 'network-request-failed':
        return NetworkFailure();
      default:
        return UnknownAuthFailure();
    }
  }
}
```

#### Validações

**Email:**
```dart
static const emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email é obrigatório';
  }
  if (!RegExp(emailRegex).hasMatch(value)) {
    return 'Email inválido';
  }
  return null;
}
```

**Senha:**
```dart
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Senha é obrigatória';
  }
  if (value.length < 8) {
    return 'Senha deve ter no mínimo 8 caracteres';
  }
  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return 'Senha deve ter pelo menos 1 letra maiúscula';
  }
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return 'Senha deve ter pelo menos 1 número';
  }
  return null;
}
```

---

### **2. Cloud Firestore 6.1.0 - Sincronização**

#### Estrutura de Coleções

```
users/
  ├── {userId}/
      ├── transactions/
      │   └── {transactionId}/
      │       ├── id: string
      │       ├── amount: number
      │       ├── category: string
      │       ├── description: string
      │       ├── date: timestamp
      │       ├── paymentMethod: string
      │       ├── type: string
      │       ├── createdAt: timestamp
      │       ├── updatedAt: timestamp
      │       └── isDeleted: boolean
      │
      └── categories/
          └── {categoryId}/
              ├── id: string
              ├── name: string
              ├── icon: string
              ├── color: string
              ├── budgetLimit: number
              ├── isDefault: boolean
              ├── createdAt: timestamp
              └── updatedAt: timestamp
```

---

## 🔄 Estratégia de Sincronização Offline-First

### Princípios

1. **Local é a Source of Truth**
   - Todas as operações são feitas primeiro localmente
   - UI sempre responde instantaneamente

2. **Sincronização em Background**
   - Sincronização automática quando há conectividade
   - Retry automático em caso de falha

3. **Resolução de Conflitos: Last-Write-Wins**
   - Timestamp `updatedAt` determina versão mais recente
   - Sincronização bidirecional

---

### Fluxo de Sincronização

```
┌────────────────────────────────────────────────────┐
│                   USER ACTION                      │
│              (Criar/Editar/Deletar)                │
└────────────────────┬───────────────────────────────┘
                     │
                     ↓
┌────────────────────────────────────────────────────┐
│              DRIFT (Local Database)                │
│           ✓ Salva imediatamente                    │
│           ✓ UI atualizada                          │
└────────────────────┬───────────────────────────────┘
                     │
                     ↓
┌────────────────────────────────────────────────────┐
│           MARCA PARA SINCRONIZAÇÃO                 │
│         (syncStatus = pending)                     │
└────────────────────┬───────────────────────────────┘
                     │
                     ↓
         ┌───────────────────────┐
         │  Tem Internet?        │
         └───────┬───────────────┘
                 │
        Sim ←────┴────→ Não
         │               │
         ↓               ↓
┌─────────────────┐  ┌──────────────────┐
│  FIRESTORE SYNC │  │  Aguarda conexão │
│  ✓ Upload       │  │  (Retry later)   │
└─────────────────┘  └──────────────────┘
         │
         ↓
┌─────────────────────────────────────┐
│   syncStatus = synced               │
│   syncedAt = now()                  │
└─────────────────────────────────────┘
```

---

### Implementação da Sincronização (Firestore 6.1.0)

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseSyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AppDatabase _database;
  
  FirebaseSyncService(this._database);

  // Sincronizar transação local → Firestore
  Future<void> syncTransactionToFirestore(TransactionData transaction) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(transaction.id)
          .set({
        'id': transaction.id,
        'amount': transaction.amount,
        'category': transaction.category,
        'description': transaction.description,
        'date': Timestamp.fromDate(transaction.date),
        'paymentMethod': transaction.paymentMethod.name,
        'type': transaction.type.name,
        'createdAt': Timestamp.fromDate(transaction.createdAt),
        'updatedAt': Timestamp.fromDate(transaction.updatedAt),
        'isDeleted': transaction.isDeleted,
      }, SetOptions(merge: true));

      // Atualiza status de sincronização
      await _database.syncMetadataDao.updateSyncStatus(
        transaction.id,
        'transaction',
        SyncStatus.synced,
      );
    } catch (e) {
      // Marca como erro para retry
      await _database.syncMetadataDao.updateSyncStatus(
        transaction.id,
        'transaction',
        SyncStatus.error,
      );
      rethrow;
    }
  }

  // Sincronizar Firestore → Local (Pull)
  Future<void> syncFromFirestore() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .get();

      for (final doc in snapshot.docs) {
        final remoteData = doc.data();
        final remoteUpdatedAt = (remoteData['updatedAt'] as Timestamp).toDate();

        // Verifica se existe localmente
        final local = await _database.transactionDao.getTransactionById(doc.id);

        if (local == null) {
          // Não existe local, insere
          await _database.transactionDao.insertTransaction(
            _mapFirestoreToLocal(remoteData),
          );
        } else {
          // Existe local, resolve conflito (Last-Write-Wins)
          if (remoteUpdatedAt.isAfter(local.updatedAt)) {
            await _database.transactionDao.updateTransaction(
              _mapFirestoreToLocal(remoteData),
            );
          } else if (local.updatedAt.isAfter(remoteUpdatedAt)) {
            // Local é mais recente, sincroniza para Firestore
            await syncTransactionToFirestore(local);
          }
        }
      }
    } catch (e) {
      print('Erro ao sincronizar do Firestore: $e');
      rethrow;
    }
  }

  // Worker de sincronização automática
  void startAutoSync() {
    Timer.periodic(const Duration(minutes: 5), (_) async {
      if (await _hasInternetConnection()) {
        await syncPendingChanges();
        await syncFromFirestore();
      }
    });
  }

  // Sincroniza mudanças pendentes
  Future<void> syncPendingChanges() async {
    final pendingTransactions = await _database.transactionDao.getPendingSync();

    for (final transaction in pendingTransactions) {
      await syncTransactionToFirestore(transaction);
    }
  }

  TransactionsCompanion _mapFirestoreToLocal(Map<String, dynamic> data) {
    return TransactionsCompanion.insert(
      id: data['id'] as String,
      amount: (data['amount'] as num).toDouble(),
      category: data['category'] as String,
      description: data['description'] as String,
      date: (data['date'] as Timestamp).toDate(),
      paymentMethod: PaymentMethod.values.byName(data['paymentMethod'] as String),
      type: TransactionType.values.byName(data['type'] as String),
      userId: FirebaseAuth.instance.currentUser!.uid,
      createdAt: Value((data['createdAt'] as Timestamp).toDate()),
      updatedAt: Value((data['updatedAt'] as Timestamp).toDate()),
      isDeleted: Value(data['isDeleted'] as bool),
      syncedAt: Value(DateTime.now()),
    );
  }

  Future<bool> _hasInternetConnection() async {
    // Implementar verificação de conectividade
    return true;
  }
}
```

---

## 🗑️ Soft-Deletes (Tombstones)

### Por que Soft-Deletes?

- ✅ Permite sincronização de exclusões
- ✅ Mantém histórico de mudanças
- ✅ Possibilita recuperação de dados
- ✅ Evita conflitos de sincronização

### Implementação

```dart
// Ao deletar localmente
Future<void> deleteTransaction(String id) async {
  await _database.transactionDao.softDeleteTransaction(id);
  
  // Marca para sincronização
  await _database.syncMetadataDao.markForSync(id, 'transaction');
}

// Na sincronização para Firestore
if (transaction.isDeleted) {
  await _firestore
      .collection('users/$userId/transactions')
      .doc(transaction.id)
      .update({'isDeleted': true, 'updatedAt': FieldValue.serverTimestamp()});
}

// Queries filtram automaticamente
Stream<List<TransactionData>> watchAllTransactions() {
  return (select(transactions)
    ..where((t) => t.isDeleted.equals(false)))
      .watch();
}
```

---

## 📊 Boas Práticas Implementadas

### ✅ **1. Indexação de Queries (Drift 2.29)**
```dart
@override
List<Index> get customIndexes => [
  Index('idx_transactions_date', [date]),
  Index('idx_transactions_category', [category]),
  Index('idx_transactions_user_id', [userId]),
  Index('idx_transactions_is_deleted', [isDeleted]),
];
```

### ✅ **2. Transactions (ACID)**
```dart
Future<void> createTransactionWithCategory(
  TransactionData transaction,
  CategoryData category,
) async {
  await _database.transaction(() async {
    await _database.transactionDao.insertTransaction(transaction);
    await _database.categoryDao.insertCategory(category);
  });
}
```

### ✅ **3. Migration Versionamento**
```dart
@DriftDatabase(
  tables: [Transactions, Categories, SyncMetadata],
  daos: [TransactionDao, CategoryDao, SyncMetadataDao],
)
class AppDatabase extends _$AppDatabase {
  @override
  int get schemaVersion => 2;
  
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from == 1) {
        await migrator.addColumn(transactions, transactions.syncedAt);
      }
    },
  );
}
```

### ✅ **4. Error Handling**
```dart
try {
  await syncToFirestore();
} on FirebaseException catch (e) {
  if (e.code == 'permission-denied') {
    throw PermissionDeniedException();
  } else if (e.code == 'unavailable') {
    throw NetworkException();
  }
  rethrow;
}
```

---

## 🔒 Segurança

### Firebase Security Rules (Firestore 6.1.0)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper function para verificar autenticação
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Helper function para verificar ownership
    function isOwner(userId) {
      return request.auth.uid == userId;
    }
    
    match /users/{userId} {
      allow read, write: if isAuthenticated() && isOwner(userId);
      
      match /transactions/{transactionId} {
        allow read, write: if isAuthenticated() && isOwner(userId);
        
        // Validações de dados
        allow create: if isAuthenticated() 
                      && isOwner(userId)
                      && request.resource.data.amount > 0
                      && request.resource.data.description is string;
        
        allow update: if isAuthenticated() 
                      && isOwner(userId)
                      && request.resource.data.amount > 0;
      }
      
      match /categories/{categoryId} {
        allow read, write: if isAuthenticated() && isOwner(userId);
      }
    }
  }
}
```

---

**Desenvolvido por:** Leankar.dev  
**Versão:** 1.0.0  
**Stack:** Drift 2.29 | Firebase Auth 6.1.2 | Cloud Firestore 6.1.0  
**Contato:** leankar.dev@gmail.com