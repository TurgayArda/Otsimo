//
//  PokemonService.swift
//  Pokemon
//
//  Created by ArdaSisli on 12.05.2022.
//

import Foundation

protocol IPokemonService {
    func fetchAllData(
        path: (Int),
        onSuccess: @escaping (Pokemon) -> Void
    )
}

class PokemonService: IPokemonService {
    func fetchAllData(path: (Int), onSuccess: @escaping (Pokemon) -> Void) {
        let url = URL(string: NetworkConstant.pokemonListPath(path: path))!
        URLSession.shared.dataTask(with: url) { (data,respone,error) in
            if error != nil || data == nil {
                return
            }
            
            do {
                let pokemonData = try JSONDecoder().decode(Pokemon.self, from: data!)
                onSuccess(pokemonData)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
