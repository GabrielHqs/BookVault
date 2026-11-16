import 'package:material_ui/material_ui.dart';

import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

class EstadoVazio extends StatelessWidget {
  const EstadoVazio({
    super.key,
    required this.titulo,
    this.mensagem,
    this.icone = Icons.menu_book_outlined,
  });

  final String titulo;
  final String? mensagem;
  final IconData icone;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icone,
              size: AppSpacing.iconeGrande,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(titulo, style: AppTextStyles.secao),
            if (mensagem != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(mensagem!, textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}
