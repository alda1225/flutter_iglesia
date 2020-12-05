import 'package:flutter/material.dart';
import 'package:flutter_church/src/bloc/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[_crearFondo(context), _loginForm(context)],
    ));
  }
}

Widget _loginForm(BuildContext context) {
  final bloc = Provider.of(context);
  final size = MediaQuery.of(context).size;

  return SingleChildScrollView(
    child: Column(
      children: <Widget>[
        SafeArea(
            child: Container(
          height: 180,
        )),
        Container(
          width: size.width * 0.85,
          margin: EdgeInsets.symmetric(vertical: 30),
          padding: EdgeInsets.symmetric(vertical: 50),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    offset: Offset(0, 5),
                    spreadRadius: 3.0)
              ]),
          child: Column(
            children: <Widget>[
              Text('Ingreso', style: TextStyle(fontSize: 20)),
              SizedBox(height: 60),
              _crearEmail(bloc),
              SizedBox(height: 30),
              _crearPass(bloc),
              SizedBox(height: 30),
              _crearBoton(),
            ],
          ),
        ),
        Text('Olvido la contraseña'),
        SizedBox(height: 100)
      ],
    ),
  );
}

Widget _crearEmail(LoginBloc bloc) {
  return StreamBuilder(
    stream: bloc.emailStream,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: Colors.cyan),
              hintText: 'ejemplo@correo.com',
              labelText: 'Correo electronico',
              counterText: snapshot.data),
          onChanged: bloc.changeEmail,
        ),
      );
    },
  );
}

Widget _crearPass(LoginBloc bloc) {
  return StreamBuilder(
    stream: bloc.passwordStream,
    builder: (BuildContext context, AsyncSnapshot snapshot) {

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),

        child: TextField(
          obscureText: true,
          decoration: InputDecoration(
              icon: Icon(Icons.lock_outline, color: Colors.cyan),
              labelText: 'Contraseña',
              counterText: snapshot.data,
              errorText: 'No es una Contraseña  Valida'
              ),
              onChanged: bloc.changePassword,
        ),
      );

      
    },
  );
}

Widget _crearBoton() {
  return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
        child: Text('INGRESAR'),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 0,
      color: Colors.cyan,
      textColor: Colors.white,
      onPressed: () {});
}

Widget _crearFondo(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final fondo = Container(
    height: size.height * 0.4,
    width: double.infinity,
    decoration: BoxDecoration(
        gradient: LinearGradient(colors: <Color>[
      Color.fromRGBO(6, 190, 182, 1.0),
      Color.fromRGBO(72, 177, 191, 1.0)
    ])),
  );

  final circulo = Container(
    width: 100.0,
    height: 100.0,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, .05)),
  );

  return Stack(
    children: <Widget>[
      fondo,
      Positioned(top: 90, left: 30, child: circulo),
      Positioned(top: -40, left: -30, child: circulo),
      Positioned(bottom: -50, left: -10, child: circulo),
      Positioned(bottom: -120, left: -20, child: circulo),
      Positioned(bottom: -50, left: -20, child: circulo),
      Container(
        padding: EdgeInsets.only(top: 80),
        child: Column(
          children: <Widget>[
            Icon(Icons.person, color: Colors.white, size: 100),
            SizedBox(height: 10, width: double.infinity)
          ],
        ),
      )
    ],
  );
}
