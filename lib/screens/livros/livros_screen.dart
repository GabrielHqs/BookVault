import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/livro.dart';
import '../../services/livro_service.dart';
import '../../widgets/carregando.dart';
import '../../widgets/estado_erro.dart';
import '../../widgets/estado_vazio.dart';
import '../../widgets/livro_card.dart';

enum _Filtro { todos, lidos, paraLer }

class LivrosScreen extends StatefulWidget {
  const LivrosScreen({super.key});

  @override
  State<LivrosScreen> createState() => _LivrosScreenState();
}

class _LivrosScreenState extends State<LivrosScreen> {
  final _service = LivroService();
  late Stream<List<Livro>> _livros;
  _Filtro _filtro = _Filtro.todos;

  @override
  void initState() {
    super.initState();
    _livros = _service.observarTodos();
  }

  void _recarregar() {
    setState(() => _livros = _service.observarTodos());
  }

  List<Livro> _aplicarFiltro(List<Livro> livros) {
    switch (_filtro) {
      case _Filtro.todos:
        return livros;
      case _Filtro.lidos:
        return livros.where((livro) => livro.lido).toList();
      case _Filtro.paraLer:
        return livros.where((livro) => !livro.lido).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.meusLivros)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed(RouteNames.livroNovo),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: SegmentedButton<_Filtro>(
              segments: const [
                ButtonSegment(
                  value: _Filtro.todos,
                  label: Text(AppStrings.filtroTodos),
                ),
                ButtonSegment(
                  value: _Filtro.lidos,
                  label: Text(AppStrings.filtroLidos),
                ),
                ButtonSegment(
                  value: _Filtro.paraLer,
                  label: Text(AppStrings.filtroParaLer),
                ),
              ],
              selected: {_filtro},
              onSelectionChanged: (selecao) =>
                  setState(() => _filtro = selecao.first),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Livro>>(
              stream: _livros,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return EstadoErro(
                    mensagem: AppStrings.erroCarregar,
                    aoTentarNovamente: _recarregar,
                  );
                }
                if (!snapshot.hasData) return const Carregando();

                final todos = snapshot.data!;
                if (todos.isEmpty) {
                  return const EstadoVazio(
                    titulo: AppStrings.vazioTitulo,
                    mensagem: AppStrings.vazioMensagem,
                  );
                }

                final livros = _aplicarFiltro(todos);
                if (livros.isEmpty) {
                  return const EstadoVazio(
                    titulo: AppStrings.nenhumResultado,
                    icone: Icons.filter_list_off,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  itemCount: livros.length,
                  itemBuilder: (context, indice) {
                    final livro = livros[indice];
                    return LivroCard(
                      livro: livro,
                      aoTocar: () => context.goNamed(
                        RouteNames.livroDetalhe,
                        pathParameters: {'id': livro.id!},
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    ); 
  }
}
