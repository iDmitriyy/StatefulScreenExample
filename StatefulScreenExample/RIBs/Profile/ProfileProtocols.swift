//
//  ProfileProtocols.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 07.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift

// MARK: - Builder

protocol ProfileBuildable: Buildable {
  func build() -> ProfileRouting
  
  func buildScreenWithTableView() -> ProfileRouting
}

// MARK: - Router

protocol ProfileInteractable: Interactable {
  var router: ProfileRouting? { get set }
}

protocol ProfileViewControllable: ViewControllable {}

// MARK: - Interactor

protocol ProfileRouting: ViewableRouting {
  /// Переход на экран смены e-mail'a
  func routeToEmailChange()
  
  /// Переход на экран добавления e-mail'a
  func routeToEmailAddition()
  
  func routeToOrdersList()
}

protocol ProfilePresentable: Presentable {}

// MARK: Outputs

typealias ProfileInteractorState = LoadingState<Profile, Error>

struct ProfilePresenterOutput {
  let viewModel: Driver<ProfileViewModel>
  let isContentViewVisible: Driver<Bool>
  
  let initialLoadingIndicatorVisible: Driver<Bool>
  let hideRefreshControl: Signal<Void>
  
  /// nil означает что нужно спрятать сообщение об ошибке
  let showError: Signal<ErrorMessageViewModel?>
}

protocol ProfileViewOutput {
  /// Добавление / изменение e-mail'a
  var emailUpdateTap: ControlEvent<Void> { get }
  
  var myOrdersTap: ControlEvent<Void> { get }
  
  var retryButtonTap: ControlEvent<Void> { get }
  
  var pullToRefresh: ControlEvent<Void> { get }
}

struct ProfileViewModel: Equatable {
  let firstName: TitledText
  let lastName: TitledText
  let middleName: TitledOptionalText
  
  let login: TitledText
  let email: TitledOptionalText
  let phone: TitledOptionalText
  
  let myOrders: String
}

struct ErrorMessageViewModel: Equatable {
  let title: String
  let buttonTitle: String
}
