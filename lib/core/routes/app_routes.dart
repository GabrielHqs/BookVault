/// Nomes usados em `context.goNamed(...)`.
class RouteNames {
  const RouteNames._();

  static const String login = 'login';
  static const String registro = 'registro';
  static const String home = 'home';
  static const String livros = 'livros';
  static const String livroNovo = 'livro-novo';
  static const String livroDetalhe = 'livro-detalhe';
  static const String livroEditar = 'livro-editar';
}

/// Caminhos
class RoutePaths {
  const RoutePaths._();

  static const String login = '/login';
  static const String registro = '/registro';
  static const String home = '/';
  static const String livros = 'livros';
  static const String livroNovo = 'novo';
  static const String livroDetalhe = ':id';
  static const String livroEditar = 'editar';
}
