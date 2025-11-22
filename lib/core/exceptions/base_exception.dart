sealed class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

sealed class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

class UserNotFoundException extends AuthException {
  const UserNotFoundException({
    super.message = 'Utilizador não encontrado',
    super.code = 'user-not-found',
    super.originalError,
    super.stackTrace,
  });
}

class WrongPasswordException extends AuthException {
  const WrongPasswordException({
    super.message = 'Palavra-passe incorreta',
    super.code = 'wrong-password',
    super.originalError,
    super.stackTrace,
  });
}

class InvalidEmailException extends AuthException {
  const InvalidEmailException({
    super.message = 'Email inválido',
    super.code = 'invalid-email',
    super.originalError,
    super.stackTrace,
  });
}

class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException({
    super.message = 'Este email já está em uso',
    super.code = 'email-already-in-use',
    super.originalError,
    super.stackTrace,
  });
}

class WeakPasswordException extends AuthException {
  const WeakPasswordException({
    super.message = 'A palavra-passe é muito fraca',
    super.code = 'weak-password',
    super.originalError,
    super.stackTrace,
  });
}

class UserDisabledException extends AuthException {
  const UserDisabledException({
    super.message = 'Esta conta foi desativada',
    super.code = 'user-disabled',
    super.originalError,
    super.stackTrace,
  });
}

class OperationNotAllowedException extends AuthException {
  const OperationNotAllowedException({
    super.message = 'Operação não permitida',
    super.code = 'operation-not-allowed',
    super.originalError,
    super.stackTrace,
  });
}

class TooManyRequestsException extends AuthException {
  const TooManyRequestsException({
    super.message = 'Demasiadas tentativas. Tente novamente mais tarde',
    super.code = 'too-many-requests',
    super.originalError,
    super.stackTrace,
  });
}

class SessionExpiredException extends AuthException {
  const SessionExpiredException({
    super.message = 'A sua sessão expirou. Faça login novamente',
    super.code = 'session-expired',
    super.originalError,
    super.stackTrace,
  });
}

class UnauthenticatedException extends AuthException {
  const UnauthenticatedException({
    super.message = 'É necessário fazer login',
    super.code = 'unauthenticated',
    super.originalError,
    super.stackTrace,
  });
}

class UnknownAuthException extends AuthException {
  const UnknownAuthException({
    super.message = 'Erro de autenticação. Tente novamente',
    super.code = 'unknown-auth-error',
    super.originalError,
    super.stackTrace,
  });
}

sealed class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

class NoInternetException extends NetworkException {
  const NoInternetException({
    super.message = 'Sem ligação à internet',
    super.code = 'no-internet',
    super.originalError,
    super.stackTrace,
  });
}

class ConnectionTimeoutException extends NetworkException {
  const ConnectionTimeoutException({
    super.message = 'A ligação expirou. Verifique a sua internet',
    super.code = 'connection-timeout',
    super.originalError,
    super.stackTrace,
  });
}

class ServerException extends NetworkException {
  final int? statusCode;

