//
//  QuizView.swift
//  Pokedex
//
//  Created by Anh Dung Pham on 18.08.22.
//

import NukeUI
import SwiftUI

struct QuizView: View {
    @ObservedObject private var viewModel = PokedexViewModel()
    @State private var currentPokemon: Pokemon? {
        didSet {
            pokemonName = ""
            errorMessage = ""
        }
    }

    @State private var highScore: Int = 0
    @State private var remainingLives: Int = 3
    @State private var pokemonName: String = ""
    @State private var errorMessage: String = ""

    @State private var lastPokémon: Pokemon?
    @State private var showGameOverAlert: Bool = false

    @State private var presentPokemon: Pokemon?

    var lives: String {
        Array(repeating: "❤️", count: remainingLives).joined(separator: " ")
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8.0) {
                HStack {
                    Text(lives)
                    Spacer()
                }

                HStack {
                    Text("Score: \(highScore)")
                        .bold()
                        .font(.headline)
                    Spacer()
                }

                HStack {
                    Text("Highscore: 999")
                        .bold()
                        .font(.headline)
                    Spacer()
                }
            }


            Spacer(minLength: 8.0)

            AsyncImage(url: URL(string: currentPokemon?.sprites?.frontDefault ?? "")) { state in
                if let image = state.image {
                    image
                } else {
                    Color.clear
                }
            }
            .frame(maxHeight: 420.0)
            .aspectRatio(contentMode: .fit)

            VStack(alignment: .leading) {
                Text("Who's this Pokémon?")
                    .font(.callout)
                    .bold()
                TextField("Pokémon-Name", text: $pokemonName, onCommit: {
                    if pokemonName == currentPokemon?.name, !pokemonName.isEmpty {
                        highScore += 1
                        currentPokemon = viewModel.pokemons?.randomElement()
                    } else {
                        errorMessage = "Das ist nicht das gesuchte Pokémon!"
                    }
                })
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                .foregroundColor(.accentColor)
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(Color("fireRed"))
            }.padding(.horizontal, 16.0)

            Spacer(minLength: 16.0)
        }.toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Random") {
                    currentPokemon = viewModel.pokemons?.randomElement()
                }
            }

            ToolbarItem(placement: .bottomBar) {
                Button("I don't F**king know!") {
                    lastPokémon = currentPokemon
                    currentPokemon = viewModel.pokemons?.randomElement()
                    remainingLives -= 1

                    showGameOverAlert = true

                    if remainingLives == 0 {
                        highScore = 0
                        remainingLives = 3
                    }
                }.buttonStyle(.borderedProminent)
                    .alert(isPresented: $showGameOverAlert) {
                        if highScore == 0 && remainingLives == 3 && lastPokémon?.name != "" {
                            return Alert(title: Text("Game over"), message: Text(lastPokémon?.name ?? ""))
                        } else {
                            return Alert(title: Text(lastPokémon?.name ?? ""),
                                         primaryButton: .cancel(), secondaryButton: .default(Text("Mehr über \(lastPokémon?.name ?? "") erfahren")) {
                                presentPokemon = lastPokémon
                            })
                        }
                    }
            }
        }.onAppear {
            Task {
                await viewModel.loadPokemons()
            }
        }
        .padding(16.0)
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}
