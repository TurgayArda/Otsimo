//
//  PokemonVC.swift
//  Pokemon
//
//  Created by ArdaSisli on 12.05.2022.
//

import UIKit

class PokemonVC: UIViewController {
   
    //MARK: Views
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let imageSize = UIImage.SymbolConfiguration(pointSize: 180, weight: .bold , scale: .unspecified)
        let image = UIImage(systemName: "arrow.clockwise.circle.fill", withConfiguration: imageSize)
        image?.withTintColor(.white)
        button.setBackgroundImage(image, for: .normal)
        button.layer.cornerRadius = 40
        button.clipsToBounds = true
        button.tintColor = .systemGray
        button.backgroundColor = .white
        return button
    }()
    
    private lazy var pokemonView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 70
        v.clipsToBounds = true
        return v
    }()
    
    private lazy var pokemonTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 21)
        label.textColor = .black
        return label
    }()
    
    private lazy var pokemonArtwork: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var hp: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 19)
        label.textColor = .black
        label.text = PokemonListConstant.hp.rawValue
        return label
    }()
    
    private lazy var hpValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 19)
        label.textColor = .black
        return label
    }()
    
    private lazy var attack: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 19)
        label.textColor = .black
        label.text = PokemonListConstant.attack.rawValue
        return label
    }()
    
    private lazy var attackValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 19)
        label.textColor = .black
        return label
    }()
    
    private lazy var defense: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 19)
        label.textColor = .black
        label.text = PokemonListConstant.defense.rawValue
        return label
    }()
    
    private lazy var defenseValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 19)
        label.textColor = .black
        return label
    }()
    
    private lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 20)
        label.text = PokemonListConstant.loading.rawValue
        label.textColor = .black
        return label
    }()
    
    //MARK: - Proeprties
    
    var viewModel: PokemonListViewModelProtocol?
    private var pokemonCount = 1
    private var pokemonData: Pokemon?
    private var pokemonImage: String?
    private var pokemonName: String?
    private var pokemonStat: [Int]?

    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.delegate = self
        viewModel?.load(path: pokemonCount)
        configure()
        setupUI()
        touchDown()
        refresh()
    }
    
    //MARK: - Private Func
    
    private func configure() {
        view.addSubview(refreshButton)
        view.addSubview(pokemonView)
        pokemonView.addSubview(pokemonTitle)
        pokemonView.addSubview(pokemonArtwork)
        pokemonView.addSubview(hp)
        pokemonView.addSubview(hpValue)
        pokemonView.addSubview(defense)
        pokemonView.addSubview(defenseValue)
        pokemonView.addSubview(attack)
        pokemonView.addSubview(attackValue)
        pokemonView.addSubview(loadingLabel)
        view.backgroundColor = .systemIndigo
        pokemonView.backgroundColor = .white
    }
    
   private func refresh() {
        refreshButton.addTarget(self, action: #selector(resetCount(_:)), for: .touchUpInside)
    }
    
    @objc func resetCount(_ refreshButton: UIButton) {
        pokemonCount = 1
        viewModel?.load(path: pokemonCount)
        getValue()
    }
    
    private func getValue() {
        guard let urlImage = pokemonImage else { return }
        guard let value = pokemonStat else { return }
        if let url = URL(string: "\(urlImage)") {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                guard let dataTwo = data else { return }
                DispatchQueue.main.async {
                    self.pokemonArtwork.image = UIImage(data: dataTwo)
                    self.pokemonTitle.text = self.pokemonName
                    self.hpValue.text = "\(value[0])"
                    self.attackValue.text = "\(value[1])"
                    self.defenseValue.text = "\(value[2])"
                }
            }
        }
    }
    
    private func isLoading(Loading: Bool) {
        if Loading {
            DispatchQueue.main.async {
                self.loadingLabel.isHidden = true
                self.pokemonTitle.isHidden = false
                self.hp.isHidden = false
                self.hpValue.isHidden = false
                self.defense.isHidden = false
                self.defenseValue.isHidden = false
                self.attack.isHidden = false
                self.attackValue.isHidden = false
                self.pokemonArtwork.isHidden = false
            }
        } else {
            pokemonTitle.isHidden = true
            hp.isHidden = true
            hpValue.isHidden = true
            defense.isHidden = true
            defenseValue.isHidden = true
            attack.isHidden = true
            attackValue.isHidden = true
            pokemonArtwork.isHidden = true
        }
    }

}

//MARK: - PokemonListViewModelDelegate

extension PokemonVC: PokemonListViewModelDelegate {
    func handleOutPut(_ output: PokemonListViewModelOutPut) {
        switch output {
        case .pokemonList(let pokemon):
            self.pokemonData = pokemon
            pokemonImage = pokemonData?.sprites.other?.officialArtwork.frontDefault
            pokemonName = pokemonData?.forms.map({ $0.name }).joined(separator: " , ")
            pokemonStat = pokemonData?.stats.map({ $0.baseStat })
            if pokemonCount == 1 {
                getValue()
            }
        case .isLoading(let loading):
            isLoading(Loading: loading)
        }
    }
}

