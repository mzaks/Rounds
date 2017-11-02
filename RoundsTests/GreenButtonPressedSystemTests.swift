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

class GreenButtonPressedSystemTests: XCTestCase {
    
    var system: GreenButtonPressedSystem!
    
    override func setUp() {
        super.setUp()
        ctx = Context()
        system = GreenButtonPressedSystem()
    }
    
    override func tearDown() {
        super.tearDown()
        ctx = Context()
    }
    
    func testNoAppStateNoChanges() {
        // given
        
        // when
        pressGreenButtonAndExecuteSystem()
        pressGreenButtonAndExecuteSystem()
        pressGreenButtonAndExecuteSystem()
        
        // then
        XCTAssertNil(ctx.uniqueComponent(NumberOfRoundsComponent.self)?.value)
        XCTAssertNil(ctx.uniqueComponent(OnTimeComponent.self)?.value)
        XCTAssertNil(ctx.uniqueComponent(OffTimeComponent.self)?.value)
        XCTAssertNil(ctx.uniqueComponent(InitTimeComponent.self)?.value)
    }
    
    func testIncreaseRounds() {
        // given
        ctx.setUniqueComponent(AppStateComponent(value: .selectRounds))
        
        // when
        pressGreenButtonAndExecuteSystem()
        pressGreenButtonAndExecuteSystem()
        pressGreenButtonAndExecuteSystem()
        
        // then
        let value = ctx.uniqueComponent(NumberOfRoundsComponent.self)?.value
        XCTAssertEqual(value, 3)
    }
    
    func testIncreaseOnTime() {
        // given
        ctx.setUniqueComponent(AppStateComponent(value: .selectOnTime))
        
        // when
        pressGreenButtonAndExecuteSystem()
        pressGreenButtonAndExecuteSystem()
        pressGreenButtonAndExecuteSystem()
        
        // then
        let value = ctx.uniqueComponent(OnTimeComponent.self)?.value
        XCTAssertEqual(value, 15)
    }
    
    func testIncreaseOffTime() {
        // given
        ctx.setUniqueComponent(AppStateComponent(value: .selectOffTime))
        
        // when
        pressGreenButtonAndExecuteSystem()
        pressGreenButtonAndExecuteSystem()
        pressGreenButtonAndExecuteSystem()
        
        // then
        let value = ctx.uniqueComponent(OffTimeComponent.self)?.value
        XCTAssertEqual(value, 15)
    }
    
    func testIncreaseInitTime() {
        // given
        ctx.setUniqueComponent(AppStateComponent(value: .selectInitTime))
        
        // when
        pressGreenButtonAndExecuteSystem()
        pressGreenButtonAndExecuteSystem()
        pressGreenButtonAndExecuteSystem()
        
        // then
        let value = ctx.uniqueComponent(InitTimeComponent.self)?.value
        XCTAssertEqual(value, 3)
    }
    
    func testStartTimer() {
        // given
        ctx.setUniqueComponent(AppStateComponent(value: .selectSummary))
        
        ctx.setUniqueComponent(NumberOfRoundsComponent(value: 2))
        ctx.setUniqueComponent(InitTimeComponent(value: 3))
        
        // when
        pressGreenButtonAndExecuteSystem()
        
        // then
        let rounds = ctx.all([RoundTypeComponent.cid]).sorted()
        XCTAssertEqual(rounds[0].get(RoundTypeComponent.self)?.value, .setup)
        XCTAssertEqual(rounds[0].get(RoundProgressComponent.self)?.value, 0)
        XCTAssertEqual(rounds[0].has(CurrentRoundComponent.cid), true)
        
        XCTAssertEqual(rounds[1].get(RoundTypeComponent.self)?.value, .work)
        XCTAssertEqual(rounds[1].get(RoundProgressComponent.self)?.value, 0)
        XCTAssertEqual(rounds[1].get(RoundIndexComponent.self)?.value, 1)
        
        XCTAssertEqual(rounds[2].get(RoundTypeComponent.self)?.value, .workWithoutRest)
        XCTAssertEqual(rounds[2].get(RoundProgressComponent.self)?.value, 0)
        XCTAssertEqual(rounds[2].get(RoundIndexComponent.self)?.value, 2)
        
        XCTAssertEqual(ctx.uniqueComponent(AppStateComponent.self)?.value, .running)
    }
    
    func testPause() {
        // given
        ctx.setUniqueComponent(AppStateComponent(value: .running))
        
        // when
        pressGreenButtonAndExecuteSystem()
        
        // then
        XCTAssertEqual(ctx.uniqueComponent(AppStateComponent.self)?.value, .paused)
    }
    
    func testResume() {
        // given
        ctx.setUniqueComponent(AppStateComponent(value: .paused))
        
        // when
        pressGreenButtonAndExecuteSystem()
        
        // then
        XCTAssertEqual(ctx.uniqueComponent(AppStateComponent.self)?.value, .running)
    }
    
    private func pressGreenButtonAndExecuteSystem() {
        ctx.setUniqueComponent(GreenButtonPressedComponent())
        system.execute()
    }
}
