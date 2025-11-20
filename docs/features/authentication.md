# 🔐 Feature: Autenticação - Expense Control APP

## Objetivo

Implementar sistema completo de autenticação de usuários utilizando **Firebase Authentication**, permitindo login, registro, recuperação de senha e persistência de sessão.

---

## Requisitos Funcionais

### RF01 - Login de Usuário
- ✅ Autenticação com email e senha
- ✅ Validação de campos obrigatórios
- ✅ Mensagens de erro personalizadas
- ✅ Loading state durante autenticação
- ✅ Redirecionamento após login bem-sucedido

### RF02 - Registro de Nova Conta
- ✅ Criação de conta com email e senha
- ✅ Confirmação de senha
- ✅ Validações em tempo real
- ✅ Criação de categorias padrão após registro
- ✅ Feedback visual de sucesso

### RF03 - Recuperação de Senha
- ✅ Envio de email para reset
- ✅ Validação de email existente
- ✅ Confirmação de envio

### RF04 - Logout
- ✅ Encerramento de sessão
- ✅ Limpeza de dados locais sensíveis
- ✅ Redirecionamento para tela de login

### RF05 - Persistência de Sessão
- ✅ Manutenção de login entre sessões
- ✅ Verificação automática ao iniciar app
- ✅ Refresh token automático

---

## Validações

### Email
```dart
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email é obrigatório';
  }
  
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Email inválido';
  }
  
  return null;
}
```

**Regras:**
- Campo obrigatório
- Formato válido: `usuario@dominio.com`

---

### Senha
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

**Regras:**
- Mínimo 8 caracteres
- Pelo menos 1 letra maiúscula
- Pelo menos 1 número
- Campo obrigatório

---

### Confirmação de Senha
```dart
String? validateConfirmPassword(String? value, String password) {
  if (value == null || value.isEmpty) {
    return 'Confirmação de senha é obrigatória';
  }
  
  if (value != password) {
    return 'As senhas não coincidem';
  }
  
  return null;
}
```

---

## Arquitetura MVVM

### 1. Model (Data Layer)

#### **UserModel**
```dart
class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.createdAt,
  });

  factory UserModel.fromFirebase(User firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email!,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
    );
  }
}
```

#### **AuthRepository**
```dart
abstract class AuthRepository {
  Stream<UserModel?> get authStateChanges;
  UserModel? get currentUser;
  Future<Either<AuthFailure, UserModel>> signIn(String email, String password);
  Future<Either<AuthFailure, UserModel>> signUp(String email, String password);
  Future<Either<AuthFailure, void>> resetPassword(String email);
  Future<void> signOut();
}
```

#### **AuthRepositoryImpl**
```dart
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Stream<UserModel?> get authStateChanges {
    return _authService.authStateChanges.map((user) {
      return user != null ? UserModel.fromFirebase(user) : null;
    });
  }

  @override
  UserModel? get currentUser {
    final user = _authService.currentUser;
    return user != null ? UserModel.fromFirebase(user) : null;
  }

  @override
  Future<Either<AuthFailure, UserModel>> signIn(
    String email,
    String password,
  ) async {
    final result = await _authService.signIn(email, password);
    return result.fold(
      (failure) => Left(failure),
      (user) => Right(UserModel.fromFirebase(user)),
    );
  }

  @override
  Future<Either<AuthFailure, UserModel>> signUp(
    String email,
    String password,
  ) async {
    final result = await _authService.signUp(email, password);
    return result.fold(
      (failure) => Left(failure),
      (user) async {
        // Criar categorias padrão
        await _createDefaultCategories(user.uid);
        return Right(UserModel.fromFirebase(user));
      },
    );
  }

  @override
  Future<Either<AuthFailure, void>> resetPassword(String email) async {
    return await _authService.resetPassword(email);
  }

  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<void> _createDefaultCategories(String userId) async {
    final defaultCategories = [
      CategoryModel(id: uuid.v4(), name: 'Alimentação', icon: '🍔', color: '#FF5733'),
      CategoryModel(id: uuid.v4(), name: 'Transporte', icon: '🚗', color: '#3498DB'),
      CategoryModel(id: uuid.v4(), name: 'Saúde', icon: '💊', color: '#2ECC71'),
      CategoryModel(id: uuid.v4(), name: 'Lazer', icon: '🎮', color: '#9B59B6'),
      CategoryModel(id: uuid.v4(), name: 'Outros', icon: '📦', color: '#95A5A6'),
    ];

    // Salvar no Drift
    for (final category in defaultCategories) {
      await categoryDao.insertCategory(category);
    }
  }
}
```

---

### 2. ViewModel (Presentation Logic)

