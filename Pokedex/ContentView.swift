//
//  ContentView.swift
//  Pokedex
//
//  Created by Anh Dung Pham on 08.06.22.
//

import PokemonAPI
import NukeUI
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Image(systemName: "sleep.circle.fill")
                        NavigationLink(destination: PokedexView()) {
                            Text("Pokedex")
                        }
                    }
                }

                Section {
                    HStack {
                        Image(systemName: "sleep.circle.fill")
                        NavigationLink(destination: PokedexView()) {
                            Text("Pokemon Namen lernen")
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
