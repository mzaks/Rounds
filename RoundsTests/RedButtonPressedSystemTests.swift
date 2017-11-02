//
//  GreenButtonPressedSystemTests.swift
//  RoundsTests
//
//  Created by Maxim Zaks on 22.10.17.
//  Copyright © 2017 Maxim Zaks. All rights reserved.
//

import XCTest
import EntitasKit
@testable import Rounds

class RedButtonPressedSystemTests: XCTestCase {
    
    var system: RedButtonPressedSystem!
    
    override func setUp() {
        super.setUp()
        ctx = Context()
        appContext = Context()
        system = RedButtonPressedSystem()
    }
    
    override func tearDown() {
        super.tearDown()
        ctx = Context()
        appContext = Context()
    }
    
    func testNoAppStateNoChanges() {
        // given
        
        // when
        pressRedButtonAndExecuteSystem()
        pressRedButtonAndExecuteSystem()
        pressRedButtonAndExecuteSystem()
        
        // then
        XCTAssertNil(ctx.uniqueComponent(NumberOfRoundsComponent.self)?.value)
        XCTAssertNil(ctx.uniqueComponent(OnTimeComponent.self)?.value)
        XCTAssertNil(ctx.uniqueComponent(OffTimeComponent.self)?.value)
        XCTAssertNil(ctx.uniqueComponent(InitTimeComponent.self)?.value)
    }
    
    func testDecreaseRounds() {
        // given
        ctx.setUniqueComponent(AppStateComponent(value: .selectRounds))
        ctx.setUniqueComponent(NumberOfRoundsComponent(value: 5))
        
        // when
        pressRedButtonAndExecuteSystem()
        pressRedButtonAndExecuteSystem()
        pressRedButtonAndExecuteSystem()
        
        // then
        let value = ctx.uniqueComponent(NumberOfRoundsComponent.self)?.value
        XCTAssertEqual(value, 2)
        
        // when
        pressRedButtonAndExecuteSystem()
        pressRedButtonAndExecuteSystem()
        pressRedButtonAndExecuteSystem()
        
        // then
        let value2 = ctx.uniqueComponent(NumberOfRoundsComponent.self)?.value
        XCTAssertEqual(value2, 1)
    }
    
    func testDecreaseOnTime() {
        // given
        ctx.setUniqueComponent(AppStateComponent(value: .selectOnTime))
        ctx.setUniqueComponent(OnTimeComponent(value: 25))
        
        // when
        pressRedButtonAndExecuteSystem()
        pressRedButtonAndExecuteSystem()
        pressRedButtonAndExecuteSystem()
        
        // then
        let value = ctx.uniqueComponent(OnTimeComponent.self)?.value
        XCTAssertEqual(value, 10)
        
        // when
        pressRedButtonAndExecuteSystem()
        pressRedButtonAndExecuteSystem()
        pressRedButtonAndExecuteSystem()
        
        // then
        let value2 = ctx.uniqueComponent(OnTimeComponent.self)?.value
        XCTAssertEqual(value2, 5)
    }
    
    func testDecreaseOffTime() {
        // given
        ctx.setUniqueComponent(AppStateComponent(value: .selectOffTime))
        ctx.setUniqueComponent(OffTimeComponent(value: 25))
        
        // when
        pressRedButtonAndExecuteSystem()
        pressRedButtonAndExecuteSystem()
        pressRedButtonAndExecuteSystem()
        
        // then
        let value = ctx.uniqueComponent(OffTimeComponent.self)?.value
        XCTAssertEqual(value, 10)
        
        // when
        pressRedButtonAndExecuteSystem()
        pressRedButtonAndExecuteSystem()
        pressRedButtonAndExecuteSystem()
        
        // then
        let value2 = ctx.uniqueComponent(OffTimeComponent.self)?.value
        XCTAssertEqual(value2, 0)
    }
    
    func testDecreaseInitTime() {
        // given
        ctx.setUniqueComponent(AppStateComponent(value: .selectInitTime))
        ctx.setUniqueComponent(InitTimeComponent(value: 5))
        
        // when
        pressRedButtonAndExecuteSystem()
        pressRedButtonAndExecuteSystem()
        pressRedButtonAndExecuteSystem()
        
        // then
        let value = ctx.uniqueComponent(InitTimeComponent.self)?.value
        XCTAssertEqual(value, 2)
        
        // when
        pressRedButtonAndExecuteSystem()
        pressRedButtonAndExecuteSystem()
        pressRedButtonAndExecuteSystem()
        
        // then
        let value2 = ctx.uniqueComponent(InitTimeComponent.self)?.value
        XCTAssertEqual(value2, 0)
    }
    
    final class PagesPresenterMock: PagesPresenter {
        var showFirstPageCalled = 0
        func showFirstPage() {
            showFirstPageCalled += 1
        }
    }
    
