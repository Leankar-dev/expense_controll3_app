import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import '../../../core/exceptions/base_exception.dart';
import '../../models/user_model.dart';

/// Serviço responsável pela autenticação de usuários usando Firebase Authentication
///
/// Este serviço encapsula toda a lógica de autenticação da aplicação, incluindo:
/// - Login com email e senha
/// - Registro de novos usuários
/// - Logout
/// - Recuperação de senha
/// - Monitoramento do estado de autenticação
/// - Atualização de perfil do usuário
///
/// Utiliza o padrão Either do pacote dartz para tratamento de erros,
/// retornando Left(AuthException) em caso de erro ou Right(resultado) em caso de sucesso.
class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;

  /// Construtor do serviço de autenticação
  ///
  /// [_firebaseAuth] - Instância do FirebaseAuth para operações de autenticação
  FirebaseAuthService(this._firebaseAuth);

  /// Stream que monitora o estado de autenticação do usuário
  ///
  /// Emite um novo UserModel sempre que o estado de autenticação muda:
  /// - Quando o usuário faz login
  /// - Quando o usuário faz logout
  /// - Quando os dados do usuário são atualizados
  ///
  /// Retorna null quando não há usuário autenticado
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) return null;
      return UserModel.fromFirebaseUser(firebaseUser);
    });
  }

  /// Retorna o usuário atualmente autenticado
  ///
  /// Retorna null se não houver usuário autenticado
  UserModel? get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;
    return UserModel.fromFirebaseUser(firebaseUser);
  }

  /// Verifica se existe um usuário autenticado
  bool get isAuthenticated => _firebaseAuth.currentUser != null;

  /// Realiza login com email e senha
  ///
  /// [email] - Email do usuário
  /// [password] - Senha do usuário
  ///
  /// Retorna:
  /// - Right(UserModel) em caso de sucesso
  /// - Left(AuthException) em caso de erro:
  ///   - UserNotFoundException: quando o email não está cadastrado
  ///   - WrongPasswordException: quando a senha está incorreta
  ///   - InvalidEmailException: quando o formato do email é inválido
  ///   - UserDisabledException: quando a conta foi desativada
  ///   - TooManyRequestsException: quando há muitas tentativas de login
  ///   - GenericAuthException: para outros erros
  Future<Either<AuthException, UserModel>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Tenta fazer login com as credenciais fornecidas
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Verifica se o usuário foi autenticado
      if (userCredential.user == null) {
        return Left(
          UserNotFoundException(
            message: 'Erro ao autenticar usuário',
            code: 'user-not-found',
          ),
        );
      }

      // Converte o usuário do Firebase para o modelo da aplicação
      final user = UserModel.fromFirebaseUser(userCredential.user!);
      return Right(user.updateLastLogin());
    } on FirebaseAuthException catch (e, stackTrace) {
      // Trata erros específicos do Firebase Authentication
      return Left(_handleFirebaseAuthException(e, stackTrace));
    } catch (e, stackTrace) {
      // Trata erros genéricos
      return Left(
        UnknownAuthException(
          message: 'Erro ao fazer login: ${e.toString()}',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Registra um novo usuário com email e senha
  ///
  /// [email] - Email do novo usuário
  /// [password] - Senha do novo usuário
  /// [displayName] - Nome de exibição do usuário (opcional)
  ///
  /// Retorna:
  /// - Right(UserModel) em caso de sucesso
  /// - Left(AuthException) em caso de erro:
  ///   - EmailAlreadyInUseException: quando o email já está cadastrado
  ///   - WeakPasswordException: quando a senha é muito fraca
  ///   - InvalidEmailException: quando o formato do email é inválido
  ///   - OperationNotAllowedException: quando o registro está desativado
  ///   - GenericAuthException: para outros erros
  Future<Either<AuthException, UserModel>> registerWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      // Cria uma nova conta de usuário
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Verifica se o usuário foi criado
      if (userCredential.user == null) {
        return Left(
          UnknownAuthException(
            message: 'Erro ao criar usuário',
            code: 'user-creation-failed',
          ),
        );
      }

      // Atualiza o nome de exibição se fornecido
      if (displayName != null && displayName.isNotEmpty) {
        await userCredential.user!.updateDisplayName(displayName.trim());
        await userCredential.user!.reload();
      }

      // Envia email de verificação
      await userCredential.user!.sendEmailVerification();

      // Obtém o usuário atualizado
      final updatedUser = _firebaseAuth.currentUser;
      if (updatedUser == null) {
        return Left(
          UnknownAuthException(
            message: 'Erro ao obter dados do usuário criado',
            code: 'user-not-found',
          ),
        );
      }

      // Converte para o modelo da aplicação
      final user = UserModel.fromFirebaseUser(updatedUser);
      return Right(user);
    } on FirebaseAuthException catch (e, stackTrace) {
      // Trata erros específicos do Firebase Authentication
      return Left(_handleFirebaseAuthException(e, stackTrace));
    } catch (e, stackTrace) {
      // Trata erros genéricos
      return Left(
        UnknownAuthException(
          message: 'Erro ao registrar usuário: ${e.toString()}',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Realiza logout do usuário atual
  ///
  /// Retorna:
  /// - Right(void) em caso de sucesso
  /// - Left(AuthException) em caso de erro
  Future<Either<AuthException, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return const Right(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      return Left(_handleFirebaseAuthException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left(
        UnknownAuthException(
          message: 'Erro ao fazer logout: ${e.toString()}',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Envia email de recuperação de senha
  ///
  /// [email] - Email do usuário que esqueceu a senha
  ///
  /// Retorna:
  /// - Right(void) em caso de sucesso
  /// - Left(AuthException) em caso de erro:
  ///   - UserNotFoundException: quando o email não está cadastrado
  ///   - InvalidEmailException: quando o formato do email é inválido
  ///   - GenericAuthException: para outros erros
  Future<Either<AuthException, void>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      return const Right(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      return Left(_handleFirebaseAuthException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left(
        UnknownAuthException(
          message: 'Erro ao enviar email de recuperação: ${e.toString()}',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Reenvia email de verificação para o usuário atual
  ///
  /// Retorna:
  /// - Right(void) em caso de sucesso
  /// - Left(AuthException) em caso de erro:
  ///   - UserNotFoundException: quando não há usuário autenticado
  ///   - TooManyRequestsException: quando há muitas tentativas
  ///   - GenericAuthException: para outros erros
  Future<Either<AuthException, void>> sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return Left(
          UserNotFoundException(
            message: 'Nenhum usuário autenticado',
          ),
        );
      }

      await user.sendEmailVerification();
      return const Right(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      return Left(_handleFirebaseAuthException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left(
        UnknownAuthException(
          message: 'Erro ao enviar email de verificação: ${e.toString()}',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Recarrega os dados do usuário atual
  ///
  /// Útil para verificar se o email foi verificado ou se houve
  /// atualizações no perfil do usuário.
  ///
  /// Retorna:
  /// - Right(UserModel) em caso de sucesso
  /// - Left(AuthException) em caso de erro
  Future<Either<AuthException, UserModel>> reloadUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return Left(
          UserNotFoundException(
            message: 'Nenhum usuário autenticado',
          ),
        );
      }

      await user.reload();
      final updatedUser = _firebaseAuth.currentUser;

      if (updatedUser == null) {
        return Left(
          UserNotFoundException(
            message: 'Erro ao recarregar dados do usuário',
          ),
        );
      }

      return Right(UserModel.fromFirebaseUser(updatedUser));
    } on FirebaseAuthException catch (e, stackTrace) {
      return Left(_handleFirebaseAuthException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left(
        UnknownAuthException(
          message: 'Erro ao recarregar usuário: ${e.toString()}',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Atualiza o nome de exibição do usuário atual
  ///
  /// [displayName] - Novo nome de exibição
  ///
  /// Retorna:
  /// - Right(UserModel) com os dados atualizados em caso de sucesso
  /// - Left(AuthException) em caso de erro
  Future<Either<AuthException, UserModel>> updateDisplayName({
    required String displayName,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return Left(
          UserNotFoundException(
            message: 'Nenhum usuário autenticado',
          ),
        );
      }

      await user.updateDisplayName(displayName.trim());
      await user.reload();

      final updatedUser = _firebaseAuth.currentUser;
      if (updatedUser == null) {
        return Left(
          UserNotFoundException(
            message: 'Erro ao atualizar nome de exibição',
          ),
        );
      }

      return Right(UserModel.fromFirebaseUser(updatedUser));
    } on FirebaseAuthException catch (e, stackTrace) {
      return Left(_handleFirebaseAuthException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left(
        UnknownAuthException(
          message: 'Erro ao atualizar nome: ${e.toString()}',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Atualiza a URL da foto do perfil do usuário atual
  ///
  /// [photoUrl] - URL da nova foto de perfil
  ///
  /// Retorna:
  /// - Right(UserModel) com os dados atualizados em caso de sucesso
  /// - Left(AuthException) em caso de erro
  Future<Either<AuthException, UserModel>> updatePhotoUrl({
    required String photoUrl,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return Left(
          UserNotFoundException(
            message: 'Nenhum usuário autenticado',
          ),
        );
      }

      await user.updatePhotoURL(photoUrl.trim());
      await user.reload();

      final updatedUser = _firebaseAuth.currentUser;
      if (updatedUser == null) {
        return Left(
          UserNotFoundException(
            message: 'Erro ao atualizar foto de perfil',
          ),
        );
      }

      return Right(UserModel.fromFirebaseUser(updatedUser));
    } on FirebaseAuthException catch (e, stackTrace) {
      return Left(_handleFirebaseAuthException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left(
        UnknownAuthException(
          message: 'Erro ao atualizar foto: ${e.toString()}',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Atualiza a senha do usuário atual
  ///
  /// [newPassword] - Nova senha do usuário
  ///
  /// Nota: O usuário precisa ter feito login recentemente para esta operação.
  /// Se o login for antigo, será necessário reautenticar.
  ///
  /// Retorna:
  /// - Right(void) em caso de sucesso
  /// - Left(AuthException) em caso de erro:
  ///   - UserNotFoundException: quando não há usuário autenticado
  ///   - WeakPasswordException: quando a senha é muito fraca
  ///   - SessionExpiredException: quando é necessário reautenticar
  ///   - GenericAuthException: para outros erros
  Future<Either<AuthException, void>> updatePassword({
    required String newPassword,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return Left(
          UserNotFoundException(
            message: 'Nenhum usuário autenticado',
          ),
        );
      }

      await user.updatePassword(newPassword);
      return const Right(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      return Left(_handleFirebaseAuthException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left(
        UnknownAuthException(
          message: 'Erro ao atualizar senha: ${e.toString()}',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Reautentica o usuário com suas credenciais atuais
  ///
  /// Necessário antes de operações sensíveis como:
  /// - Atualizar senha
  /// - Atualizar email
  /// - Excluir conta
  ///
  /// [email] - Email do usuário
  /// [password] - Senha atual do usuário
  ///
  /// Retorna:
  /// - Right(void) em caso de sucesso
  /// - Left(AuthException) em caso de erro
  Future<Either<AuthException, void>> reauthenticateWithCredential({
    required String email,
    required String password,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return Left(
          UserNotFoundException(
            message: 'Nenhum usuário autenticado',
          ),
        );
      }

      final credential = EmailAuthProvider.credential(
        email: email.trim(),
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      return const Right(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      return Left(_handleFirebaseAuthException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left(
        UnknownAuthException(
          message: 'Erro ao reautenticar: ${e.toString()}',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Exclui a conta do usuário atual
  ///
  /// Nota: Esta operação é irreversível e requer autenticação recente.
  /// O usuário deve reautenticar antes de chamar este método.
  ///
  /// Retorna:
  /// - Right(void) em caso de sucesso
  /// - Left(AuthException) em caso de erro:
  ///   - UserNotFoundException: quando não há usuário autenticado
  ///   - SessionExpiredException: quando é necessário reautenticar
  ///   - GenericAuthException: para outros erros
  Future<Either<AuthException, void>> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return Left(
          UserNotFoundException(
            message: 'Nenhum usuário autenticado',
          ),
        );
      }

      await user.delete();
      return const Right(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      return Left(_handleFirebaseAuthException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left(
        UnknownAuthException(
          message: 'Erro ao excluir conta: ${e.toString()}',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Método auxiliar para tratar exceções do Firebase Authentication
  ///
  /// Converte os códigos de erro do Firebase em exceções específicas
  /// da aplicação para melhor tratamento e mensagens de erro.
  ///
  /// [e] - Exceção do Firebase
  /// [stackTrace] - Stack trace do erro
  ///
  /// Retorna a exceção apropriada baseada no código de erro
  AuthException _handleFirebaseAuthException(
    FirebaseAuthException e,
    StackTrace stackTrace,
  ) {
    switch (e.code) {
      case 'user-not-found':
        return UserNotFoundException(
          originalError: e,
          stackTrace: stackTrace,
        );
      case 'wrong-password':
        return WrongPasswordException(
          originalError: e,
          stackTrace: stackTrace,
        );
      case 'invalid-email':
        return InvalidEmailException(
          originalError: e,
          stackTrace: stackTrace,
        );
      case 'email-already-in-use':
        return EmailAlreadyInUseException(
          originalError: e,
          stackTrace: stackTrace,
        );
      case 'weak-password':
        return WeakPasswordException(
          originalError: e,
          stackTrace: stackTrace,
        );
      case 'user-disabled':
        return UserDisabledException(
          originalError: e,
          stackTrace: stackTrace,
        );
      case 'operation-not-allowed':
        return OperationNotAllowedException(
          originalError: e,
          stackTrace: stackTrace,
        );
      case 'too-many-requests':
        return TooManyRequestsException(
          originalError: e,
          stackTrace: stackTrace,
        );
      case 'requires-recent-login':
        return SessionExpiredException(
          message: 'É necessário fazer login novamente para esta operação',
          code: e.code,
          originalError: e,
          stackTrace: stackTrace,
        );
      default:
        return UnknownAuthException(
          message: e.message ?? 'Erro de autenticação desconhecido',
          code: e.code,
          originalError: e,
          stackTrace: stackTrace,
        );
    }
  }
}
