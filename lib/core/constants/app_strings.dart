/// Textos fixos da interface.
class AppStrings {
  const AppStrings._();

  static const String appNome = 'Minha Biblioteca';

  // Home
  static const String resumoTotal = 'Total';
  static const String resumoLidos = 'Lidos';
  static const String resumoParaLer = 'Para ler';
  static const String ultimosAdicionados = 'Últimos adicionados';
  static const String verTodos = 'Ver todos os livros';

  // Lista
  static const String meusLivros = 'Meus livros';
  static const String filtroTodos = 'Todos';
  static const String filtroLidos = 'Lidos';
  static const String filtroParaLer = 'Para ler';
  static const String nenhumResultado = 'Nenhum livro neste filtro.';

  // Formulário
  static const String novoLivro = 'Novo livro';
  static const String editarLivro = 'Editar livro';
  static const String campoTitulo = 'Título';
  static const String campoAutor = 'Autor';
  static const String campoGenero = 'Gênero';
  static const String campoNota = 'Nota';
  static const String campoLido = 'Já li este livro';
  static const String salvar = 'Salvar';

  // Detalhes
  static const String detalhes = 'Detalhes';
  static const String adicionadoEm = 'Adicionado em';
  static const String statusLido = 'Lido';
  static const String statusParaLer = 'Para ler';
  static const String editar = 'Editar';
  static const String excluir = 'Excluir';

  // Confirmação
  static const String confirmarExclusaoTitulo = 'Excluir livro?';
  static const String confirmarExclusaoMensagem =
      'Esta ação não pode ser desfeita.';
  static const String cancelar = 'Cancelar';

  // Estados
  static const String vazioTitulo = 'Sua biblioteca está vazia';
  static const String vazioMensagem = 'Adicione seu primeiro livro.';
  static const String tentarNovamente = 'Tentar novamente';
  static const String erroCarregar = 'Não foi possível carregar os dados.';
  static const String erroSalvar = 'Não foi possível salvar o livro.';
  static const String erroExcluir = 'Não foi possível excluir o livro.';
  static const String livroNaoEncontrado = 'Livro não encontrado.';

  // Validações
  static const String erroCampoObrigatorio = 'Campo obrigatório.';
  static const String erroTamanhoMinimo = 'Informe ao menos 2 caracteres.';
  static const String erroTamanhoMaximo = 'Máximo de 100 caracteres.';

  // Autenticação
  static const String tituloLogin = 'Entrar';
  static const String tituloRegistro = 'Criar conta';
  static const String campoEmail = 'E-mail';
  static const String campoSenha = 'Senha';
  static const String campoConfirmarSenha = 'Confirmar senha';
  static const String botaoEntrar = 'Entrar';
  static const String botaoCriarConta = 'Criar conta';
  static const String irParaRegistro = 'Não tem conta? Cadastre-se';
  static const String irParaLogin = 'Já tem conta? Entre';
  static const String sair = 'Sair';
  static const String mostrarSenha = 'Mostrar senha';
  static const String erroEmailInvalido = 'Informe um e-mail válido.';
  static const String erroSenhaCurta =
      'A senha precisa ter ao menos 6 caracteres.';
  static const String erroSenhasDiferentes = 'As senhas não coincidem.';
  static const String erroCredenciais = 'E-mail ou senha incorretos.';
  static const String erroEmailEmUso = 'Este e-mail já está cadastrado.';
  static const String erroSenhaFraca = 'Escolha uma senha mais forte.';
  static const String erroRede = 'Sem conexão. Tente novamente.';
  static const String erroAutenticar = 'Não foi possível autenticar.';

  static const List<String> generos = [
    'Romance',
    'Ficção',
    'Fantasia',
    'Técnico',
    'Biografia',
    'Outros',
  ];
}
