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
    let collector = ctx.collector(for: GreenButtonPressedComponent.matcher, type: .addedOrUpdated)
    
    func execute(entities: Set<Entity>) {
        guard let appState = MainContext.appState else {
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
        guard let appState = MainContext.appState else {
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
        if let state = MainContext.appState, state.isSelectionState {
            if rounds.isEmpty == false {
                if let roundsNumber = MainContext.numberOfRounds {
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
    let prevValue = MainContext.numberOfRounds ?? 0
    let newValue = max(lowerBound, prevValue + value)
    MainContext.numberOfRounds = newValue
}

func addOnTime(value: Int, lowerBound: Int = minOnTime) {
    let prevValue = MainContext.onTime ?? 0
    let newValue = max(lowerBound, prevValue + value)
    MainContext.onTime = newValue
}

func addOffTime(value: Int, lowerBound: Int = minOffTime) {
    let prevValue = MainContext.offTime ?? 0
    let newValue = max(lowerBound, prevValue + value)
    MainContext.offTime = newValue
}

func addInitTime(value: Int, lowerBound: Int = minInitTime) {
    let prevValue = MainContext.initTime ?? 0
    let newValue = max(lowerBound, prevValue + value)
    MainContext.initTime = newValue
}

func startTimer() {
    ctx.setUniqueComponent(AppStateComponent(value: .running))
    if let initTime = MainContext.initTime, initTime > 0 {
        let e = ctx.createEntity()
        e += RoundTypeComponent(value: .setup)
        e += RoundProgressComponent(value: 0)
    }
    guard let rounds = MainContext.numberOfRounds, rounds > 0 else {
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
    MainContext.appState = .paused
}

func continueTimer() {
    MainContext.appState = .running
}

func resetValues() {
    AppContext.pagesPresenter?.showFirstPage()
    InitValuesSystem().initialise()
    MainContext.appState = .selectRounds
    for e in ctx.group(RoundTypeComponent.matcher) {
        e.destroy()
    }
}
