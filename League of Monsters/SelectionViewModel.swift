//
//  SelectionViewModel.swift
//  League of Monsters
//
//  Created by Aniello Ambrosio on 01/03/22.
//

import SwiftUI

struct SelectionViewModel{
    let cities = ["Bonkie Town", "Dumbai", "New Fork"]
    
    let monsters = [Image("Dogezilla Icon"), Image("Bearasputin Icon"), Image("Basedlisk Icon"), Image("Corgirus Icon"), Image("Beehemoth Icon"), Image("Lizarro Icon")]
    
    let monstersName = ["Dogezilla", "Bearasputin", "Basedlisk", "Corgirus", "Beehemoth", "Lizarro",]
    
    let columns = [
        GridItem(.fixed(70), spacing: 40),
        GridItem(.fixed(70), spacing: 40),
        GridItem(.fixed(70), spacing: 40)
    ]
}

