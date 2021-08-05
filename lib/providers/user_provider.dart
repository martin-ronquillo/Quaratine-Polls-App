import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:polls_app/user_preferences/user_preferences.dart';

class UserProvider {
  final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {'email': email, 'password': password};

    final resp = await http.post(Uri.parse('http://192.168.1.31/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(authData));

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('code'))
      return {'ok': false, 'mensaje': decodedResp['message']};

    Map<String, dynamic> dataJson = decodedResp['data'];

    if (dataJson.containsKey('api_token')) {
      _prefs.token = dataJson['api_token'];
      _prefs.id = dataJson['id'];
      return {'ok': true, 'token': dataJson['api_token']};
    } else {
      return {'ok': false, 'mensaje': decodedResp['message']};
    }
  }

  Future<Map<String, dynamic>> validaToken() async {
    final resp = await http.get(
        Uri.parse('http://192.168.1.31/api/user/is-logged'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${_prefs.token}',
        });

    if (resp.statusCode == 500) return {'status': false};

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('code'))
      return {'status': false, 'mensaje': decodedResp['message']};

    return {'status': true};
  }
}
