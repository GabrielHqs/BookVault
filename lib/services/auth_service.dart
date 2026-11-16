import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../core/constants/app_strings.dart';
import 'auth_falha.dart';

/// Acesso ao Firebase Auth. Notifica ouvintes quando o login muda,
/// o que permite ao go_router redirecionar sozinho.
class AuthService extends ChangeNotifier {
  AuthService._() {
    _auth.authStateChanges().listen((_) => notifyListeners());
  }

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool get logado => _auth.currentUser != null;

  String? get uid => _auth.currentUser?.uid;

  Future<void> entrar({required String email, required String senha}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthFalha(_mensagem(e.code));
    }
  }

  Future<void> registrar({required String email, required String senha}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthFalha(_mensagem(e.code));
    }
  }

  Future<void> sair() => _auth.signOut();

  String _mensagem(String codigo) {
    switch (codigo) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return AppStrings.erroCredenciais;
      case 'invalid-email':
        return AppStrings.erroEmailInvalido;
      case 'email-already-in-use':
        return AppStrings.erroEmailEmUso;
      case 'weak-password':
        return AppStrings.erroSenhaFraca;
      case 'network-request-failed':
        return AppStrings.erroRede;
      default:
        debugPrint('Erro de autenticação: $codigo');
        return AppStrings.erroAutenticar;
    }
  }
}
