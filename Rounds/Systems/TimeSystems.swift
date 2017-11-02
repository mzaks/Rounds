//
//  TimeSystems.swift
//  Rounds
//
//  Created by Maxim Zaks on 30.10.17.
//  Copyright © 2017 Maxim Zaks. All rights reserved.
//

import EntitasKit
import CoreFoundation

final class ComputeDeltaTimeSystem: ExecuteSystem, InitSystem {
    func initialise() {
        ctx.setUniqueComponent(PreviousTimeComponent(value: CFAbsoluteTimeGetCurrent()))
    }
    func execute() {
        if let prevTime = ctx.uniqueComponent(PreviousTimeComponent.self)?.value {
            let currentTime = CFAbsoluteTimeGetCurrent()
            let delta = currentTime - prevTime
            ctx.setUniqueComponent(DeltaTimeComponent(value: delta))
            ctx.setUniqueComponent(PreviousTimeComponent(value: currentTime))
        }
    }
}

final class SetRoundProgressSystem: ReactiveSystem {
    let collector = ctx.collector(for: DeltaTimeComponent.matcher, type: .addedOrUpdated)
    func execute(entities: Set<Entity>) {
        guard ctx.uniqueComponent(AppStateComponent.self)?.value == .running,
            let e = ctx.uniqueEntity(CurrentRoundComponent.matcher),
            let delta = ctx.uniqueComponent(DeltaTimeComponent.self)?.value else {
            return
        }
        let progress = e.get(RoundProgressComponent.self)?.value ?? 0
        e += RoundProgressComponent(value: progress + delta)
    }
}

final class SwitchRoundsSystem: ReactiveSystem {
    let collector = ctx.collector(for: RoundProgressComponent.matcher, type: .addedOrUpdated)
    
    func execute(entities: Set<Entity>) {
        guard ctx.uniqueComponent(AppStateComponent.self)?.value == .running,
            entities.count == 1,
            let e = entities.first,
            let type = e.get(RoundTypeComponent.self)?.value,
            let initTime = ctx.uniqueComponent(InitTimeComponent.self)?.value,
            let onTime = ctx.uniqueComponent(OnTimeComponent.self)?.value,
            let offTime = ctx.uniqueComponent(OffTimeComponent.self)?.value else {
                return
        }
        let progress = e.get(RoundProgressComponent.self)?.value ?? 0
        
        func setNextRoundAsCurrent(){
            var found = false
            for e in ctx.group(RoundTypeComponent.matcher).sorted(){
                if found {
                    e += CurrentRoundComponent()
                    break
                } else {
                    if e.has(CurrentRoundComponent.cid) {
                        e -= CurrentRoundComponent.cid
                        found = true
                    }
                }
            }
        }
        
        switch type {
        case .setup:
            if progress >= Double(initTime) {
                setNextRoundAsCurrent()
            }
        case .work:
            if progress >= Double(onTime + offTime) {
                setNextRoundAsCurrent()
            }
        case .workWithoutRest:
            if progress >= Double(onTime) {
                resetValues()
            }
        }
    }
}

final class ChangeCurrentSecondSystem: ReactiveSystem {
    let collector = ctx.collector(for: RoundProgressComponent.matcher, type: .addedOrUpdated)
    func execute(entities: Set<Entity>) {
        entities.withEach { (e, c: RoundProgressComponent) in
            let currentSecond = e.get(CurrentSecondComponent.self)?.value ?? -1
            let progress = Int(c.value)
            if progress > currentSecond {
                e += CurrentSecondComponent(value: progress)
            }
        }
    }
}

final class RenderProgressSystem: ReactiveSystem {
    let collector = ctx.collector(for: CurrentSecondComponent.matcher, type: .addedOrUpdated)
    let presenters = appContext.group(RoundProgressPresenterComponent.matcher)
    func execute(entities: Set<Entity>) {
        presenters.withEach { (_, c: RoundProgressPresenterComponent) in
            c.ref?.presentProgress()
        }
    }
}
