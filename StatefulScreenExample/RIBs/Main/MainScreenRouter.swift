//
//  MainScreenRouter.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 08.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import RxSwift
import RIBs

final class MainScreenRouter: ViewableRouter<MainScreenInteractable, MainScreenViewControllable>, MainScreenRouting {
  
  private let profileBuilder: ProfileBuildable
  
  private let disposeBag = DisposeBag()
  
  init(interactor: MainScreenInteractable,
                viewController: MainScreenViewControllable,
                profileBuilder: ProfileBuildable) {
    self.profileBuilder = profileBuilder
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func routeToStackViewProfile() {
    let router = profileBuilder.build()
    attachChild(router)
    viewController.uiviewController.navigationController?.pushViewController(router.viewControllable.uiviewController,
                                                                             animated: true)
    detachWhenClosed(child: router, disposedBy: disposeBag)
  }
  
  func routeToTableViewProfile() {
    let router = profileBuilder.buildScreenWithTableView()
    attachChild(router)
    viewController.uiviewController.navigationController?.pushViewController(router.viewControllable.uiviewController,
                                                                             animated: true)
    detachWhenClosed(child: router, disposedBy: disposeBag)
  }
}
