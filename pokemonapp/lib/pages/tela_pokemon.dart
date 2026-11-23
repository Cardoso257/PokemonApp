import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pokemon_provider.dart';
import 'tela_detalhes_pokemon.dart';

class TelaPokemon extends StatefulWidget {
  const TelaPokemon({super.key});

  @override
  State<TelaPokemon> createState() => _TelaPokemonState();
}

class _TelaPokemonState extends State<TelaPokemon> {
  final TextEditingController _buscaController = TextEditingController();

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PokemonProvider>();
    final termo = _buscaController.text.trim().toLowerCase();
    final pokemonsFiltrados = provider.pokemons.where((pokemon) {
      final nome = pokemon['nome']?.toString().toLowerCase() ?? '';
      final tipo = pokemon['tipo']?.toString().toLowerCase() ?? '';
      return nome.contains(termo) || tipo.contains(termo);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _buscaController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Pesquisar por nome ou tipo',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _buscaController.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Limpar pesquisa',
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _buscaController.clear();
                          setState(() {});
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: provider.carregando
                    ? null
                    : () => context.read<PokemonProvider>().carregarPokemons(),
                icon: const Icon(Icons.catching_pokemon),
                label: const Text('Atualizar Pokédex'),
              ),
            ),
            const SizedBox(height: 16),
            if (provider.carregando)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (provider.erro != null)
              Expanded(
                child: Center(
                  child: Text(
                    'Não foi possível carregar os Pokémon.\n${provider.erro}',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else if (pokemonsFiltrados.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    termo.isEmpty
                        ? 'Nenhum Pokémon disponível.'
                        : 'Nenhum resultado para "$termo".',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: pokemonsFiltrados.length,
                  itemBuilder: (context, index) {
                    final pokemon = pokemonsFiltrados[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        leading: Image.network(
                          pokemon['imagem'],
                          width: 60,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(
                            width: 60,
                            child: Icon(Icons.catching_pokemon, size: 34),
                          ),
                        ),
                        title: Text(
                          pokemon['nome'].toString().toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text('Tipo: ${pokemon['tipo']}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TelaDetalhesPokemon(
                                idPokemon: pokemon['id'],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
