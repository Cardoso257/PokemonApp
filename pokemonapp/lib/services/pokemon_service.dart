import 'dart:convert';
import 'package:http/http.dart' as http;

class PokemonService {
  // No emulador Android, altere 127.0.0.1 para 10.0.2.2.
  static const String url = 'http://127.0.0.1:5001/pokemons';
  static const Duration _timeout = Duration(seconds: 20);

  static Future<List<dynamic>> buscarPokemons() async {
    final resposta = await http.get(Uri.parse(url)).timeout(_timeout);
    if (resposta.statusCode != 200) throw Exception('Erro ao buscar Pokémon: ${resposta.statusCode}');
    final dados = jsonDecode(resposta.body);
    if (dados is! List) throw const FormatException('A API não retornou uma lista de Pokémon.');
    return dados;
  }

  static Future<Map<String, dynamic>> buscarDetalhes(int id) async {
    final resposta = await http.get(Uri.parse('$url/$id')).timeout(_timeout);
    if (resposta.statusCode != 200) throw Exception('Erro ao buscar detalhes: ${resposta.statusCode}');
    final dados = jsonDecode(resposta.body);
    if (dados is! Map<String, dynamic>) throw const FormatException('Detalhes do Pokémon inválidos.');
    return dados;
  }
}
