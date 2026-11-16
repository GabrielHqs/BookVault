import 'package:material_ui/material_ui.dart';

class Carregando extends StatelessWidget {
  const Carregando({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
