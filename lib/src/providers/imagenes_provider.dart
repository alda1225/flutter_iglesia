import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_church/src/models/imagen_model.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

class ImagenProvider {
  final String _url = "https://radio-app-a6d80.firebaseio.com";

  Future<bool> crearImagen(ImagenModel imagen) async {
    final url = '$_url/imagenes.json';
    final resp = await http.post(url, body: imagenModelToJson(imagen));

    final decodedData = json.decode(resp.body);

    print(decodedData);
    return true;
  }

  Future<bool> editarImagen(ImagenModel imagen) async {
    final url = '$_url/imagenes/${imagen.id}.json';
    final resp = await http.put(url, body: imagenModelToJson(imagen));

    final decodedData = json.decode(resp.body);

    print(decodedData);
    return true;
  }

  Future<List<ImagenModel>> cargarImagenes() async {
    final url = '$_url/imagenes.json';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ImagenModel> imagenes = new List();
    if (decodedData == null) return [];

    decodedData.forEach((id, img) {
      final imgTmp = ImagenModel.fromJson(img);
      imgTmp.id = id;
      imagenes.add(imgTmp);
    });
    print(imagenes);
    return imagenes;
  }

  Future<String> subirImagen(File imagen) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/alda-soft/image/upload?upload_preset=etcm9wft');
    final mimeType = mime(imagen.path).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print("algo salio mal");
      print(resp.body);
      return null;
    }
    final respData = json.decode(resp.body);
    print(respData);

    return respData['secure_url'];
  }

  Future<int> borrarProducto(String id) async {
    await borrarImagen(id);
    final url = '$_url/imagenes/$id.json';
    final resp = await http.delete(url);
    print(json.decode(resp.body));
    return 1;
  }

  Future<bool> borrarImagen(String id) async {
    final ImagenModel producto = await findById(id);

    if (producto.url == null) {
      return false;
    } else {
      final publicId = producto.url
          .substring(producto.url.length - 24, producto.url.length - 4);

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final apiKey = '535344843847163';
      final apiSecret = 'oHc8VfSuDq_8MCUYhgq_zLN9_rU';

      final stringToSha1 = 'public_id=$publicId'
          '&timestamp=$timestamp'
          '$apiSecret';

      final signature = sha1.convert(utf8.encode(stringToSha1));

      final url =
          Uri.parse('https://api.cloudinary.com/v1_1/alda-soft/image/destroy?'
              'api_key=$apiKey'
              '&public_id=$publicId'
              '&timestamp=$timestamp'
              '&signature=$signature');

      final imageDestroyRequest = http.MultipartRequest(
        'POST',
        url,
      );

      final streamResponse = await imageDestroyRequest.send();
      final resp = await http.Response.fromStream(streamResponse);

      if (resp.statusCode != 200 && resp.statusCode != 201) {
        print('Algo salió mal');
        print(resp.body);
        return false;
      }

      final respData = json.decode(resp.body);

      if (respData['result'] == 'ok') {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<ImagenModel> findById(String id) async {
    final url = '$_url/imagenes/$id.json';

    final resp = await http.get(url);

    final Map<String, dynamic> decodeData = json.decode(resp.body);

    final imagen = ImagenModel.fromJson(decodeData);

    imagen.id = id;

    return imagen;
  }
}
