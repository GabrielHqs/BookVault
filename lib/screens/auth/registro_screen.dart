import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/validators.dart';
import '../../services/auth_falha.dart';
import '../../services/auth_service.dart';
import '../../widgets/campo_senha.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _auth = AuthService.instance;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmacaoController = TextEditingController();
  bool _carregando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _confirmacaoController.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _carregando = true);
    try {
      // Deixa o usuario logado depos de criar a conta
      await _auth.registrar(
        email: _emailController.text,
        senha: _senhaController.text,
      );
    } on AuthFalha catch (falha) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(falha.mensagem)));
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.tituloRegistro)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: AppStrings.campoEmail,
                ),
                validator: Validators.email,
              ),
              const SizedBox(height: AppSpacing.md),
              CampoSenha(
                controller: _senhaController,
                validator: Validators.senha,
              ),
              const SizedBox(height: AppSpacing.md),
              CampoSenha(
                controller: _confirmacaoController,
                rotulo: AppStrings.campoConfirmarSenha,
                validator: Validators.confirmacaoSenha(
                  () => _senhaController.text,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: _carregando ? null : _registrar,
                child: _carregando
                    ? const SizedBox(
                        height: AppSpacing.icone,
                        width: AppSpacing.icone,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(AppStrings.botaoCriarConta),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => context.goNamed(RouteNames.login),
                child: const Text(AppStrings.irParaLogin),
              ),
            ],
          ),
        ),
      ),
    ); 
  }
}
