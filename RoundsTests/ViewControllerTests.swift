//
//  ViewControllerTests.swift
//  RoundsTests
//
//  Created by Maxim Zaks on 02.11.17.
//  Copyright © 2017 Maxim Zaks. All rights reserved.
//

import XCTest
import EntitasKit
@testable import Rounds

class ViewControllerTests: XCTestCase {
    
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
    
    func testExample() {
        // given
        let vc = ViewController()
        
        // when
        vc.viewDidLoad()
        
        // then
        XCTAssert(AppContext.buttonsPresenter === vc)
        XCTAssert(ctx.all([GreenButtonPressedComponent.cid]).count == 0)
        XCTAssert(ctx.all([RedButtonPressedComponent.cid]).count == 0)
        
        // when
        vc.greenButtonPressed()
        
        // then
        XCTAssert(ctx.all([GreenButtonPressedComponent.cid]).count == 1)
        
        // when
        vc.redButtonPressed()
        
        // then
        XCTAssert(ctx.all([RedButtonPressedComponent.cid]).count == 1)
    }
    
}
