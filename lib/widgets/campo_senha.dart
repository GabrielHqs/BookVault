import 'package:material_ui/material_ui.dart';

import '../core/constants/app_strings.dart';

/// Campo de senha com botão de mostrar/ocultar.
class CampoSenha extends StatefulWidget {
  const CampoSenha({
    super.key,
    required this.controller,
    required this.validator,
    this.rotulo = AppStrings.campoSenha,
  });

  final TextEditingController controller;
  final String? Function(String?) validator;
  final String rotulo;

  @override
  State<CampoSenha> createState() => _CampoSenhaState();
}

class _CampoSenhaState extends State<CampoSenha> {
  bool _oculta = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _oculta,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.rotulo,
        suffixIcon: IconButton(
          tooltip: AppStrings.mostrarSenha,
          icon: Icon(_oculta ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _oculta = !_oculta),
        ),
      ),
    );
  }
}
