/// Classe utilitária com validadores para formulários.
/// Todas as mensagens estão em Português (Portugal).
abstract final class Validators {
  /// Regex para validação de email
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
  );

  /// Regex para validação de senha (mínimo 8 caracteres, 1 maiúscula, 1 número)
  static final RegExp _passwordUppercaseRegex = RegExp(r'[A-Z]');
  static final RegExp _passwordNumberRegex = RegExp(r'[0-9]');

  /// Regex para validação de números inteiros
  static final RegExp _integerRegex = RegExp(r'^\d+$');

  /// Regex para validação de números decimais
  static final RegExp _decimalRegex = RegExp(r'^\d+([.,]\d+)?$');

  /// Valida o campo de email
  /// Retorna null se válido, ou mensagem de erro se inválido
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'O email é obrigatório';
    }

    final trimmedValue = value.trim();

    if (!_emailRegex.hasMatch(trimmedValue)) {
      return 'Introduza um email válido';
    }

    return null;
  }

  /// Valida o campo de senha
  /// Requisitos: mínimo 8 caracteres, 1 maiúscula, 1 número
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'A palavra-passe é obrigatória';
    }

    if (value.length < 8) {
      return 'A palavra-passe deve ter no mínimo 8 caracteres';
    }

    if (!_passwordUppercaseRegex.hasMatch(value)) {
      return 'A palavra-passe deve ter pelo menos 1 letra maiúscula';
    }

    if (!_passwordNumberRegex.hasMatch(value)) {
      return 'A palavra-passe deve ter pelo menos 1 número';
    }

    return null;
  }

  /// Valida a confirmação de senha
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'A confirmação de palavra-passe é obrigatória';
    }

    if (value != password) {
      return 'As palavras-passe não coincidem';
    }

    return null;
  }

  /// Valida senha para login (menos restritivo, apenas verifica se não está vazio)
  static String? validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'A palavra-passe é obrigatória';
    }

    return null;
  }

  /// Valida o valor monetário (amount)
  /// Deve ser maior que zero
  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'O valor é obrigatório';
    }

    final cleanValue = value.trim().replaceAll(',', '.');
    final amount = double.tryParse(cleanValue);

    if (amount == null) {
      return 'Introduza um valor válido';
    }

    if (amount <= 0) {
      return 'O valor deve ser maior que zero';
    }

    if (amount > 999999999.99) {
      return 'O valor é demasiado elevado';
    }

    return null;
  }

  /// Valida a descrição da transação
  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'A descrição é obrigatória';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < 3) {
      return 'A descrição deve ter no mínimo 3 caracteres';
    }

    if (trimmedValue.length > 200) {
      return 'A descrição deve ter no máximo 200 caracteres';
    }

    return null;
  }

  /// Valida a seleção de categoria
  static String? validateCategory(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Selecione uma categoria';
    }

    return null;
  }

  /// Valida a seleção de data
  static String? validateDate(DateTime? value) {
    if (value == null) {
      return 'Selecione uma data';
    }

    // Não permite datas futuras
    if (value.isAfter(DateTime.now())) {
      return 'A data não pode ser no futuro';
    }

    // Não permite datas muito antigas (mais de 10 anos)
    final tenYearsAgo = DateTime.now().subtract(const Duration(days: 3650));
    if (value.isBefore(tenYearsAgo)) {
      return 'A data é demasiado antiga';
    }

    return null;
  }

  /// Valida a seleção de método de pagamento
  static String? validatePaymentMethod(dynamic value) {
    if (value == null) {
      return 'Selecione um método de pagamento';
    }

    return null;
  }

  /// Valida a seleção de tipo de transação
  static String? validateTransactionType(dynamic value) {
    if (value == null) {
      return 'Selecione o tipo de transação';
    }

    return null;
  }

  /// Valida o nome da categoria
  static String? validateCategoryName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'O nome da categoria é obrigatório';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < 2) {
      return 'O nome deve ter no mínimo 2 caracteres';
    }

    if (trimmedValue.length > 50) {
      return 'O nome deve ter no máximo 50 caracteres';
    }

    return null;
  }

  /// Valida o limite de orçamento da categoria
  static String? validateBudgetLimit(String? value) {
    // Campo opcional, se vazio é válido
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final cleanValue = value.trim().replaceAll(',', '.');
    final limit = double.tryParse(cleanValue);

    if (limit == null) {
      return 'Introduza um valor válido';
    }

    if (limit < 0) {
      return 'O limite não pode ser negativo';
    }

    if (limit > 999999999.99) {
      return 'O limite é demasiado elevado';
    }

    return null;
  }

  /// Valida a cor da categoria (formato hexadecimal)
  static String? validateColor(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Selecione uma cor';
    }

    final trimmedValue = value.trim();

    // Verifica formato #RRGGBB ou RRGGBB
    final colorRegex = RegExp(r'^#?([A-Fa-f0-9]{6})$');
    if (!colorRegex.hasMatch(trimmedValue)) {
      return 'Cor inválida';
    }

    return null;
  }

  /// Valida se o campo não está vazio
  static String? validateRequired(String? value, [String fieldName = 'Campo']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }

    return null;
  }

  /// Valida o comprimento mínimo
  static String? validateMinLength(
    String? value,
    int minLength, [
    String fieldName = 'Campo',
  ]) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }

    if (value.trim().length < minLength) {
      return '$fieldName deve ter no mínimo $minLength caracteres';
    }

    return null;
  }

  /// Valida o comprimento máximo
  static String? validateMaxLength(
    String? value,
    int maxLength, [
    String fieldName = 'Campo',
  ]) {
    if (value != null && value.trim().length > maxLength) {
      return '$fieldName deve ter no máximo $maxLength caracteres';
    }

    return null;
  }

  /// Valida número inteiro
  static String? validateInteger(String? value, [String fieldName = 'Valor']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }

    if (!_integerRegex.hasMatch(value.trim())) {
      return 'Introduza um número inteiro válido';
    }

    return null;
  }

  /// Valida número decimal
  static String? validateDecimal(String? value, [String fieldName = 'Valor']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }

    final cleanValue = value.trim().replaceAll(',', '.');
    if (!_decimalRegex.hasMatch(cleanValue)) {
      return 'Introduza um número válido';
    }

    return null;
  }

  /// Valida se o valor está dentro de um intervalo
  static String? validateRange(
    String? value, {
    required double min,
    required double max,
    String fieldName = 'Valor',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }

    final cleanValue = value.trim().replaceAll(',', '.');
    final number = double.tryParse(cleanValue);

    if (number == null) {
      return 'Introduza um número válido';
    }

    if (number < min || number > max) {
      return '$fieldName deve estar entre $min e $max';
    }

    return null;
  }

  /// Verifica se o email é válido (retorna bool)
  static bool isValidEmail(String? value) {
    return validateEmail(value) == null;
  }

  /// Verifica se a senha é válida (retorna bool)
  static bool isValidPassword(String? value) {
    return validatePassword(value) == null;
  }

  /// Verifica se o valor monetário é válido (retorna bool)
  static bool isValidAmount(String? value) {
    return validateAmount(value) == null;
  }

  /// Combina múltiplos validadores
  /// Retorna o primeiro erro encontrado ou null se todos passarem
  static String? combine(List<String? Function()> validators) {
    for (final validator in validators) {
      final result = validator();
      if (result != null) {
        return result;
      }
    }
    return null;
  }
}
