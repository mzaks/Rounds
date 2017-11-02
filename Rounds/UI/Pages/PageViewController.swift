//
//  PageViewController.swift
//  Rounds
//
//  Created by Maxim Zaks on 29.10.17.
//  Copyright © 2017 Maxim Zaks. All rights reserved.
//

import UIKit

final class PagesViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var pages: [UIViewController] = []
    
    var currentState: AppStateComponent.State!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        let pageNames = ["RoundsVC", "ActionTimeVC", "CoolDownTimeVC", "InitPrepTimeVC", "selectionSummaryVC"]
        
        for name in pageNames {
            guard let page = storyboard?.instantiateViewController(withIdentifier: name) else {
                print("⚠️ \(name) not found")
                continue
            }
            pages.append(page)
        }
        
        MainContext.appState = .selectRounds
        appContext.setUniqueComponent(PagesPresenterComponent(ref: self))
        currentState = .selectRounds
        
        setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.index(of: viewController), currentIndex > 0 else {
            return nil
        }
        
        let previousIndex = (currentIndex - 1) % pages.count
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.index(of: viewController), currentIndex < pages.count - 1 else {
            return nil
        }
        let nextIndex = (currentIndex + 1) % pages.count
        return pages[nextIndex]
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.lightGray
        appearance.currentPageIndicatorTintColor = UIColor.gray
    }
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        setupPageControl()
        return pages.count
    }
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension PagesViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let vc = pendingViewControllers.first as? AppStateVC else {
            return
        }
        currentState = vc.state
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            MainContext.appState = currentState
        }
    }
}

extension PagesViewController: PagesPresenter {
    func showFirstPage() {
        setViewControllers([pages[0]], direction: .reverse, animated: true, completion: nil)
    }
}
