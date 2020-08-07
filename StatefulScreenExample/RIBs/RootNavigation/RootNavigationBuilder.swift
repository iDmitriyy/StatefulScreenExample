//
//  RootNavigationBuilder.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 08.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import RIBs

final class RootNavigationBuilder: Builder<RootDependency>, RootNavigationBuildable {
  func build() -> LaunchRouting {
    let viewController = RootNavigationViewController()

    let interactor = RootNavigationInteractor()

    return RootNavigationRouter(interactor: interactor,
                                viewController: viewController,
                                mainScreenBuilder: MainScreenBuilder(dependency: dependency))
  }
}
