//
//  InitValuesSystem.swift
//  Rounds
//
//  Created by Maxim Zaks on 24.10.17.
//  Copyright © 2017 Maxim Zaks. All rights reserved.
//

import EntitasKit

final class InitValuesSystem: InitSystem {
    func initialise() {
        MainContext.numberOfRounds = 4
        MainContext.initTime = 3
        MainContext.onTime = 20
        MainContext.offTime = 10
    }
}

final class SetAppStateToPauseSystem: ReactiveSystem {
    let collector = ctx.collector(for: AppStateComponent.matcher, type: .addedOrUpdated)
    
    let rounds = ctx.all([RoundTypeComponent.cid])
    
    func execute(entities: Set<Entity>) {
        if rounds.isEmpty == false && MainContext.appState == .selectSummary {
            ctx.setUniqueComponent(AppStateComponent(value: .paused))
        }
    }
}
