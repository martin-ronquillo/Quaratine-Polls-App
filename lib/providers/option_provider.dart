import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:polls_app/models/options_model.dart';

import 'package:polls_app/user_preferences/user_preferences.dart';

class OptionProvider {
  final _prefs = new PreferenciasUsuario();

  Future<List<OptionsModel>> getOptions(int questionId) async {
    final resp = await http.get(
      Uri.parse('http://192.168.1.31/api/options/$questionId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_prefs.token}',
      },
    );

    Map<String, dynamic>? decodedResp = json.decode(resp.body);
    final List<OptionsModel> options = [];

    if (decodedResp == null) return [];
    if (decodedResp['data'] == null) return [];

    List<dynamic> data = decodedResp['data'];

    data.forEach((element) {
      final optionTemp = OptionsModel.fromJson(element);

      options.add(optionTemp);
    });
    
    return options;
  }

  Future<Map<String, dynamic>?> saveOptions(
      int questionId, List<String> options) async {

    final dataOption = {"question_id": questionId, "options": options};

    final resp =
        await http.post(Uri.parse('http://192.168.1.31/api/options'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${_prefs.token}',
            },
            body: json.encode(dataOption));

    if (resp.statusCode == 500) return {'success': false};

    Map<String, dynamic>? decodedResp = json.decode(resp.body);

    // return {};
    return decodedResp;
  }

  Future<Map<String, dynamic>?> updateOption(
      int pollId, OptionsModel question, List<String> options) async {
    final dataOption = {
      // "poll_id": pollId,
      // "question": question.question,
      // "type": question.type,
      // "options": options,
      // "required": question.required
    };

    final resp = await http.put(
        Uri.parse('http://192.168.1.31/api/questions/${question.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${_prefs.token}',
        },
        body: json.encode(dataOption));

    if (resp.statusCode == 500) return {'success': false};

    Map<String, dynamic>? decodedResp = json.decode(resp.body);

    // return {};
    return decodedResp;
  }
}