    func testResetValues() {
        // given
        ctx.setUniqueComponent(AppStateComponent(value: .selectSummary))
        ctx.setUniqueComponent(NumberOfRoundsComponent(value: 5))
        ctx.setUniqueComponent(OnTimeComponent(value: 25))
        ctx.setUniqueComponent(OffTimeComponent(value: 15))
        ctx.setUniqueComponent(InitTimeComponent(value: 2))
        let presenter = PagesPresenterMock()
        
        appContext.setUniqueComponent(PagesPresenterComponent(ref: presenter))
        
        ctx.createEntity().set(RoundTypeComponent(value: .setup))
        
        // when
        pressRedButtonAndExecuteSystem()
        
        // then
        XCTAssertEqual(ctx.uniqueComponent(AppStateComponent.self)?.value, .selectRounds)
        XCTAssertEqual(ctx.uniqueComponent(NumberOfRoundsComponent.self)?.value, 4)
        XCTAssertEqual(ctx.uniqueComponent(OnTimeComponent.self)?.value, 20)
        XCTAssertEqual(ctx.uniqueComponent(OffTimeComponent.self)?.value, 10)
        XCTAssertEqual(ctx.uniqueComponent(InitTimeComponent.self)?.value, 3)
        XCTAssertEqual(presenter.showFirstPageCalled, 1)
    }
    
    final class RoundsPresenterMock: RoundPresenter {
        var roundsValues: [Int] = []
        func renderRounds(value: Int) {
            roundsValues.append(value)
        }
    }
    
    func testRemoveRounds(){
        // given
        let system = RemoveRoundsIfPresent()
        
        ctx.setUniqueComponent(AppStateComponent(value: .selectRounds))
        ctx.setUniqueComponent(NumberOfRoundsComponent(value: 5))
        let presenter = RoundsPresenterMock()
        appContext.createEntity().set(RoundPresenterComponent(ref: presenter))
        ctx.createEntity().set(RoundTypeComponent(value: .setup))
        
        // when
        ctx.setUniqueComponent(RedButtonPressedComponent())
        system.execute()
        
        // then
        XCTAssertEqual(presenter.roundsValues[0], 5)
        XCTAssert(ctx.all([RoundTypeComponent.cid]).isEmpty)
    }
    
    final class ButtonPresenterMock: ButtonsPresenter {
        func greenButton(label: String) {}
        func redButton(label: String) {}
        var values: [Bool] = []
        func redButton(enabled: Bool) {
            values.append(enabled)
        }
    }
    func testDisableButton(){
        // given
        let system = DisableRedButtonForAppStateUpdateSystem()
        let presenter = ButtonPresenterMock()
        appContext.setUniqueComponent(ButtonsPresenterComponent(ref: presenter))
        
        var index = 0
        
        func isEnabled(_ value: Bool){
            XCTAssertEqual(value, presenter.values[index], "index: \(index)")
            index += 1
        }
        
        // when
        ctx.setUniqueComponent(AppStateComponent(value: .selectRounds))
        system.execute()
        
        // then
        isEnabled(false)
        
        // when
        ctx.setUniqueComponent(NumberOfRoundsComponent(value: 1))
        ctx.setUniqueComponent(AppStateComponent(value: .selectRounds))
        system.execute()
        
        // then
        isEnabled(false)
        
        // when
        ctx.setUniqueComponent(NumberOfRoundsComponent(value: 2))
        ctx.setUniqueComponent(AppStateComponent(value: .selectRounds))
        system.execute()
        
        // then
        isEnabled(true)
        
        // when
        ctx.setUniqueComponent(AppStateComponent(value: .selectOnTime))
        system.execute()
        
        // then
        isEnabled(false)
        
        // when
        ctx.setUniqueComponent(OnTimeComponent(value: 5))
        ctx.setUniqueComponent(AppStateComponent(value: .selectOnTime))
        system.execute()
        
        // then
        isEnabled(false)
        
        // when
        ctx.setUniqueComponent(OnTimeComponent(value: 15))
        ctx.setUniqueComponent(AppStateComponent(value: .selectOnTime))
        system.execute()
        
        // then
        isEnabled(true)
        
        // when
        ctx.setUniqueComponent(AppStateComponent(value: .selectOffTime))
        system.execute()
        
        // then
        isEnabled(false)
        
        // when
        ctx.setUniqueComponent(OffTimeComponent(value: 0))
        ctx.setUniqueComponent(AppStateComponent(value: .selectOffTime))
        system.execute()
        
        // then
        isEnabled(false)
        
        // when
        ctx.setUniqueComponent(OffTimeComponent(value: 5))
        ctx.setUniqueComponent(AppStateComponent(value: .selectOffTime))
        system.execute()
        
        // then
        isEnabled(true)
        
        // when
        ctx.setUniqueComponent(AppStateComponent(value: .selectInitTime))
        system.execute()
        
        // then
        isEnabled(false)
        
        // when
        ctx.setUniqueComponent(InitTimeComponent(value: 0))
        ctx.setUniqueComponent(AppStateComponent(value: .selectInitTime))
        system.execute()
        
        // then
        isEnabled(false)
        
        // when
        ctx.setUniqueComponent(InitTimeComponent(value: 5))
        ctx.setUniqueComponent(AppStateComponent(value: .selectInitTime))
        system.execute()
        
        // then
        isEnabled(true)
        
        // when
        ctx.setUniqueComponent(AppStateComponent(value: .selectSummary))
        system.execute()
        
        // then
        isEnabled(true)
        
        // when
        ctx.setUniqueComponent(AppStateComponent(value: .paused))
        system.execute()
        
        // then
        isEnabled(true)
        
        // when
        ctx.setUniqueComponent(AppStateComponent(value: .running))
        system.execute()
        
        // then
        isEnabled(false)
    }
    
    private func pressRedButtonAndExecuteSystem() {
        ctx.setUniqueComponent(RedButtonPressedComponent())
        system.execute()
    }
}

