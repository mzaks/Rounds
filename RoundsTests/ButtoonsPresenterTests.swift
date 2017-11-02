//
//  ButtoonsPresenterTests.swift
//  RoundsTests
//
//  Created by Maxim Zaks on 24.10.17.
//  Copyright © 2017 Maxim Zaks. All rights reserved.
//

import XCTest
import EntitasKit
@testable import Rounds

class ButtoonsPresenterTests: XCTestCase {
    
    final class ButtonsPresenterMock : ButtonsPresenter {
        var redEnabled: [Bool] = []
        func redButton(enabled: Bool) {
            redEnabled.append(enabled)
        }
        var greenLabels: [String] = []
        func greenButton(label: String) {
            greenLabels.append(label)
        }
        var redLabels: [String] = []
        func redButton(label: String) {
            redLabels.append(label)
        }
        
    }
    
    override func setUp() {
        super.setUp()
        ctx = Context()
        appContext = Context()
    }
    
    override func tearDown() {
        super.tearDown()
        ctx = Context()
        appContext = Context()
    }
    
    func testRedButtonChangedByRoundNumber() {
        // given
        let presenter = ButtonsPresenterMock()
        appContext.createEntity().set(ButtonsPresenterComponent(ref: presenter))
        let system = DisableRedButtonForNuberOfRoundsSystem()
        
        // when
        let e = ctx.createEntity().set(NumberOfRoundsComponent(value: 3))
        system.execute()
        
        // then
        XCTAssertEqual(presenter.redEnabled[0], true)
        
        // when
        e += NumberOfRoundsComponent(value:1)
        system.execute()
        
        // then
        XCTAssertEqual(presenter.redEnabled[0], true)
        XCTAssertEqual(presenter.redEnabled[1], false)
        
        // when
        e += NumberOfRoundsComponent(value:3)
        e.destroy()
        system.execute()
        
        // then
        XCTAssertEqual(presenter.redEnabled.count, 2)
    }
    
    func testRedButtonChangedByOnTime() {
        // given
        let presenter = ButtonsPresenterMock()
        appContext.createEntity().set(ButtonsPresenterComponent(ref: presenter))
        let system = DisableRedButtonForOnTimeSystem()
        
        // when
        let e = ctx.createEntity().set(OnTimeComponent(value: 10))
        system.execute()
        
        // then
        XCTAssertEqual(presenter.redEnabled[0], true)
        
        // when
        e += OnTimeComponent(value:5)
        system.execute()
        
        // then
        XCTAssertEqual(presenter.redEnabled[0], true)
        XCTAssertEqual(presenter.redEnabled[1], false)
        
        // when
        e += OnTimeComponent(value:15)
        e.destroy()
        system.execute()
        
        // then
        XCTAssertEqual(presenter.redEnabled.count, 2)
    }
    
    func testRedButtonChangedByOffTime() {
        // given
        let presenter = ButtonsPresenterMock()
        appContext.createEntity().set(ButtonsPresenterComponent(ref: presenter))
        let system = DisableRedButtonForOffTimeSystem()
        
        // when
        let e = ctx.createEntity().set(OffTimeComponent(value: 10))
        system.execute()
        
        // then
        XCTAssertEqual(presenter.redEnabled[0], true)
        
        // when
        e += OffTimeComponent(value:0)
        system.execute()
        
        // then
        XCTAssertEqual(presenter.redEnabled[0], true)
        XCTAssertEqual(presenter.redEnabled[1], false)
        
        // when
        e += OffTimeComponent(value:10)
        e.destroy()
        system.execute()
        
        // then
        XCTAssertEqual(presenter.redEnabled.count, 2)
    }
    
    func testRedButtonChangedByInitTime() {
        // given
        let presenter = ButtonsPresenterMock()
        appContext.createEntity().set(ButtonsPresenterComponent(ref: presenter))
        let system = DisableRedButtonForInitTimeSystem()
        
        // when
        let e = ctx.createEntity().set(InitTimeComponent(value: 10))
        system.execute()
        
        // then
        XCTAssertEqual(presenter.redEnabled[0], true)
        
        // when
        e += InitTimeComponent(value:0)
        system.execute()
        
        // then
        XCTAssertEqual(presenter.redEnabled[0], true)
        XCTAssertEqual(presenter.redEnabled[1], false)
        
        // when
        e += InitTimeComponent(value:10)
        e.destroy()
        system.execute()
        
        // then
        XCTAssertEqual(presenter.redEnabled.count, 2)
    }
    
    func testCahngeLabels() {
        
        // given
        let presenter = ButtonsPresenterMock()
        appContext.createEntity().set(ButtonsPresenterComponent(ref: presenter))
        let system = SetButtonLabelsSystem()
        
        let values: [(AppStateComponent.State, String, String)] = [
            (.selectRounds, "🔼", "🔽"),
            (.selectOnTime, "🔼", "🔽"),
            (.selectOffTime, "🔼", "🔽"),
            (.selectInitTime, "🔼", "🔽"),
            (.selectSummary, "▶️", "⏮"),
            (.running, "⏸", ""),
            (.paused, "▶️", "⏮")
        ]
        
        // when
        ctx.setUniqueComponent(AppStateComponent(value: .selectRounds))
        ctx.uniqueEntity(AppStateComponent.matcher)?.destroy()
        system.execute()
        
        // then
        XCTAssert(presenter.greenLabels.isEmpty)
        XCTAssert(presenter.redLabels.isEmpty)
        
        
        for (i, value) in values.enumerated() {
            // when
            ctx.setUniqueComponent(AppStateComponent(value: value.0))
            system.execute()
            // then
            XCTAssertEqual(value.1, presenter.greenLabels[i], "Index \(i) failed")
            XCTAssertEqual(value.2, presenter.redLabels[i], "Index \(i) failed")
        }
    }
    
}
