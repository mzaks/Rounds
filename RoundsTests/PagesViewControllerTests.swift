//
//  PagesViewControllerTests.swift
//  RoundsTests
//
//  Created by Maxim Zaks on 02.11.17.
//  Copyright © 2017 Maxim Zaks. All rights reserved.
//

import XCTest
import EntitasKit
@testable import Rounds

class PagesViewControllerTests: XCTestCase {
    
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
    
    func testSwitchState() {
        // given
        let pagesVC = PagesViewController()
        let page1 = RoundsSelectionVC()
        let page2 = OnTimeSelectionVC()
        pagesVC.pages = [page1, page2]
        
        // when
        pagesVC.viewDidLoad()
        
        // then
        XCTAssert(AppContext.pagesPresenter === pagesVC)
        XCTAssertEqual(MainContext.appState, .selectRounds)
        XCTAssertNil(pagesVC.pageViewController(UIPageViewController(), viewControllerBefore: page1))
        XCTAssert(pagesVC.pageViewController(UIPageViewController(), viewControllerBefore: page2) === page1)
        
        XCTAssertNil(pagesVC.pageViewController(UIPageViewController(), viewControllerAfter: page2))
        XCTAssert(pagesVC.pageViewController(UIPageViewController(), viewControllerAfter: page1) === page2)
        
        // when
        pagesVC.pageViewController(pagesVC, willTransitionTo: [page2])
        pagesVC.pageViewController(pagesVC, didFinishAnimating: true, previousViewControllers: [page1], transitionCompleted: true)
        
        // then
        XCTAssertEqual(MainContext.appState, .selectOnTime)
    }
}
