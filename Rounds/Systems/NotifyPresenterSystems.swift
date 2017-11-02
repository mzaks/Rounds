//
//  NotifyPresenterSystems.swift
//  Rounds
//
//  Created by Maxim Zaks on 23.10.17.
//  Copyright © 2017 Maxim Zaks. All rights reserved.
//

import EntitasKit

final class NotifyRoundPresenterOnValueChangeSystem: ReactiveSystem {
    let collector = ctx.collector(for: NumberOfRoundsComponent.matcher, type: .addedOrUpdated)
    let listeners = appContext.all([RoundPresenterComponent.cid])
    
    func execute(entities: Set<Entity>) {
        guard let value = entities.first?.get(NumberOfRoundsComponent.self)?.value else { return }
        listeners.withEach { (_, c: RoundPresenterComponent) in
            c.ref?.renderRounds(value: value)
        }
    }
}

final class NotifyOnTimePresenterOnValueChangeSystem: ReactiveSystem {
    let collector = ctx.collector(for: OnTimeComponent.matcher, type: .addedOrUpdated)
    let listeners = appContext.all([OnTimePresenterComponent.cid])
    
    func execute(entities: Set<Entity>) {
        guard let value = entities.first?.get(OnTimeComponent.self)?.value else { return }
        listeners.withEach { (_, c: OnTimePresenterComponent) in
            c.ref?.render(onTime: value)
        }
    }
}

final class NotifyOffTimePresenterOnValueChangeSystem: ReactiveSystem {
    let collector = ctx.collector(for: OffTimeComponent.matcher, type: .addedOrUpdated)
    let listeners = appContext.all([OffTimePresenterComponent.cid])
    
    func execute(entities: Set<Entity>) {
        guard let value = entities.first?.get(OffTimeComponent.self)?.value else { return }
        listeners.withEach { (_, c: OffTimePresenterComponent) in
            c.ref?.render(offTime: value)
        }
    }
}

final class NotifyInitTimePresenterOnValueChangeSystem: ReactiveSystem {
    let collector = ctx.collector(for: InitTimeComponent.matcher, type: .addedOrUpdated)
    let listeners = appContext.all([InitTimePresenterComponent.cid])
    
    func execute(entities: Set<Entity>) {
        guard let value = entities.first?.get(InitTimeComponent.self)?.value else { return }
        listeners.withEach { (_, c: InitTimePresenterComponent) in
            c.ref?.render(initTime: value)
        }
    }
}

final class DisableRedButtonForNuberOfRoundsSystem: ReactiveSystem {
    let collector = ctx.collector(for: NumberOfRoundsComponent.matcher, type: .addedOrUpdated)
    
    func execute(entities: Set<Entity>) {
        guard let value = entities.first?.get(NumberOfRoundsComponent.self)?.value else { return }
        AppContext.buttonsPresenter?.redButton(enabled: value > minNumberOfRounds)
    }
}

final class DisableRedButtonForOnTimeSystem: ReactiveSystem {
    let collector = ctx.collector(for: OnTimeComponent.matcher, type: .addedOrUpdated)
    
    func execute(entities: Set<Entity>) {
        guard let value = entities.first?.get(OnTimeComponent.self)?.value else {
            return
        }
        AppContext.buttonsPresenter?.redButton(enabled: value > minOnTime)
    }
}

final class DisableRedButtonForOffTimeSystem: ReactiveSystem {
    let collector = ctx.collector(for: OffTimeComponent.matcher, type: .addedOrUpdated)
    
    func execute(entities: Set<Entity>) {
        guard let value = entities.first?.get(OffTimeComponent.self)?.value else { return }
        AppContext.buttonsPresenter?.redButton(enabled: value > minOffTime)
    }
}

final class DisableRedButtonForInitTimeSystem: ReactiveSystem {
    let collector = ctx.collector(for: InitTimeComponent.matcher, type: .addedOrUpdated)
    
    func execute(entities: Set<Entity>) {
        guard let value = entities.first?.get(InitTimeComponent.self)?.value else { return }
        AppContext.buttonsPresenter?.redButton(enabled: value > minInitTime)
    }
}

final class DisableRedButtonForAppStateUpdateSystem: ReactiveSystem {
    let collector = ctx.collector(for: AppStateComponent.matcher, type: .addedOrUpdated)
    
    func execute(entities: Set<Entity>) {
        guard let value = entities.first?.get(AppStateComponent.self)?.value else { return }
        let enabled: Bool
        switch value {
        case .selectRounds:
            enabled = minNumberOfRounds < ctx.uniqueComponent(NumberOfRoundsComponent.self)?.value ?? minNumberOfRounds
        case .selectOnTime:
            enabled = minOnTime < ctx.uniqueComponent(OnTimeComponent.self)?.value ?? minOnTime
        case .selectOffTime:
            enabled = minOffTime < ctx.uniqueComponent(OffTimeComponent.self)?.value ?? minOffTime
        case .selectInitTime:
            enabled = minInitTime < ctx.uniqueComponent(InitTimeComponent.self)?.value ?? minInitTime
        case .selectSummary, .paused:
            enabled = true
        case .running:
            enabled = false
        }
        AppContext.buttonsPresenter?.redButton(enabled: enabled)
    }
}

final class SetButtonLabelsSystem: ReactiveSystem {
    let collector = ctx.collector(for: AppStateComponent.matcher, type: .addedOrUpdated)
    
    func execute(entities: Set<Entity>) {
        guard let value = entities.first?.get(AppStateComponent.self)?.value else { return }
        let greenLabel: String
        let redLabel: String
        switch value {
        case .selectRounds, .selectOnTime, .selectOffTime, .selectInitTime:
            greenLabel = "🔼"
            redLabel = "🔽"
        case .selectSummary, .paused:
            greenLabel = "▶️"
            redLabel = "⏮"
        case .running:
            greenLabel = "⏸"
            redLabel = ""
        }
        AppContext.buttonsPresenter?.redButton(label: redLabel)
        AppContext.buttonsPresenter?.greenButton(label: greenLabel)
    }
}


final class InitValuePresentersSystem: ReactiveSystem {
    let collector = appContext.collector(for: Matcher(any: [RoundPresenterComponent.cid, OnTimePresenterComponent.cid, OffTimePresenterComponent.cid, InitTimePresenterComponent.cid]))
    
    func execute(entities: Set<Entity>) {
        entities.withEach { (_, c: RoundPresenterComponent) in
            if let rounds = ctx.uniqueComponent(NumberOfRoundsComponent.self)?.value {
                c.ref?.renderRounds(value: rounds)
            }
        }
        entities.withEach { (_, c: OnTimePresenterComponent) in
            if let time = ctx.uniqueComponent(OnTimeComponent.self)?.value {
                c.ref?.render(onTime: time)
            }
        }
        entities.withEach { (_, c: OffTimePresenterComponent) in
            if let time = ctx.uniqueComponent(OffTimeComponent.self)?.value {
                c.ref?.render(offTime: time)
            }
        }
        entities.withEach { (_, c: InitTimePresenterComponent) in
            if let time = ctx.uniqueComponent(InitTimeComponent.self)?.value {
                c.ref?.render(initTime: time)
            }
        }
    }
}
