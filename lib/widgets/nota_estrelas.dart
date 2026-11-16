import 'package:material_ui/material_ui.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

class NotaEstrelas extends StatelessWidget {
  const NotaEstrelas({super.key, required this.nota});

  final int nota;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (indice) {
        return Icon(
          indice < nota ? Icons.star : Icons.star_border,
          size: AppSpacing.icone,
          color: AppColors.estrela,
        );
      }),
    );
  }
}
