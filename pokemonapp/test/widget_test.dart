import 'package:flutter_test/flutter_test.dart';
import 'package:pokemonapp/services/pokemon_service.dart';
void main(){test('serviço expõe endpoint da API',(){expect(PokemonService.url,contains('/pokemons'));});}