  const ServerException({
    super.message = 'Erro no servidor. Tente novamente mais tarde',
    super.code = 'server-error',
    this.statusCode,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() =>
      'ServerException: $message (code: $code, statusCode: $statusCode)';
}

class ServiceUnavailableException extends NetworkException {
  const ServiceUnavailableException({
    super.message = 'Serviço temporariamente indisponível',
    super.code = 'service-unavailable',
    super.originalError,
    super.stackTrace,
  });
}

sealed class DatabaseException extends AppException {
  const DatabaseException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

class InsertException extends DatabaseException {
  const InsertException({
    super.message = 'Erro ao guardar dados',
    super.code = 'insert-error',
    super.originalError,
    super.stackTrace,
  });
}

class UpdateException extends DatabaseException {
  const UpdateException({
    super.message = 'Erro ao atualizar dados',
    super.code = 'update-error',
    super.originalError,
    super.stackTrace,
  });
}

class DeleteException extends DatabaseException {
  const DeleteException({
    super.message = 'Erro ao eliminar dados',
    super.code = 'delete-error',
    super.originalError,
    super.stackTrace,
  });
}

class QueryException extends DatabaseException {
  const QueryException({
    super.message = 'Erro ao consultar dados',
    super.code = 'query-error',
    super.originalError,
    super.stackTrace,
  });
}

class NotFoundException extends DatabaseException {
  const NotFoundException({
    super.message = 'Registo não encontrado',
    super.code = 'not-found',
    super.originalError,
    super.stackTrace,
  });
}

class DuplicateException extends DatabaseException {
  const DuplicateException({
    super.message = 'Este registo já existe',
    super.code = 'duplicate',
    super.originalError,
    super.stackTrace,
  });
}

class MigrationException extends DatabaseException {
  const MigrationException({
    super.message = 'Erro na migração da base de dados',
    super.code = 'migration-error',
    super.originalError,
    super.stackTrace,
  });
}

sealed class SyncException extends AppException {
  const SyncException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

class SyncConflictException extends SyncException {
  final String? localVersion;
  final String? remoteVersion;

  const SyncConflictException({
    super.message = 'Conflito de sincronização detetado',
    super.code = 'sync-conflict',
    this.localVersion,
    this.remoteVersion,
    super.originalError,
    super.stackTrace,
  });
}

class SyncFailedException extends SyncException {
  const SyncFailedException({
    super.message = 'Falha na sincronização. Tente novamente',
    super.code = 'sync-failed',
    super.originalError,
    super.stackTrace,
  });
}

class PermissionDeniedException extends SyncException {
  const PermissionDeniedException({
    super.message = 'Permissão negada para aceder aos dados',
    super.code = 'permission-denied',
    super.originalError,
    super.stackTrace,
  });
}

sealed class ValidationException extends AppException {
  final String? field;

  const ValidationException({
    required super.message,
    super.code,
    this.field,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() =>
      'ValidationException: $message (field: $field, code: $code)';
}

class RequiredFieldException extends ValidationException {
  const RequiredFieldException({
    required String fieldName,
    super.code = 'required-field',
    super.field,
    super.originalError,
    super.stackTrace,
  }) : super(message: 'O campo $fieldName é obrigatório');
}

class InvalidValueException extends ValidationException {
  const InvalidValueException({
    super.message = 'Valor inválido',
    super.code = 'invalid-value',
    super.field,
    super.originalError,
    super.stackTrace,
  });
}

class OutOfRangeException extends ValidationException {
  final num? minValue;
  final num? maxValue;

  const OutOfRangeException({
    super.message = 'Valor fora do intervalo permitido',
    super.code = 'out-of-range',
    this.minValue,
    this.maxValue,
    super.field,
    super.originalError,
    super.stackTrace,
  });
}

class InvalidFormatException extends ValidationException {
  const InvalidFormatException({
    super.message = 'Formato inválido',
    super.code = 'invalid-format',
    super.field,
    super.originalError,
    super.stackTrace,
  });
}

class NegativeValueException extends ValidationException {
  const NegativeValueException({
    super.message = 'O valor não pode ser negativo',
    super.code = 'negative-value',
    super.field,
    super.originalError,
    super.stackTrace,
  });
}

class ZeroValueException extends ValidationException {
  const ZeroValueException({
    super.message = 'O valor deve ser maior que zero',
    super.code = 'zero-value',
    super.field,
    super.originalError,
    super.stackTrace,
  });
}

sealed class ExportException extends AppException {
  const ExportException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

class FileGenerationException extends ExportException {
  const FileGenerationException({
    super.message = 'Erro ao gerar ficheiro',
    super.code = 'file-generation-error',
    super.originalError,
    super.stackTrace,
  });
}

class ShareException extends ExportException {
  const ShareException({
    super.message = 'Erro ao partilhar ficheiro',
    super.code = 'share-error',
    super.originalError,
    super.stackTrace,
  });
}

class NoDataToExportException extends ExportException {
  const NoDataToExportException({
    super.message = 'Não existem dados para exportar',
    super.code = 'no-data',
    super.originalError,
    super.stackTrace,
  });
}

class StoragePermissionException extends ExportException {
  const StoragePermissionException({
    super.message = 'Permissão de armazenamento negada',
    super.code = 'storage-permission-denied',
    super.originalError,
    super.stackTrace,
  });
}

sealed class NotificationException extends AppException {
  const NotificationException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

class NotificationPermissionException extends NotificationException {
  const NotificationPermissionException({
    super.message = 'Permissão de notificação negada',
    super.code = 'notification-permission-denied',
    super.originalError,
    super.stackTrace,
  });
}

class ScheduleNotificationException extends NotificationException {
  const ScheduleNotificationException({
    super.message = 'Erro ao agendar notificação',
    super.code = 'schedule-notification-error',
    super.originalError,
    super.stackTrace,
  });
}

class UnknownException extends AppException {
  const UnknownException({
    super.message = 'Ocorreu um erro inesperado',
    super.code = 'unknown-error',
    super.originalError,
    super.stackTrace,
  });
}

sealed class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

class CacheExpiredException extends CacheException {
  const CacheExpiredException({
    super.message = 'Cache expirado',
    super.code = 'cache-expired',
    super.originalError,
    super.stackTrace,
  });
}

class CacheNotFoundException extends CacheException {
  const CacheNotFoundException({
    super.message = 'Cache não encontrado',
    super.code = 'cache-not-found',
    super.originalError,
    super.stackTrace,
  });
}

abstract final class ExceptionMapper {
  static AuthException mapFirebaseAuthError(String code, [dynamic error]) {
    return switch (code) {
      'user-not-found' => UserNotFoundException(originalError: error),
      'wrong-password' => WrongPasswordException(originalError: error),
      'invalid-email' => InvalidEmailException(originalError: error),
      'email-already-in-use' => EmailAlreadyInUseException(
        originalError: error,
      ),
      'weak-password' => WeakPasswordException(originalError: error),
      'user-disabled' => UserDisabledException(originalError: error),
      'operation-not-allowed' => OperationNotAllowedException(
        originalError: error,
      ),
      'too-many-requests' => TooManyRequestsException(originalError: error),
      'network-request-failed' => UnknownAuthException(
        message: 'Erro de ligação. Verifique a sua internet',
        originalError: error,
      ),
      _ => UnknownAuthException(originalError: error),
    };
  }

  static SyncException mapFirestoreError(String code, [dynamic error]) {
    return switch (code) {
      'permission-denied' => PermissionDeniedException(originalError: error),
      'unavailable' => SyncFailedException(
        message: 'Serviço indisponível. Tente novamente',
        originalError: error,
      ),
      'not-found' => SyncFailedException(
        message: 'Dados não encontrados no servidor',
        originalError: error,
      ),
      _ => SyncFailedException(originalError: error),
    };
  }

  static AppException mapGenericError(dynamic error, [StackTrace? stackTrace]) {
    if (error is AppException) {
      return error;
    }

    return UnknownException(
      message: error?.toString() ?? 'Erro desconhecido',
      originalError: error,
      stackTrace: stackTrace,
    );
  }
}
