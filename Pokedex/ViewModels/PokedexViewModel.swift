//
//  PokedexViewModel.swift
//  Pokedex
//
//  Created by Anh Dung Pham on 09.06.22.
//

import Foundation
import PokemonAPI
import SwiftUI

struct PokemonStat {
    var category: String
    var baseValue: Int
}

class PokedexViewModel: ObservableObject {
    @Published var pokemon = [Pokemon]()
    let pokemonAPI = PokemonAPI()

    struct PokemonEntry {
        let pokemon: PKMPokemon
        let species: PKMPokemonSpecies
    }

    func loadPokemons() async {
        guard let pokemonEntries = try? await pokemonAPI.gameService.fetchPokedex(1).pokemonEntries else { return }
        for entry in pokemonEntries {
            guard let pokemonID = entry.entryNumber else { continue }
            async let fetchSpecies = pokemonAPI.pokemonService.fetchPokemonSpecies(pokemonID)
            async let fetchPokemon = pokemonAPI.pokemonService.fetchPokemon(pokemonID)
            guard let pokemonEntry = try? await PokemonEntry(pokemon: fetchPokemon, species: fetchSpecies) else { continue }

            let species = pokemonEntry.species
            let pokemon = pokemonEntry.pokemon

            var stats: [PokemonStat] = []

            pokemon.stats?.forEach { stat in
                guard let baseStat = stat.baseStat,
                      let key = stat.stat?.name
                else { return }
                stats.append(PokemonStat(category: key, baseValue: baseStat))
            }

            guard let colorName = species.color?.name,
                  let image = pokemon.sprites?.frontDefault,
                  let pokemonID = species.id ?? pokemon.id,
                  let name = species.names?.first(where: { $0.language?.name == "de" })?.name
            else { continue }
            let color: Color = color(for: colorName)
            let types: [PokemonType] = pokemon.types?.compactMap { type in
                type.type?.name
            }.compactMap { name in
                PokemonType(rawValue: name)
            } ?? []

            DispatchQueue.main.async {
                self.pokemon.append(
                    Pokemon(id: pokemonID, name: name, color: color, image: image, types: types, stats: stats)
                )
            }
        }
    }

    func color(for name: String) -> Color {
        let color: Color
        switch name {
        case "gray", "white":
            color = .gray

        case "blue":
            color = .blue

        case "red":
            color = Color("fireRed")

        case "yellow":
            color = .yellow

        case "green":
            color = .green

        case "pink":
            color = .pink

        case "brown":
            color = .brown

        case "purple":
            color = .purple

        default:
            color = .black
        }

        return color
    }
}

