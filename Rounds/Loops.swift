//
//  Loops.swift
//  Rounds
//
//  Created by Maxim Zaks on 24.10.17.
//  Copyright © 2017 Maxim Zaks. All rights reserved.
//

import EntitasKit

var mainLoop = Loop(name: "main loop", systems: [
    InitValuesSystem(),
    ComputeDeltaTimeSystem()
])

var mainReactiveLoop = ReactiveLoop(ctx: ctx, systems: [
    GreenButtonPressedSystem(),
    RedButtonPressedSystem(),
    NotifyRoundPresenterOnValueChangeSystem(),
    NotifyOnTimePresenterOnValueChangeSystem(),
    NotifyOffTimePresenterOnValueChangeSystem(),
    NotifyInitTimePresenterOnValueChangeSystem(),
    DisableRedButtonForNuberOfRoundsSystem(),
    DisableRedButtonForOnTimeSystem(),
    DisableRedButtonForOffTimeSystem(),
    DisableRedButtonForInitTimeSystem(),
    DisableRedButtonForAppStateUpdateSystem(),
    SetButtonLabelsSystem(),
    SetRoundProgressSystem(),
    SwitchRoundsSystem(),
    ChangeCurrentSecondSystem(),
    RenderProgressSystem(),
    SetAppStateToPauseSystem(),
    RemoveRoundsIfPresent()
])

var appReactiveLoop = ReactiveLoop(ctx: appContext, systems: [
    InitValuePresentersSystem()
])
