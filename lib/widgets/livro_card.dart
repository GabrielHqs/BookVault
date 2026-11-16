import 'package:material_ui/material_ui.dart';

import '../core/theme/app_colors.dart';
import '../models/livro.dart';
import 'nota_estrelas.dart';

class LivroCard extends StatelessWidget {
  const LivroCard({super.key, required this.livro, required this.aoTocar});

  final Livro livro;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: aoTocar,
        leading: Icon(
          livro.lido ? Icons.check_circle : Icons.menu_book_outlined,
          color: livro.lido ? AppColors.sucesso : null,
        ),
        title: Text(livro.titulo),
        subtitle: Text('${livro.autor} • ${livro.genero}'),
        trailing: NotaEstrelas(nota: livro.nota),
      ),
    );
  }
}
