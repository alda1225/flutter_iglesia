import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_church/src/models/imagen_model.dart';
import 'package:flutter_church/src/providers/imagenes_provider.dart';
import 'package:image_picker/image_picker.dart';

class ImagenUpload extends StatefulWidget {
  @override
  _Upload createState() => _Upload();
}

class _Upload extends State<ImagenUpload> {
  final imagenProvider = new ImagenProvider();
  //Dejar esto al inicio del formulario
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ImagenModel imagenModel = new ImagenModel();
  File photo;

  @override
  Widget build(BuildContext context) {
    final ImagenModel imagenData = ModalRoute.of(context).settings.arguments;
    if (imagenData != null) {
      imagenModel = imagenData;
    }

    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              //color: Colors.amber,
              padding: EdgeInsets.all(15),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    _mostrarFoto(),
                    _crearDescripcion(),
                    _botonGrabar(),
                    _botonAbreCamara(),
                    _botonAbreArchivos(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _crearDescripcion() {
    return TextFormField(
      initialValue: imagenModel.descripcion,
      onSaved: (value) => imagenModel.descripcion = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Debe tener una descripcion detallada';
        } else {
          return null;
        }
      },
      cursorColor: Colors.black26,
      style: TextStyle(
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: "Detalle fotografia",
        labelStyle: new TextStyle(color: Colors.black54),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black54,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Colors.black54,
            width: 2.0,
          ),
        ),
        hintText: "ingrese detalle de la fotografia",
        hintStyle: TextStyle(
          color: Colors.black54,
          fontFamily: "Lato",
        ),
        counterStyle: TextStyle(color: Colors.black87),
      ),
      maxLines: 3,
      maxLength: 1000,
      keyboardType: TextInputType.multiline,
    );
  }

  Widget _botonGrabar() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.blue,
      textColor: Colors.white,
      label: Text("Guardar"),
      icon: Icon(Icons.save),
      onPressed: () {
        _submit();
      },
    );
  }

  Widget _botonAbreArchivos() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.blue,
      textColor: Colors.white,
      label: Text("Seleccionar"),
      icon: Icon(Icons.filter),
      onPressed: () {
        _procesarImagen(ImageSource.gallery);
      },
    );
  }

  Widget _botonAbreCamara() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.blue,
      textColor: Colors.white,
      label: Text("Camara"),
      icon: Icon(Icons.camera_alt),
      onPressed: () {
        _procesarImagen(ImageSource.camera);
      },
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();
    if (photo != null) {
      imagenModel.url = await imagenProvider.subirImagen(photo);
    }

    if (imagenModel.id != null) {
      //imagenProvider.editarImagen(imagenModel);
      imagenProvider.borrarImagen(imagenModel.url);
    } else {
      imagenProvider.crearImagen(imagenModel);
    }

    mostrarSnakBar('Operacion Exitosa');
  }

  void mostrarSnakBar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _mostrarFoto() {
    if (imagenModel.url != null) {
      return FadeInImage(
        image: NetworkImage(imagenModel.url),
        placeholder: AssetImage("assets/jar-loading.gif"),
        height: 300,
        width: double.infinity,
        fit: BoxFit.contain,
      );
    } else {
      if (photo != null) {
        return Image.file(
          photo,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }


  _procesarImagen(ImageSource origen) async {
    photo = await ImagePicker.pickImage(
      source: origen,
    );

    if (photo != null) {
      imagenModel.url = null;
    }
    setState(() {});
  }
}
