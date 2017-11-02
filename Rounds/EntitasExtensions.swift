//
//  EntitasExtensions.swift
//  Rounds
//
//  Created by Maxim Zaks on 22.10.17.
//  Copyright © 2017 Maxim Zaks. All rights reserved.
//

import EntitasKit


extension System {
    var name: String {
        return String(describing: type(of: self))
    }
}

