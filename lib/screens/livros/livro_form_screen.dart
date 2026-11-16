import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/validators.dart';
import '../../models/livro.dart';
import '../../services/livro_service.dart';
import '../../widgets/carregando.dart';
import '../../widgets/estado_erro.dart';

/// Serve para criar (livroId nulo) e editar (livroId informado).
class LivroFormScreen extends StatefulWidget {
  const LivroFormScreen({super.key, this.livroId});

  final String? livroId;

  @override
  State<LivroFormScreen> createState() => _LivroFormScreenState();
}

class _LivroFormScreenState extends State<LivroFormScreen> {
  final _service = LivroService();
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _autorController = TextEditingController();

  String _genero = AppStrings.generos.first;
  double _nota = 0;
  bool _lido = false;
  DateTime? _criadoEm;

  bool _carregando = false;
  bool _erroCarga = false;
  bool _salvando = false;

  bool get _editando => widget.livroId != null;

  @override
  void initState() {
    super.initState();
    if (_editando) {
      _carregando = true;
      _carregarLivro();
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    super.dispose();
  }

  Future<void> _carregarLivro() async {
    setState(() {
      _carregando = true;
      _erroCarga = false;
    });
    try {
      final livro = await _service.buscarPorId(widget.livroId!);
      if (!mounted) return;
      if (livro == null) {
        setState(() {
          _carregando = false;
          _erroCarga = true;
        });
        return;
      }
      setState(() {
        _tituloController.text = livro.titulo;
        _autorController.text = livro.autor;
        _genero = livro.genero;
        _nota = livro.nota.toDouble();
        _lido = livro.lido;
        _criadoEm = livro.criadoEm;
        _carregando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _carregando = false;
        _erroCarga = true;
      });
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);

    final livro = Livro(
      id: widget.livroId,
      titulo: _tituloController.text.trim(),
      autor: _autorController.text.trim(),
      genero: _genero,
      nota: _nota.round(),
      lido: _lido,
      criadoEm: _criadoEm ?? DateTime.now(),
    ); 

    try {
      if (_editando) {
        await _service.atualizar(livro);
      } else {
        await _service.criar(livro);
      }
      if (!mounted) return;
      context.goNamed(RouteNames.livros);
    } catch (_) {
      if (!mounted) return;
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text(AppStrings.erroSalvar)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? AppStrings.editarLivro : AppStrings.novoLivro),
      ),
      body: _corpo(),
    );
  }

  Widget _corpo() {
    if (_carregando) return const Carregando();
    if (_erroCarga) {
      return EstadoErro(
        mensagem: AppStrings.erroCarregar,
        aoTentarNovamente: _carregarLivro,
      );
    }

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          TextFormField(
            controller: _tituloController,
            decoration: const InputDecoration(
              labelText: AppStrings.campoTitulo,
            ),
            textCapitalization: TextCapitalization.sentences,
            validator: Validators.texto,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _autorController,
            decoration: const InputDecoration(labelText: AppStrings.campoAutor),
            textCapitalization: TextCapitalization.words,
            validator: Validators.texto,
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(AppStrings.campoGenero),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final genero in AppStrings.generos)
                ChoiceChip(
                  label: Text(genero),
                  selected: _genero == genero,
                  onSelected: (_) => setState(() => _genero = genero),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text('${AppStrings.campoNota}: ${_nota.round()}'),
          Slider(
            value: _nota,
            max: 5,
            divisions: 5,
            label: _nota.round().toString(),
            onChanged: (valor) => setState(() => _nota = valor),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(AppStrings.campoLido),
            value: _lido,
            onChanged: (valor) => setState(() => _lido = valor),
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: _salvando ? null : _salvar,
            child: _salvando
                ? const SizedBox(
                    height: AppSpacing.icone,
                    width: AppSpacing.icone,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(AppStrings.salvar),
          ),
        ],
      ),
    );
  }
}
