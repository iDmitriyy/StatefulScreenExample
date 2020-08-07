//
//  RootNavigationRouter.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 08.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import RIBs

final class RootNavigationRouter: LaunchRouter<RootNavigationInteractable, RootNavigationViewControllable>, RootNavigationRouting {
  private let mainScreenBuilder: MainScreenBuildable
  
  init(interactor: RootNavigationInteractable,
       viewController: RootNavigationViewControllable,
       mainScreenBuilder: MainScreenBuildable) {
    self.mainScreenBuilder = mainScreenBuilder
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  override func didLoad() {
    super.didLoad()
    
    routeToMain()
  }
  
  func routeToMain() {
    let router = mainScreenBuilder.build()
    
    attachChild(router)
    
    self.viewController.setAsRootViewController(router.viewControllable)
  }
}
