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
        NavigationStack {
            QuizView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
