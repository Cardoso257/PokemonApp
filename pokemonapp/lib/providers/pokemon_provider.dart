import 'package:flutter/material.dart';
import '../services/pokemon_service.dart';

class PokemonProvider extends ChangeNotifier {
  List<dynamic> pokemons = [];
  Map<String, dynamic>? pokemonSelecionado;
  bool carregando = false;
  String? erro;
  Future<void> carregarPokemons() async {
    carregando = true; erro = null; notifyListeners();
    try { pokemons = await PokemonService.buscarPokemons(); }
    catch (e) { erro = e.toString(); pokemons = []; }
    finally { carregando = false; notifyListeners(); }
  }
  Future<void> carregarDetalhes(int id) async {
    carregando = true; erro = null; pokemonSelecionado = null; notifyListeners();
    try { pokemonSelecionado = await PokemonService.buscarDetalhes(id); }
    catch (e) { erro = e.toString(); }
    finally { carregando = false; notifyListeners(); }
  }
}