#### **AuthViewModel**
```dart
class AuthState {
  final bool isLoading;
  final UserModel? user;
  final String? errorMessage;
  final bool isAuthenticated;

  AuthState({
    this.isLoading = false,
    this.user,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    bool? isLoading,
    UserModel? user,
    String? errorMessage,
    bool? isAuthenticated,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  AuthViewModel(
    this._loginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
    this._resetPasswordUseCase,
  ) : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _loginUseCase.call(email, password);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: _mapFailureToMessage(failure),
        );
      },
      (user) {
        state = state.copyWith(
          isLoading: false,
          user: user,
          isAuthenticated: true,
        );
      },
    );
  }

  Future<void> register(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _registerUseCase.call(email, password);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: _mapFailureToMessage(failure),
        );
      },
      (user) {
        state = state.copyWith(
          isLoading: false,
          user: user,
          isAuthenticated: true,
        );
      },
    );
  }

  Future<void> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _resetPasswordUseCase.call(email);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: _mapFailureToMessage(failure),
        );
      },
      (_) {
        state = state.copyWith(isLoading: false);
      },
    );
  }

  Future<void> logout() async {
    await _logoutUseCase.call();
    state = AuthState();
  }

  String _mapFailureToMessage(AuthFailure failure) {
    if (failure is InvalidEmailFailure) {
      return 'Email inválido';
    } else if (failure is WrongPasswordFailure) {
      return 'Senha incorreta';
    } else if (failure is UserNotFoundFailure) {
      return 'Utilizador não encontrado';
    } else if (failure is EmailAlreadyInUseFailure) {
      return 'Email já está em uso';
    } else if (failure is WeakPasswordFailure) {
      return 'Senha muito fraca';
    } else {
      return 'Erro ao autenticar. Tente novamente.';
    }
  }
}
```

---

### 3. View (UI Layer)

#### **LoginScreen**
```dart
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authViewModelProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.isAuthenticated) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
      
      if (next.errorMessage != null) {
        CustomSnackBar.showError(context, next.errorMessage!);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset('assets/images/logo.png', height: 100),
                const SizedBox(height: 16),
                
                // Branding
                Text(
                  'Expense Control',
                  style: TextStyles.h1,
                ),
                Text(
                  'by Leankar.dev',
                  style: TextStyles.caption,
                ),
                const SizedBox(height: 48),

                // Email Field
                NeumorphicTextFormField(
                  controller: _emailController,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 16),

                // Password Field
                NeumorphicTextFormField(
                  controller: _passwordController,
                  labelText: 'Palavra-passe',
                  obscureText: true,
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: 24),

                // Login Button
                CustomNeumorphicButton(
                  text: 'Entrar',
                  isLoading: authState.isLoading,
                  onPressed: _handleLogin,
                ),
                const SizedBox(height: 16),

                // Forgot Password
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.forgotPassword);
                  },
                  child: Text('Esqueceu a palavra-passe?'),
                ),
                
                // Register Link
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.register);
                  },
                  child: Text('Criar nova conta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## Testes

### Unit Test - AuthViewModel

```dart
void main() {
  late AuthViewModel viewModel;
  late MockLoginUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    viewModel = AuthViewModel(mockLoginUseCase, ...);
  });

  group('AuthViewModel', () {
    test('should set loading state when login is called', () {
      // Arrange
      when(mockLoginUseCase.call(any, any))
          .thenAnswer((_) async => Right(mockUser));

      // Act
      viewModel.login('test@test.com', 'Password123');

      // Assert
      expect(viewModel.state.isLoading, true);
    });

    test('should set user and authenticated when login succeeds', () async {
      // Arrange
      when(mockLoginUseCase.call(any, any))
          .thenAnswer((_) async => Right(mockUser));

      // Act
      await viewModel.login('test@test.com', 'Password123');

      // Assert
      expect(viewModel.state.isAuthenticated, true);
      expect(viewModel.state.user, mockUser);
      expect(viewModel.state.isLoading, false);
    });

    test('should set error message when login fails', () async {
      // Arrange
      when(mockLoginUseCase.call(any, any))
          .thenAnswer((_) async => Left(WrongPasswordFailure()));

      // Act
      await viewModel.login('test@test.com', 'wrongpass');

      // Assert
      expect(viewModel.state.isAuthenticated, false);
      expect(viewModel.state.errorMessage, 'Senha incorreta');
    });
  });
}
```

---

## Boas Práticas

### ✅ **1. Separação de Responsabilidades**
- Service: Comunicação com Firebase
- Repository: Lógica de acesso a dados
- UseCase: Regras de negócio
- ViewModel: Lógica de apresentação
- View: UI apenas

### ✅ **2. Error Handling**
- Exceções customizadas (`AuthFailure`)
- Mensagens de erro amigáveis
- Feedback visual imediato

### ✅ **3. Validação**
- Validação em tempo real
- Mensagens claras
- Prevenção de submissões inválidas

### ✅ **4. UX/UI**
- Loading states
- Animações suaves
- Feedback via SnackBar
- Branding consistente

---

**Desenvolvido por:** Leankar.dev  
**Versão:** 1.0.0  
**Contato:** leankar.dev@gmail.com