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
        ctx.setUniqueComponent(NumberOfRoundsComponent(value: 4))
        ctx.setUniqueComponent(OnTimeComponent(value: 20))
        ctx.setUniqueComponent(OffTimeComponent(value: 10))
        ctx.setUniqueComponent(InitTimeComponent(value: 3))
    }
}

final class SetAppStateToPauseSystem: ReactiveSystem {
    let collector = ctx.collector(for: AppStateComponent.matcher, type: .addedOrUpdated)
    
    let rounds = ctx.all([RoundTypeComponent.cid])
    
    func execute(entities: Set<Entity>) {
        if rounds.isEmpty == false && ctx.uniqueComponent(AppStateComponent.self)?.value == .selectSummary {
            ctx.setUniqueComponent(AppStateComponent(value: .paused))
        }
    }
}
