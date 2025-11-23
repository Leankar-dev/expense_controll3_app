import 'dart:io';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../core/exceptions/base_exception.dart';

/// Serviço responsável pelo gerenciamento de arquivos no Firebase Storage
///
/// Este serviço encapsula toda a lógica de armazenamento de arquivos, incluindo:
/// - Upload de imagens (perfil, comprovantes, etc)
/// - Download de arquivos
/// - Exclusão de arquivos
/// - Listagem de arquivos
/// - Obtenção de URLs de download
/// - Gerenciamento de metadados
///
/// Utiliza o padrão Either do pacote dartz para tratamento de erros,
/// retornando Left(AppException) em caso de erro ou Right(resultado) em caso de sucesso.
class FirebaseStorageService {
  final FirebaseStorage _storage;

  /// Construtor do serviço de armazenamento
  ///
  /// [_storage] - Instância do FirebaseStorage para operações de armazenamento
  FirebaseStorageService(this._storage);

  /// Caminhos padrão para organização de arquivos no Storage
  static const String _userProfilesPath = 'users/profiles';
  static const String _transactionReceiptsPath = 'transactions/receipts';
  static const String _exportsPath = 'exports';
  // Reservado para uso futuro
  // static const String _backupsPath = 'backups';

  /// Faz upload de uma foto de perfil do usuário
  ///
  /// [userId] - ID do usuário
  /// [file] - Arquivo da imagem
  ///
  /// O arquivo será salvo no caminho: users/profiles/{userId}/profile.jpg
  ///
  /// Retorna:
  /// - Right(String) com a URL de download em caso de sucesso
  /// - Left(AppException) em caso de erro
  Future<Either<AppException, String>> uploadProfileImage({
    required String userId,
    required File file,
  }) async {
    try {
      // Valida o arquivo
      final validation = _validateImageFile(file);
      if (validation != null) {
        return Left(validation);
      }

      // Define o caminho do arquivo no Storage
      final path = '$_userProfilesPath/$userId/profile.jpg';

      // Faz o upload
      return await _uploadFile(
        file: file,
        path: path,
        contentType: 'image/jpeg',
      );
    } on FirebaseException catch (e, stackTrace) {
      return Left(_handleFirebaseException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left(
        UnknownAuthException(
          message: 'Erro ao fazer upload da foto de perfil: ${e.toString()}',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Faz upload de um comprovante de transação
  ///
  /// [userId] - ID do usuário
  /// [transactionId] - ID da transação
  /// [file] - Arquivo do comprovante
  ///
  /// O arquivo será salvo no caminho: transactions/receipts/{userId}/{transactionId}/{timestamp}.jpg
  ///
  /// Retorna:
  /// - Right(String) com a URL de download em caso de sucesso
  /// - Left(AppException) em caso de erro
  Future<Either<AppException, String>> uploadTransactionReceipt({
    required String userId,
    required String transactionId,
    required File file,
  }) async {
    try {
      // Valida o arquivo
      final validation = _validateImageFile(file);
      if (validation != null) {
        return Left(validation);
      }

      // Gera um nome único para o arquivo
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = _getFileExtension(file.path);
      final fileName = '$timestamp$extension';

      // Define o caminho do arquivo no Storage
      final path = '$_transactionReceiptsPath/$userId/$transactionId/$fileName';

      // Faz o upload
      return await _uploadFile(
        file: file,
        path: path,
        contentType: _getContentType(extension),
      );
    } on FirebaseException catch (e, stackTrace) {
      return Left(_handleFirebaseException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left(
        UnknownAuthException(
          message: 'Erro ao fazer upload do comprovante: ${e.toString()}',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Faz upload de um arquivo de exportação (CSV, PDF, Excel)
  ///
  /// [userId] - ID do usuário
  /// [file] - Arquivo de exportação
  /// [fileName] - Nome do arquivo
  ///
  /// O arquivo será salvo no caminho: exports/{userId}/{fileName}
  ///
  /// Retorna:
  /// - Right(String) com a URL de download em caso de sucesso
  /// - Left(AppException) em caso de erro
  Future<Either<AppException, String>> uploadExport({
    required String userId,
    required File file,
    required String fileName,
  }) async {
    try {
      // Valida o tamanho do arquivo (máximo 50MB para exportações)
      final validation = _validateFileSize(file, maxSizeMB: 50);
      if (validation != null) {
        return Left(validation);
      }

      // Define o caminho do arquivo no Storage
      final path = '$_exportsPath/$userId/$fileName';

      // Determina o tipo de conteúdo baseado na extensão
      final extension = _getFileExtension(fileName);
      final contentType = _getContentType(extension);

      // Faz o upload
      return await _uploadFile(
        file: file,
        path: path,
        contentType: contentType,
      );
    } on FirebaseException catch (e, stackTrace) {
      return Left(_handleFirebaseException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left(
        UnknownAuthException(
          message: 'Erro ao fazer upload da exportação: ${e.toString()}',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Faz upload de bytes (útil para arquivos gerados em memória)
  ///
  /// [userId] - ID do usuário (não usado diretamente, mas mantido para consistência)
  /// [data] - Dados do arquivo em bytes
  /// [path] - Caminho onde o arquivo será salvo
  /// [contentType] - Tipo MIME do conteúdo
  ///
  /// Retorna:
  /// - Right(String) com a URL de download em caso de sucesso
  /// - Left(AppException) em caso de erro
  Future<Either<AppException, String>> uploadBytes({
    required String userId,
    required Uint8List data,
    required String path,
    String contentType = 'application/octet-stream',
  }) async {
    try {
      // Valida o tamanho dos dados (máximo 10MB)
      if (data.lengthInBytes > 10 * 1024 * 1024) {
        return Left(
          InvalidValueException(
            message: 'O arquivo é muito grande. Tamanho máximo: 10MB',
            code: 'file-too-large',
            field: 'data',
          ),
        );
      }

      final ref = _storage.ref(path);
      final uploadTask = ref.putData(
        data,
        SettableMetadata(contentType: contentType),
      );

      await uploadTask;
      final downloadUrl = await ref.getDownloadURL();
      return Right(downloadUrl);
    } on FirebaseException catch (e, stackTrace) {
      return Left(_handleFirebaseException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left(
        UnknownAuthException(
          message: 'Erro ao fazer upload: ${e.toString()}',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Baixa um arquivo do Storage
  ///
  /// [path] - Caminho do arquivo no Storage
  ///
  /// Retorna:
  /// - Right(Uint8List) com os dados do arquivo em caso de sucesso
  /// - Left(AppException) em caso de erro
  Future<Either<AppException, Uint8List>> downloadFile({
    required String path,
  }) async {
    try {
      final ref = _storage.ref(path);

      // Verifica se o arquivo existe
      try {
        await ref.getMetadata();
      } on FirebaseException catch (e) {
        if (e.code == 'object-not-found') {
          return Left(
            NotFoundException(
              message: 'Arquivo não encontrado',
              code: 'file-not-found',
            ),
          );
        }
        rethrow;
      }

      // Baixa o arquivo (máximo 10MB)
      final data = await ref.getData(10 * 1024 * 1024);
      if (data == null) {
        return Left(
          UnknownAuthException(
            message: 'Erro ao baixar arquivo',
            code: 'download-failed',
          ),
        );
      }

      return Right(data);
    } on FirebaseException catch (e, stackTrace) {
      return Left(_handleFirebaseException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left(
        UnknownAuthException(
          message: 'Erro ao baixar arquivo: ${e.toString()}',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Obtém a URL de download de um arquivo
  ///
  /// [path] - Caminho do arquivo no Storage
  ///
  /// Retorna:
  /// - Right(String) com a URL de download em caso de sucesso
  /// - Left(AppException) em caso de erro
  Future<Either<AppException, String>> getDownloadUrl({
    required String path,
  }) async {
    try {
      final ref = _storage.ref(path);
      final url = await ref.getDownloadURL();
      return Right(url);
    } on FirebaseException catch (e, stackTrace) {
      return Left(_handleFirebaseException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left(
        UnknownAuthException(
          message: 'Erro ao obter URL de download: ${e.toString()}',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Exclui um arquivo do Storage
  ///
  /// [path] - Caminho do arquivo no Storage
  ///
  /// Retorna:
  /// - Right(void) em caso de sucesso
  /// - Left(AppException) em caso de erro
  Future<Either<AppException, void>> deleteFile({
    required String path,
  }) async {
    try {
      final ref = _storage.ref(path);
      await ref.delete();
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(_handleFirebaseException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left(
        UnknownAuthException(
          message: 'Erro ao excluir arquivo: ${e.toString()}',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Exclui todos os comprovantes de uma transação
  ///
  /// [userId] - ID do usuário
  /// [transactionId] - ID da transação
  ///
  /// Retorna:
  /// - Right(int) com o número de arquivos excluídos em caso de sucesso
  /// - Left(AppException) em caso de erro
  Future<Either<AppException, int>> deleteTransactionReceipts({
    required String userId,
    required String transactionId,
  }) async {
    try {
      final path = '$_transactionReceiptsPath/$userId/$transactionId';
      final ref = _storage.ref(path);

      // Lista todos os arquivos na pasta
      final listResult = await ref.listAll();
      int deletedCount = 0;

      // Exclui cada arquivo
      for (final item in listResult.items) {
        try {
          await item.delete();
          deletedCount++;
        } catch (e) {
          // Ignora erros individuais e continua
        }
      }

      return Right(deletedCount);
    } on FirebaseException catch (e, stackTrace) {
      return Left(_handleFirebaseException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left(
        UnknownAuthException(
          message: 'Erro ao excluir comprovantes: ${e.toString()}',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Lista todos os comprovantes de uma transação
  ///
  /// [userId] - ID do usuário
  /// [transactionId] - ID da transação
  ///
  /// Retorna:
  /// - Right(List<String>) com as URLs dos comprovantes em caso de sucesso
  /// - Left(AppException) em caso de erro
  Future<Either<AppException, List<String>>> listTransactionReceipts({
    required String userId,
    required String transactionId,
  }) async {
    try {
      final path = '$_transactionReceiptsPath/$userId/$transactionId';
      final ref = _storage.ref(path);

      // Lista todos os arquivos na pasta
      final listResult = await ref.listAll();
      final urls = <String>[];

      // Obtém a URL de cada arquivo
      for (final item in listResult.items) {
        try {
          final url = await item.getDownloadURL();
          urls.add(url);
        } catch (e) {
          // Ignora erros individuais e continua
        }
      }

      return Right(urls);
    } on FirebaseException catch (e, stackTrace) {
      return Left(_handleFirebaseException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left(
        UnknownAuthException(
          message: 'Erro ao listar comprovantes: ${e.toString()}',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Obtém os metadados de um arquivo
  ///
  /// [path] - Caminho do arquivo no Storage
  ///
  /// Retorna:
  /// - Right(Map<String, dynamic>) com os metadados em caso de sucesso
  /// - Left(AppException) em caso de erro
  Future<Either<AppException, Map<String, dynamic>>> getMetadata({
    required String path,
  }) async {
    try {
      final ref = _storage.ref(path);
      final metadata = await ref.getMetadata();

      return Right({
        'name': metadata.name,
        'bucket': metadata.bucket,
        'fullPath': metadata.fullPath,
        'size': metadata.size,
        'contentType': metadata.contentType,
        'timeCreated': metadata.timeCreated?.toIso8601String(),
        'updated': metadata.updated?.toIso8601String(),
      });
    } on FirebaseException catch (e, stackTrace) {
      return Left(_handleFirebaseException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left(
        UnknownAuthException(
          message: 'Erro ao obter metadados: ${e.toString()}',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  // ========== MÉTODOS AUXILIARES PRIVADOS ==========

  /// Método auxiliar para fazer upload de um arquivo
  ///
  /// [file] - Arquivo a ser enviado
  /// [path] - Caminho de destino no Storage
  /// [contentType] - Tipo MIME do arquivo
  ///
  /// Retorna a URL de download em caso de sucesso
  Future<Either<AppException, String>> _uploadFile({
    required File file,
    required String path,
    required String contentType,
  }) async {
    try {
      final ref = _storage.ref(path);

      // Configura os metadados
      final metadata = SettableMetadata(
        contentType: contentType,
        customMetadata: {
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      // Faz o upload
      final uploadTask = ref.putFile(file, metadata);

      // Aguarda a conclusão
      await uploadTask;

      // Obtém a URL de download
      final downloadUrl = await ref.getDownloadURL();

      return Right(downloadUrl);
    } on FirebaseException catch (e, stackTrace) {
      return Left(_handleFirebaseException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left(
        UnknownAuthException(
          message: 'Erro ao fazer upload: ${e.toString()}',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Valida se um arquivo de imagem é válido
  ///
  /// Verifica:
  /// - Se o arquivo existe
  /// - Se o tamanho está dentro do limite (5MB)
  /// - Se a extensão é permitida
  ///
  /// Retorna uma exceção se houver erro, ou null se válido
  InvalidValueException? _validateImageFile(File file) {
    // Verifica se o arquivo existe
    if (!file.existsSync()) {
      return InvalidValueException(
        message: 'Arquivo não encontrado',
        code: 'file-not-found',
        field: 'file',
      );
    }

    // Verifica o tamanho (máximo 5MB para imagens)
    final sizeValidation = _validateFileSize(file, maxSizeMB: 5);
    if (sizeValidation != null) {
      return sizeValidation;
    }

    // Verifica a extensão
    final extension = _getFileExtension(file.path).toLowerCase();
    const allowedExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];

    if (!allowedExtensions.contains(extension)) {
      return InvalidValueException(
        message: 'Formato de imagem não suportado. Use: JPG, PNG, GIF ou WebP',
        code: 'invalid-image-format',
        field: 'file',
      );
    }

    return null;
  }

  /// Valida o tamanho de um arquivo
  ///
  /// [file] - Arquivo a ser validado
  /// [maxSizeMB] - Tamanho máximo em megabytes
  ///
  /// Retorna uma exceção se o arquivo for muito grande, ou null se válido
  InvalidValueException? _validateFileSize(
    File file, {
    required int maxSizeMB,
  }) {
    final sizeInBytes = file.lengthSync();
    final maxSizeInBytes = maxSizeMB * 1024 * 1024;

    if (sizeInBytes > maxSizeInBytes) {
      return InvalidValueException(
        message: 'O arquivo é muito grande. Tamanho máximo: ${maxSizeMB}MB',
        code: 'file-too-large',
        field: 'file',
      );
    }

    return null;
  }

  /// Obtém a extensão de um arquivo
  ///
  /// [path] - Caminho do arquivo
  ///
  /// Retorna a extensão com o ponto (ex: ".jpg")
  String _getFileExtension(String path) {
    final lastDotIndex = path.lastIndexOf('.');
    if (lastDotIndex == -1) return '';
    return path.substring(lastDotIndex).toLowerCase();
  }

  /// Determina o tipo MIME baseado na extensão do arquivo
  ///
  /// [extension] - Extensão do arquivo (com ponto)
  ///
  /// Retorna o tipo MIME apropriado
  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      // Imagens
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.svg':
        return 'image/svg+xml';

      // Documentos
      case '.pdf':
        return 'application/pdf';
      case '.doc':
        return 'application/msword';
      case '.docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case '.xls':
        return 'application/vnd.ms-excel';
      case '.xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case '.csv':
        return 'text/csv';
      case '.txt':
        return 'text/plain';

      // Outros
      case '.json':
        return 'application/json';
      case '.xml':
        return 'application/xml';
      case '.zip':
        return 'application/zip';

      default:
        return 'application/octet-stream';
    }
  }

  /// Método auxiliar para tratar exceções do Firebase Storage
  ///
  /// Converte os códigos de erro do Firebase em exceções específicas
  /// da aplicação para melhor tratamento e mensagens de erro.
  ///
  /// [e] - Exceção do Firebase
  /// [stackTrace] - Stack trace do erro
  ///
  /// Retorna a exceção apropriada baseada no código de erro
  AppException _handleFirebaseException(
    FirebaseException e,
    StackTrace stackTrace,
  ) {
    switch (e.code) {
      case 'object-not-found':
        return NotFoundException(
          message: 'Arquivo não encontrado',
          code: e.code,
          originalError: e,
          stackTrace: stackTrace,
        );
      case 'unauthorized':
      case 'unauthenticated':
        return UnauthenticatedException(
          message: 'Você não tem permissão para acessar este arquivo',
          code: e.code,
          originalError: e,
          stackTrace: stackTrace,
        );
      case 'canceled':
        return UnknownAuthException(
          message: 'Upload cancelado',
          code: e.code,
          originalError: e,
          stackTrace: stackTrace,
        );
      case 'quota-exceeded':
        return UnknownAuthException(
          message: 'Cota de armazenamento excedida',
          code: e.code,
          originalError: e,
          stackTrace: stackTrace,
        );
      case 'retry-limit-exceeded':
        return UnknownAuthException(
          message: 'Limite de tentativas excedido. Tente novamente mais tarde',
          code: e.code,
          originalError: e,
          stackTrace: stackTrace,
        );
      default:
        return UnknownAuthException(
          message: e.message ?? 'Erro de armazenamento desconhecido',
          code: e.code,
          originalError: e,
          stackTrace: stackTrace,
        );
    }
  }
}
