//
//  PokemonBuilder.swift
//  Pokemon
//
//  Created by ArdaSisli on 12.05.2022.
//

import Foundation

final class PokemonListBuilder {
    static func make() -> PokemonVC {
        let view = PokemonVC()
        let viewModel = PokemonViewModel(service: PokemonService())
        view.viewModel = viewModel
        return view
    }
}
