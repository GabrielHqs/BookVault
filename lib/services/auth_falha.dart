/// Erro de autenticação já com mensagem pronta para exibir.
class AuthFalha implements Exception {
  const AuthFalha(this.mensagem);

  final String mensagem;
}
