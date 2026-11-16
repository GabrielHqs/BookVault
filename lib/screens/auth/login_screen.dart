import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../services/auth_falha.dart';
import '../../services/auth_service.dart';
import '../../widgets/campo_senha.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService.instance;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _carregando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _carregando = true);
    try {
      // Ao logar, o redirect do go_router leva para a home.
      await _auth.entrar(
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.menu_book, size: AppSpacing.iconeGrande),
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    AppStrings.appNome,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.titulo,
                  ),
                  const SizedBox(height: AppSpacing.xl),
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
                    validator: Validators.obrigatorio,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                    onPressed: _carregando ? null : _entrar,
                    child: _carregando
                        ? const SizedBox(
                            height: AppSpacing.icone,
                            width: AppSpacing.icone,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(AppStrings.botaoEntrar),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextButton(
                    onPressed: () => context.goNamed(RouteNames.registro),
                    child: const Text(AppStrings.irParaRegistro),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
