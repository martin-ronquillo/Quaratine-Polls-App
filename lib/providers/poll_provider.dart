import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:polls_app/models/polls_model.dart';

import 'package:polls_app/user_preferences/user_preferences.dart';

class PollProvider {
  final _prefs = new PreferenciasUsuario();

  Future<List<PollsModel>> getPolls() async {
    final resp = await http.get(
      Uri.parse('http://192.168.1.31/api/polls/user/${_prefs.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_prefs.token}',
      },
    );

    // print(resp.body);
    Map<String, dynamic>? decodedResp = json.decode(resp.body);
    final List<PollsModel> polls = [];

    if (decodedResp == null) return [];
    if (decodedResp['data'] == null) return [];

    List<dynamic> data = decodedResp['data'];

    data.forEach((element) {
      final pollTemp = PollsModel.fromJson(element);

      polls.add(pollTemp);
    });

    return polls;
  }

  Future<List<PollsModel>> getUserPolls() async {
    final resp = await http.get(
      Uri.parse('http://192.168.1.31/api/user/${_prefs.id}/polls'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_prefs.token}',
      },
    );

    // print(resp.body);
    Map<String, dynamic>? decodedResp = json.decode(resp.body);
    final List<PollsModel> polls = [];

    if (decodedResp == null) return [];
    if (decodedResp['data'] == null) return [];

    List<dynamic> data = decodedResp['data'];

    data.forEach((element) {
      final pollTemp = PollsModel.fromJson(element);

      polls.add(pollTemp);
    });

    return polls;
  }

  Future<Map<String, dynamic>?> savePoll(PollsModel poll) async {
    final pollId = Random().nextInt(999999999);

    final dataPoll = {
      "id": pollId,
      "user_id": _prefs.id,
      "poll_reason": poll.pollReason,
      "poll_subtitle": poll.pollSubtitle,
      "expected_samplings":
          poll.expectedSamplings! < 1 ? 9999 : poll.expectedSamplings,
      // "total_samplings" : poll.totalSamplings! < 1 ? 0 : poll.totalSamplings,
      "active": 1
    };
    // print(dataPoll);

    final resp =
        await http.post(Uri.parse('http://192.168.1.31/api/polls'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              // 'Accept': 'application/json',
              'Authorization': 'Bearer ${_prefs.token}',
            },
            body: json.encode(dataPoll));
    if (resp.statusCode == 500) return {'success': false};

    Map<String, dynamic>? decodedResp = json.decode(resp.body);

    return decodedResp;
  }

  Future<List<PollsModel>> searchPoll(String query) async {
    final resp = await http.get(
      Uri.parse('http://192.168.1.31/api/polls/search/$query'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Accept': 'application/json',
        'Authorization': 'Bearer ${_prefs.token}',
      },
    );

    final decodedData = json.decode(resp.body);

    final polls = new Polls.fromJsonList(decodedData['data']);

    return polls.items;
  }
}
