import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://127.0.0.1:5000';

  static Future<List<Map<String, dynamic>>> getPeople() async {
    final url = Uri.parse('$_baseUrl/get-people');
    print("Envoi de la requête à $url...");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print("Réponse reçue : ${response.body}");
      final List<dynamic> decoded = json.decode(response.body);
      return decoded.cast<Map<String, dynamic>>();
    } else {
      throw Exception(
          "Erreur HTTP : ${response.statusCode}, message : ${response.body}");
    }
  }

  static Future<Map<String, dynamic>> getTablePlan(List<Map<String, dynamic>> presentPeople) async {
  final url = Uri.parse('$_baseUrl/get-plan');
  print("Envoi de la requête POST à $url avec les données : $presentPeople");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode({"people": presentPeople}),
  );

  if (response.statusCode == 200) {
    print("Réponse reçue : ${response.body}");
    final decoded = json.decode(response.body);

    // Cast explicit pour éviter les erreurs de type
    return {
      "table1": List<Map<String, dynamic>>.from(decoded["table1"]),
      "table2": List<Map<String, dynamic>>.from(decoded["table2"]),
    };
  } else {
    throw Exception(
        "Erreur HTTP : ${response.statusCode}, message : ${response.body}");
  }
}
}
