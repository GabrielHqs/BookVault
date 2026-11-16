import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/livro.dart';
import 'auth_service.dart';

/// Único ponto de acesso ao Firestore para os livros do usuário logado
/// (coleção `usuarios/{uid}/livros`).
class LivroService {
  LivroService({FirebaseFirestore? firestore, AuthService? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? AuthService.instance;

  final FirebaseFirestore _firestore;
  final AuthService _auth;

  CollectionReference<Map<String, dynamic>> get _colecao =>
      _firestore.collection('usuarios').doc(_auth.uid).collection('livros');

  Stream<List<Livro>> observarTodos() {
    return _colecao
        .orderBy('criadoEm', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Livro.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<Livro?> observarPorId(String id) {
    return _colecao.doc(id).snapshots().map((doc) {
      final dados = doc.data();
      return dados == null ? null : Livro.fromMap(dados, doc.id);
    });
  }

  Future<Livro?> buscarPorId(String id) async {
    final doc = await _colecao.doc(id).get();
    final dados = doc.data();
    return dados == null ? null : Livro.fromMap(dados, doc.id);
  }

  Future<void> criar(Livro livro) async {
    await _colecao.add(livro.toMap());
  }

  Future<void> atualizar(Livro livro) async {
    await _colecao.doc(livro.id).update(livro.toMap());
  }

  Future<void> excluir(String id) async {
    await _colecao.doc(id).delete();
  }
}
