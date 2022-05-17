//
//  PokemonContracts.swift
//  Pokemon
//
//  Created by ArdaSisli on 12.05.2022.
//

import Foundation

//MARK - ViewModel

protocol PokemonListViewModelProtocol {
    var delegate: PokemonListViewModelDelegate? { get set }
    func load(path: Int)
}

enum PokemonListViewModelOutPut {
    case pokemonList(Pokemon)
    case isLoading(Bool)
}

protocol PokemonListViewModelDelegate {
    func handleOutPut(_ output: PokemonListViewModelOutPut)
}
