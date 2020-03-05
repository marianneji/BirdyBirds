//
//  LevelData.swift
//  BirdyBirds
//
//  Created by Graphic Influence on 05/03/2020.
//  Copyright © 2020 marianne massé. All rights reserved.
//

import Foundation

struct LevelData {

    let birds: [String]

    init?(_ level: Int) {
        guard let levelDictionary = Levels.levelsDictionary["Level_\(level)"] as? [String: Any] else {
            return nil
        }
        guard let birds = levelDictionary["Birds"] as? [String] else {
            return nil
        }
        self.birds = birds
    }
}
