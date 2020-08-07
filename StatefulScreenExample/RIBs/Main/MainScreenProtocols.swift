//
//  MainScreenProtocols.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 08.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift

// MARK: - Builder

protocol MainScreenBuildable: Buildable {
  func build() -> MainScreenRouting
}

// MARK: - Router

protocol MainScreenInteractable: Interactable {
  var router: MainScreenRouting? { get set }
}

protocol MainScreenViewControllable: ViewControllable {}

// MARK: - Interactor

protocol MainScreenRouting: ViewableRouting {
  func routeToStackViewProfile()
  
  func routeToTableViewProfile()
}

// MARK: Outputs

struct MainScreenViewOutput {
  let stackViewButtonTap: ControlEvent<Void>
  let tableViewButtonTap: ControlEvent<Void>
}
