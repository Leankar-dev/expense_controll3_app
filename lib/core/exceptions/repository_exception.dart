class RepositoryException implements Exception {
  final String message;
  final Object? originalError;
  final String? code;
  final StackTrace? stackTrace;

  RepositoryException(
    this.message, {
    this.originalError,
    this.code,
    this.stackTrace,
  });

  @override
  String toString() {
    if (originalError != null) {
      return 'RepositoryException: $message\nOriginal error: $originalError';
    }
    return 'RepositoryException: $message';
  }
}
