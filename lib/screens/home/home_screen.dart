import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/livro.dart';
import '../../services/auth_service.dart';
import '../../services/livro_service.dart';
import '../../widgets/carregando.dart';
import '../../widgets/estado_erro.dart';
import '../../widgets/estado_vazio.dart';
import '../../widgets/livro_card.dart';
import '../../widgets/resumo_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = LivroService();
  final _auth = AuthService.instance;
  late Stream<List<Livro>> _livros;

  @override
  void initState() {
    super.initState();
    _livros = _service.observarTodos();
  }

  void _recarregar() {
    setState(() => _livros = _service.observarTodos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appNome),
        actions: [
          IconButton(
            tooltip: AppStrings.sair,
            icon: const Icon(Icons.logout),
            onPressed: _auth.sair,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed(RouteNames.livroNovo),
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.novoLivro),
      ),
      body: StreamBuilder<List<Livro>>(
        stream: _livros,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return EstadoErro(
              mensagem: AppStrings.erroCarregar,
              aoTentarNovamente: _recarregar,
            );
          }
          if (!snapshot.hasData) return const Carregando();

          final livros = snapshot.data!;
          if (livros.isEmpty) {
            return const EstadoVazio(
              titulo: AppStrings.vazioTitulo,
              mensagem: AppStrings.vazioMensagem,
            );
          }

          final lidos = livros.where((livro) => livro.lido).length;
          final recentes = livros.take(3).toList();

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Row(
                children: [
                  Expanded(
                    child: ResumoCard(
                      rotulo: AppStrings.resumoTotal,
                      valor: livros.length,
                    ),
                  ),
                  Expanded(
                    child: ResumoCard(
                      rotulo: AppStrings.resumoLidos,
                      valor: lidos,
                    ),
                  ),
                  Expanded(
                    child: ResumoCard(
                      rotulo: AppStrings.resumoParaLer,
                      valor: livros.length - lidos,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                AppStrings.ultimosAdicionados,
                style: AppTextStyles.secao,
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final livro in recentes)
                LivroCard(
                  livro: livro,
                  aoTocar: () => context.goNamed(
                    RouteNames.livroDetalhe,
                    pathParameters: {'id': livro.id!},
                  ),
                ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: () => context.goNamed(RouteNames.livros),
                child: const Text(AppStrings.verTodos),
              ),
              // Espaço para o botão flutuante não cobrir o conteúdo.
              const SizedBox(height: AppSpacing.xl * 2),
            ],
          );
        },
      ),
    );
  }
}
