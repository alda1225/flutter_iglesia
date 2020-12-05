
import 'dart:async';

class LoginBloc{
  final _emailController = StreamController<String>.broadcast();
  final _passwordController = StreamController<String>.broadcast();
  
  //Recuperar los datos del Stream
  Stream <String> get emailStream => _emailController.stream;
  Stream <String> get passwordStream => _passwordController.stream;

  // Insertar valores al Strean
  Function (String) get changeEmail => _emailController.add;
  Function (String) get changePassword => _passwordController.add;

  disposed(){
    _emailController?.close();
    _passwordController?.close();
  }
}