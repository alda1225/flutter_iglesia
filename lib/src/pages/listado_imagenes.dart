import 'package:flutter/material.dart';
import 'package:flutter_church/src/models/imagen_model.dart';
import 'package:flutter_church/src/providers/imagenes_provider.dart';

class ListadoImagenes extends StatelessWidget {
  //instancias
  final imagenProvider = new ImagenProvider();
  //Variables
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: Text("home"),
      ),
      body: _crearListado(),
    );
  }

  Widget _crearListado() {
    return FutureBuilder(
      key: scaffoldKey,
      future: imagenProvider.cargarImagenes(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ImagenModel>> snapshot) {
        if (snapshot.hasData) {
          final imagenes = snapshot.data;

          return ListView.builder(
            itemCount: imagenes.length,
            itemBuilder: (context, i) => _crearItem(context, imagenes[i]),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, ImagenModel imagen) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direction) {
        imagenProvider.borrarProducto(imagen.id);
      },
      child: Card(
        child: Column(
          children: <Widget>[
            (imagen.url == null)
            ? Image(image: AssetImage("assets/no-image.png"))
            : FadeInImage(
                image: NetworkImage(imagen.url),
                placeholder: AssetImage("assets/jar-loading.gif"),
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ListTile(
              title: Text('${imagen.descripcion}-${imagen.url}'),
              subtitle: Text(imagen.id),
              onTap: () =>
                  Navigator.pushNamed(context, 'imagen', arguments: imagen),
            ),
          ],
        ),
      ),
    );
  }
}
