//
//  MainScreenBuilder.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 08.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import RIBs

final class MainScreenBuilder: Builder<RootDependency>, MainScreenBuildable {
  func build() -> MainScreenRouting {
    let viewController = MainScreenViewController.instantiateFromStoryboard()
    let interactor = MainScreenInteractor()

    VIPBinder.bind(viewController: viewController, interactor: interactor)

    return MainScreenRouter(interactor: interactor,
                            viewController: viewController,
                            profileBuilder: ProfileBuilder(dependency: dependency))
  }
}
