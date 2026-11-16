import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../models/livro.dart';
import '../../services/livro_service.dart';
import '../../widgets/carregando.dart';
import '../../widgets/estado_erro.dart';
import '../../widgets/nota_estrelas.dart';

class LivroDetalheScreen extends StatefulWidget {
  const LivroDetalheScreen({super.key, required this.livroId});

  final String livroId;

  @override
  State<LivroDetalheScreen> createState() => _LivroDetalheScreenState();
}

class _LivroDetalheScreenState extends State<LivroDetalheScreen> {
  final _service = LivroService();
  late Stream<Livro?> _livro;

  @override
  void initState() {
    super.initState();
    _livro = _service.observarPorId(widget.livroId);
  }

  Future<void> _excluir() async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.confirmarExclusaoTitulo),
        content: const Text(AppStrings.confirmarExclusaoMensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(AppStrings.cancelar),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(AppStrings.excluir),
          ),
        ],
      ),
    );
    if (confirmou != true) return;

    try {
      await _service.excluir(widget.livroId);
      if (!mounted) return;
      context.goNamed(RouteNames.livros);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text(AppStrings.erroExcluir)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.detalhes),
        actions: [
          IconButton(
            tooltip: AppStrings.editar,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.goNamed(
              RouteNames.livroEditar,
              pathParameters: {'id': widget.livroId},
            ),
          ),
          IconButton(
            tooltip: AppStrings.excluir,
            icon: const Icon(Icons.delete_outline),
            onPressed: _excluir,
          ),
        ],
      ),
      body: StreamBuilder<Livro?>(
        stream: _livro,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const EstadoErro(mensagem: AppStrings.erroCarregar);
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Carregando();
          }
          final livro = snapshot.data;
          if (livro == null) {
            return const EstadoErro(mensagem: AppStrings.livroNaoEncontrado);
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text(livro.titulo, style: AppTextStyles.titulo),
              const SizedBox(height: AppSpacing.sm),
              Text(livro.autor, style: AppTextStyles.corpo),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  Chip(label: Text(livro.genero)),
                  Chip(
                    avatar: Icon(
                      livro.lido ? Icons.check_circle : Icons.schedule,
                      color: livro.lido ? AppColors.sucesso : null,
                    ),
                    label: Text(
                      livro.lido
                          ? AppStrings.statusLido
                          : AppStrings.statusParaLer,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              NotaEstrelas(nota: livro.nota),
              const SizedBox(height: AppSpacing.md),
              Text(
                '${AppStrings.adicionadoEm} '
                '${Formatters.data(livro.criadoEm)}',
                style: AppTextStyles.legenda,
              ),
            ],
          );
        },
      ),
    );
  }
}
