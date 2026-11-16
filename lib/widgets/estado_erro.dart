import 'package:material_ui/material_ui.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_spacing.dart';

class EstadoErro extends StatelessWidget {
  const EstadoErro({super.key, required this.mensagem, this.aoTentarNovamente});

  final String mensagem;
  final VoidCallback? aoTentarNovamente;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: AppSpacing.iconeGrande,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(mensagem, textAlign: TextAlign.center),
            if (aoTentarNovamente != null) ...[
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: aoTentarNovamente,
                child: const Text(AppStrings.tentarNovamente),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
