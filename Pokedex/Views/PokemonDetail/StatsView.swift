//
//  StatsView.swift
//  Pokedex
//
//  Created by Anh Dung Pham on 01.07.22.
//

import Charts
import RealmSwift
import SwiftUI

struct PokemonStatsView: View {
    var stats: MutableSet<PokemonStat>
    var foregroundStyle: Color

    var body: some View {
        Chart(stats, id: \.category) { value in
            BarMark(
                x: .value("Wert", value.baseValue),
                y: .value("Werte", value.category)
            ).foregroundStyle(foregroundStyle)
        }.frame(height: 200.0)
    }
}