//MARK: - Animation

extension PokemonVC {
    func touchDown() {
        let touchDown = UITapGestureRecognizer(target: self, action: #selector(self.touchDownMethod))
        pokemonView.addGestureRecognizer(touchDown)
    }

    @objc func touchDownMethod() {
        viewModel?.load(path: pokemonCount)
        self.getValue()
        self.pokemonCount += 1
        
        let radians = 180 * Double.pi/180
        let radiansTwo = 0 * Double.pi/180
        UIView.animate(withDuration: 2, animations: {
            self.pokemonView.transform = CGAffineTransform(rotationAngle: radiansTwo)
            let yRotation = CATransform3DMakeRotation(radians, 0,radians, 0)
            self.pokemonView.layer.transform = CATransform3DConcat(self.pokemonView.layer.transform, yRotation )
            self.pokemonView.transform = CGAffineTransform(rotationAngle: radiansTwo)
            self.viewModel?.load(path: self.pokemonCount)
           
        }) { bool in
        UIView.animate(withDuration: 2, animations: {
            self.getValue()
            self.pokemonView.transform = CGAffineTransform(rotationAngle: radiansTwo)
            let xRotation = CATransform3DMakeRotation(radians, radians,0, 0)
            self.pokemonView.layer.transform = CATransform3DConcat(self.pokemonView.layer.transform, xRotation)
            self.pokemonView.transform = CGAffineTransform(rotationAngle: radiansTwo)
            })
        }
    }
}

//MARK: - Constraint

extension PokemonVC {
    private func setupUI() {
        NSLayoutConstraint.activate([
            refreshButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            refreshButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            refreshButton.heightAnchor.constraint(equalToConstant: 80),
            refreshButton.widthAnchor.constraint(equalToConstant: 80),
            ])
        
        
        NSLayoutConstraint.activate([
            pokemonView.topAnchor.constraint(equalTo: refreshButton.bottomAnchor, constant: (view.frame.height / 4.5) - 100 ),
            pokemonView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.frame.width / 7.5),
            pokemonView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -(view.frame.width / 7.5)),
            pokemonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(view.frame.height / 4.5)),
            ])
        
        NSLayoutConstraint.activate([
            loadingLabel.centerYAnchor.constraint(equalTo: pokemonView.centerYAnchor),
            loadingLabel.centerXAnchor.constraint(equalTo: pokemonView.centerXAnchor),
            ])
        
        NSLayoutConstraint.activate([
            pokemonTitle.topAnchor.constraint(equalTo: pokemonView.safeAreaLayoutGuide.topAnchor, constant: 30),
            pokemonTitle.centerXAnchor.constraint(equalTo: pokemonView.centerXAnchor),
            ])
        
        NSLayoutConstraint.activate([
            pokemonArtwork.heightAnchor.constraint(equalToConstant: view.frame.height / 5),
            pokemonArtwork.widthAnchor.constraint(equalToConstant: view.frame.width / 5.5),
            pokemonArtwork.centerYAnchor.constraint(equalTo: pokemonView.centerYAnchor),
            pokemonArtwork.centerXAnchor.constraint(equalTo: pokemonView.centerXAnchor),
          
            ])
        
        NSLayoutConstraint.activate([
            hp.bottomAnchor.constraint(equalTo: pokemonView.bottomAnchor, constant: -(view.frame.height / 15)),
            hp.rightAnchor.constraint(equalTo: defense.leftAnchor, constant: -(view.frame.width / 8)),
            ])
        
        NSLayoutConstraint.activate([
            hpValue.topAnchor.constraint(equalTo: hp.bottomAnchor, constant: 5),
            hpValue.centerXAnchor.constraint(equalTo: hp.centerXAnchor),
            ])
        
        NSLayoutConstraint.activate([
            defense.bottomAnchor.constraint(equalTo: pokemonView.bottomAnchor, constant: -(view.frame.height / 15)),
            defense.centerXAnchor.constraint(equalTo: pokemonView.centerXAnchor)
            ])
        
        NSLayoutConstraint.activate([
            defenseValue.topAnchor.constraint(equalTo: defense.bottomAnchor, constant: 5),
            defenseValue.centerXAnchor.constraint(equalTo: defense.centerXAnchor),
            ])
        
        NSLayoutConstraint.activate([
            attack.bottomAnchor.constraint(equalTo: pokemonView.bottomAnchor, constant: -(view.frame.height / 15)),
            attack.leftAnchor.constraint(equalTo: defense.rightAnchor, constant: view.frame.width / 9),
            ])
        
        NSLayoutConstraint.activate([
            attackValue.topAnchor.constraint(equalTo: attack.bottomAnchor, constant: 5),
            attackValue.centerXAnchor.constraint(equalTo: attack.centerXAnchor),
            ])
    }
}
