//
//  DragAndDropGame.swift
//  Pokedex
//
//  Created by Anh Dung Pham on 20.04.23.
//

import SwiftUI

struct DragAndDropPokemon {
    var pokemon: Pokemon
    var isCorrect = false
}

struct DragAndDropGame: View {
    @ObservedObject private var viewModel = PokedexViewModel()

    @State private var solvedPokemons: [DragAndDropPokemon] = []
    @State private var currentPokemons: [DragAndDropPokemon] = []

    @State var progress: CGFloat = 1

    var body: some View {
        VStack {
            HStack(spacing: 18.0) {
                GeometryReader{proxy in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.gray.opacity(0.25))

                        Capsule()
                            .fill(Color.green)
                            .frame(width: proxy.size.width * progress)
                    }
                }
                .frame(height: 20)

                Image(systemName: "suit.heart.fill")
                    .frame(height: 20)
                    .foregroundColor(.red)
            }

            HStack {
                ForEach($currentPokemons, id: \.pokemon) { $pokemon in
                    @State var start: Bool = false

                    PokedexCard(pokemon: pokemon.pokemon)
                        .redacted(reason: pokemon.isCorrect ? [] : .placeholder)
                        .onDrop(of: [.url], isTargeted: .constant(false)) { providers in
                            if let first = providers.first {
                               let _ = first.loadObject(ofClass: URL.self) { value, error in
                                   guard let url = value else { return }
                                   withAnimation{
                                       pokemon.isCorrect = pokemon.isCorrect || "\(pokemon.pokemon.id)" == "\(url)"
                                       if !pokemon.isCorrect {
                                           progress -= 0.1
                                       }

                                       if currentPokemons.filter(\.isCorrect).count == 3 {
                                           getNextPokemons()
                                       }
                                   }
                                }
                            }

                            return false
                        }
                }
            }
            .padding(.vertical, 16.0)

            Divider()

            HStack {
                ForEach(currentPokemons.shuffled(), id: \.pokemon) { pokemon in
                    Text(pokemon.pokemon.name)
                        .font(.system(size: 16.0))
                        .padding(.vertical, 4.0)
                        .padding(.horizontal, 8.0)
                        .background{
                            RoundedRectangle(cornerRadius: 8.0, style: .continuous)
                                .stroke(.gray)
                        }
                        .onDrag {
                            return .init(contentsOf: URL(string: "\(pokemon.pokemon.id)")!)!
                        }
                        .opacity(pokemon.isCorrect ? 0 : 1)
                }
            }
            .padding(.vertical, 8.0)
        }
        .padding(16.0)
        .onAppear {
            Task {
                await viewModel.loadPokemons()
                getNextPokemons()
            }
        }
    }

    func getNextPokemons() {
        let pokemons = viewModel.pokemons?.filter({ pokemon in solvedPokemons.map(\.pokemon).contains(pokemon) == false })
        let randomPokemons: [Pokemon] = Array(pokemons?.shuffled().prefix(3) ?? [])
        currentPokemons = randomPokemons.map { DragAndDropPokemon(pokemon: $0) }
        progress = min(progress + 0.1, 1.0)
    }
}

struct DragAndDropGame_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropGame()
    }
}
