import 'package:material_ui/material_ui.dart';

import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

class ResumoCard extends StatelessWidget {
  const ResumoCard({super.key, required this.rotulo, required this.valor});

  final String rotulo;
  final int valor;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Column(
          children: [
            Text('$valor', style: AppTextStyles.numeroResumo),
            const SizedBox(height: AppSpacing.xs),
            Text(rotulo, style: AppTextStyles.legenda),
          ],
        ),
      ),
    );
  }
}
