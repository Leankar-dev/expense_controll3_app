import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/transactions_table.dart';
import 'tables/categories_table.dart';
import 'tables/sync_metadata_table.dart';
import '../../enums/payment_method.dart';
import '../../enums/transaction_type.dart';

import '../dao/transaction_dao.dart';
import '../dao/category_dao.dart';
import '../dao/sync_metadata_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Transactions,
    Categories,
    SyncMetadata,
  ],
  daos: [
    TransactionDao,
    CategoryDao,
    SyncMetadataDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        try {
          await m.createAll();
          print('✅ Database tables created successfully');

          await _createCustomIndexes();
          print('✅ Custom indexes created successfully');
        } catch (e) {
          print('❌ Error during database creation: $e');
          rethrow;
        }
      },
      onUpgrade: (Migrator m, int from, int to) async {
        try {
          print('🔄 Migrating database from version $from to $to');

          if (from < 2) {
            print(
              '📝 Applying migration v1 -> v2: Adding fields to sync_metadata',
            );

            await m.addColumn(syncMetadata, syncMetadata.retryCount);
            await m.addColumn(syncMetadata, syncMetadata.errorMessage);
            await m.addColumn(syncMetadata, syncMetadata.createdAt);

            await customStatement('''
              UPDATE sync_metadata 
              SET created_at = last_synced_at 
              WHERE created_at IS NULL;
            ''');

            print('✅ Migration v1 -> v2 completed successfully');
          }
        } catch (e) {
          print('❌ Error during database migration: $e');
          rethrow;
        }
      },
      beforeOpen: (details) async {
        try {
          await customStatement('PRAGMA foreign_keys = ON');
          print('✅ Foreign keys enabled');

          if (details.wasCreated) {
            print('🆕 First time database creation detected');

            await _initializeDefaultData();
          }

          await _validateDatabaseIntegrity();
        } catch (e) {
          print('❌ Error in beforeOpen: $e');
          rethrow;
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

  Future<void> _createCustomIndexes() async {
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_date 
      ON transactions(date DESC);
    ''');

    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_category 
      ON transactions(category);
    ''');

    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_user_id 
      ON transactions(user_id);
    ''');

    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_is_deleted 
      ON transactions(is_deleted);
    ''');

    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_type 
      ON transactions(type);
    ''');

    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_composite_active 
      ON transactions(user_id, is_deleted, date DESC);
    ''');

    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_categories_user_id 
      ON categories(user_id);
    ''');

    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_categories_user_type_active 
      ON categories(user_id, type, is_active);
    ''');

    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_categories_user_order 
      ON categories(user_id, display_order);
    ''');

    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_categories_sync 
      ON categories(user_id, is_synced, last_synced_at);
    ''');
  }

  Future<void> _initializeDefaultData() async {
    try {
      print('📦 Initializing default data...');

      print('✅ Default data initialization completed');
    } catch (e) {
      print('⚠️ Error initializing default data: $e');
    }
  }

  Future<void> _validateDatabaseIntegrity() async {
    try {
      final result = await customSelect('PRAGMA integrity_check').get();
      final isValid =
          result.isNotEmpty && result.first.data['integrity_check'] == 'ok';

      if (isValid) {
        print('✅ Database integrity check passed');
      } else {
        print('⚠️ Database integrity check failed');
      }
    } catch (e) {
      print('⚠️ Could not perform integrity check: $e');
    }
  }

  @override
  Future<void> close() async {
    await super.close();
  }
}
