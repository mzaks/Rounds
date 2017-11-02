//
//  ButtonPressedSystems.swift
//  Rounds
//
//  Created by Maxim Zaks on 22.10.17.
//  Copyright © 2017 Maxim Zaks. All rights reserved.
//

import EntitasKit

private let roundStep = 1
let minNumberOfRounds = 1
private let timeStep = 5
let minOnTime = 5
let minOffTime = 0
let minInitTime = 0
private let initTimeStep = 1

final class GreenButtonPressedSystem: ReactiveSystem {
    let name = "Green button pressed"
    
    let collector = ctx.collector(for: GreenButtonPressedComponent.matcher, type: .addedOrUpdated)
    
    func execute(entities: Set<Entity>) {
        guard let appState = ctx.uniqueComponent(AppStateComponent.self)?.value else {
            return
        }
        switch appState {
        case .selectRounds:
            addRounds(value: roundStep)
        case .selectOnTime:
            addOnTime(value: timeStep)
        case .selectOffTime:
            addOffTime(value: timeStep)
        case .selectInitTime:
            addInitTime(value: initTimeStep)
        case .selectSummary:
            startTimer()
        case .running:
            pauseTimer()
        case .paused:
            continueTimer()
        }
    }
}

final class RedButtonPressedSystem: ReactiveSystem {
    
    let collector = ctx.collector(for: RedButtonPressedComponent.matcher, type: .addedOrUpdated)
    
    func execute(entities: Set<Entity>) {
        guard let appState = ctx.uniqueComponent(AppStateComponent.self)?.value else {
            return
        }
        switch appState {
        case .selectRounds:
            addRounds(value: -roundStep)
        case .selectOnTime:
            addOnTime(value: -timeStep)
        case .selectOffTime:
            addOffTime(value: -timeStep)
        case .selectInitTime:
            addInitTime(value: -initTimeStep)
        case .selectSummary, .running, .paused:
            resetValues()
        }
    }
}

final class RemoveRoundsIfPresent: ReactiveSystem {
    let collector = ctx.collector(for: Matcher(any: [RedButtonPressedComponent.cid, GreenButtonPressedComponent.cid]), type: .addedOrUpdated)
    
    let rounds = ctx.all([RoundTypeComponent.cid])
    let presenters = appContext.all([RoundPresenterComponent.cid])
    
    func execute(entities: Set<Entity>) {
        if let state = ctx.uniqueComponent(AppStateComponent.self)?.value, state.isSelectionState {
            if rounds.isEmpty == false {
                if let roundsNumber = ctx.uniqueComponent(NumberOfRoundsComponent.self)?.value {
                    presenters.withEach { (_, c: RoundPresenterComponent) in
                        c.ref?.renderRounds(value: roundsNumber)
                    }
                }
            }
            for e in rounds {
                e.destroy()
            }
        }
        
    }
}

func addRounds(value: Int, lowerBound: Int = minNumberOfRounds) {
    let prevValue = ctx.uniqueComponent(NumberOfRoundsComponent.self)?.value ?? 0
    let newValue = max(lowerBound, prevValue + value)
    ctx.setUniqueComponent(NumberOfRoundsComponent(value: newValue))
}

func addOnTime(value: Int, lowerBound: Int = minOnTime) {
    let prevValue = ctx.uniqueComponent(OnTimeComponent.self)?.value ?? 0
    let newValue = max(lowerBound, prevValue + value)
    ctx.setUniqueComponent(OnTimeComponent(value: newValue))
}

func addOffTime(value: Int, lowerBound: Int = minOffTime) {
    let prevValue = ctx.uniqueComponent(OffTimeComponent.self)?.value ?? 0
    let newValue = max(lowerBound, prevValue + value)
    ctx.setUniqueComponent(OffTimeComponent(value: newValue))
}

func addInitTime(value: Int, lowerBound: Int = minInitTime) {
    let prevValue = ctx.uniqueComponent(InitTimeComponent.self)?.value ?? 0
    let newValue = max(lowerBound, prevValue + value)
    ctx.setUniqueComponent(InitTimeComponent(value: newValue))
}

func startTimer() {
    ctx.setUniqueComponent(AppStateComponent(value: .running))
    if let initTime = ctx.uniqueComponent(InitTimeComponent.self)?.value, initTime > 0 {
        let e = ctx.createEntity()
        e += RoundTypeComponent(value: .setup)
        e += RoundProgressComponent(value: 0)
    }
    guard let rounds = ctx.uniqueComponent(NumberOfRoundsComponent.self)?.value, rounds > 0 else {
        return
    }
    
    for i in 1...rounds {
        let e = ctx.createEntity()
        e += (i == rounds ? RoundTypeComponent(value: .workWithoutRest) : RoundTypeComponent(value: .work))
        e += RoundProgressComponent(value: 0)
        e += RoundIndexComponent(value: i)
    }
    
    ctx.group(RoundTypeComponent.matcher).sorted().first?.set(CurrentRoundComponent())
}

func pauseTimer() {
    ctx.setUniqueComponent(AppStateComponent(value: .paused))
}

func continueTimer() {
    ctx.setUniqueComponent(AppStateComponent(value: .running))
}

func resetValues() {
    AppContext.pagesPresenter?.showFirstPage()
    InitValuesSystem().initialise()
    ctx.setUniqueComponent(AppStateComponent(value: .selectRounds))
    for e in ctx.group(RoundTypeComponent.matcher) {
        e.destroy()
    }
}
