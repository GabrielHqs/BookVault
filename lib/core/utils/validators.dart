import '../constants/app_strings.dart';

/// Validadores reutilizáveis dos formulários.
class Validators {
  const Validators._();

  static final RegExp _padraoEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? obrigatorio(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return AppStrings.erroCampoObrigatorio;
    }
    return null;
  }

  static String? texto(String? valor) {
    final erro = obrigatorio(valor);
    if (erro != null) return erro;
    final tamanho = valor!.trim().length;
    if (tamanho < 2) return AppStrings.erroTamanhoMinimo;
    if (tamanho > 100) return AppStrings.erroTamanhoMaximo;
    return null;
  }

  static String? email(String? valor) {
    final erro = obrigatorio(valor);
    if (erro != null) return erro;
    if (!_padraoEmail.hasMatch(valor!.trim())) {
      return AppStrings.erroEmailInvalido;
    }
    return null;
  }

  static String? senha(String? valor) {
    final erro = obrigatorio(valor);
    if (erro != null) return erro;
    if (valor!.length < 6) return AppStrings.erroSenhaCurta;
    return null;
  }

  /// Retorna um validador que compara o campo com a senha digitada.
  static String? Function(String?) confirmacaoSenha(String Function() senha) {
    return (valor) {
      final erro = obrigatorio(valor);
      if (erro != null) return erro;
      if (valor != senha()) return AppStrings.erroSenhasDiferentes;
      return null;
    };
  }
}
