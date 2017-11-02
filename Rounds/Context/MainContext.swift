//
//  MainContext.swift
//  Rounds
//
//  Created by Maxim Zaks on 22.10.17.
//  Copyright © 2017 Maxim Zaks. All rights reserved.
//

import EntitasKit
import CoreFoundation

var ctx = Context()

struct AppStateComponent: UniqueComponent {
    enum State {
        case selectRounds, selectOnTime, selectOffTime, selectInitTime, selectSummary, running, paused
        var isSelectionState: Bool {
            switch self {
            case .selectRounds, .selectOnTime, .selectOffTime, .selectInitTime:
                return true
            case .selectSummary, .running, .paused:
                return false
            }
        }
    }
    let value: State
}

struct NumberOfRoundsComponent: UniqueComponent {
    let value: Int
}

struct OnTimeComponent: UniqueComponent {
    let value: Int
}

struct OffTimeComponent: UniqueComponent {
    let value: Int
}

struct InitTimeComponent: UniqueComponent {
    let value: Int
}

struct GreenButtonPressedComponent: UniqueComponent {}
struct RedButtonPressedComponent: UniqueComponent {}

struct PreviousTimeComponent: UniqueComponent {
    let value: CFAbsoluteTime
}

struct DeltaTimeComponent: UniqueComponent {
    let value: CFTimeInterval
}

struct RoundTypeComponent: Component {
    enum `Type` {
        case setup, work, workWithoutRest
    }
    let value: Type
}

struct RoundProgressComponent: Component {
    let value: CFTimeInterval
}

struct CurrentSecondComponent: Component {
    let value: Int
}

struct CurrentRoundComponent: UniqueComponent {}

struct RoundIndexComponent: Component {
    let value: Int
}

enum MainContext {
    static var appState: AppStateComponent.State? {
        get {
            return ctx.uniqueComponent(AppStateComponent.self)?.value
        }
        set {
            if let v = newValue {
                ctx.setUniqueComponent(AppStateComponent(value: v))
            }
        }
    }
    static var numberOfRounds: Int? {
        get {
            return ctx.uniqueComponent(NumberOfRoundsComponent.self)?.value
        }
        set {
            if let v = newValue {
                ctx.setUniqueComponent(NumberOfRoundsComponent(value: v))
            }
        }
    }
    static var onTime: Int? {
        get {
            return ctx.uniqueComponent(OnTimeComponent.self)?.value
        }
        set {
            if let v = newValue {
                ctx.setUniqueComponent(OnTimeComponent(value: v))
            }
        }
    }
    static var offTime: Int? {
        get {
            return ctx.uniqueComponent(OffTimeComponent.self)?.value
        }
        set {
            if let v = newValue {
                ctx.setUniqueComponent(OffTimeComponent(value: v))
            }
        }
    }
    static var initTime: Int? {
        get {
            return ctx.uniqueComponent(InitTimeComponent.self)?.value
        }
        set {
            if let v = newValue {
                ctx.setUniqueComponent(InitTimeComponent(value: v))
            }
        }
    }
}
