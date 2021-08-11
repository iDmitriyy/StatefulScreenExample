//
//  ProfilePresenter.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 07.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift

final class ProfilePresenter: ProfilePresentable {}

// MARK: - IOTransformer

extension ProfilePresenter: IOTransformer {
  /// Метод отвечает за преобразование состояния во ViewModel'и и сигналы (команды)
  func transform(input state: Observable<ProfileInteractorState>) -> ProfilePresenterOutput {
    let viewModel = Helper.viewModel(state)
    
    let isContentViewVisible = state.compactMap { state -> Void? in
      // После загрузки 1-й порции данных контент всегда виден
      switch state {
      case .dataLoaded: return Void()
      case .loadingError, .isLoading: return nil
      }
    }
    .map { true }
    .startWith(false)
    .asDriverIgnoringError()
    
    let (initialLoadingIndicatorVisible, hideRefreshControl) = refreshLoadingIndicatorEvents(state: state)
    
    let showError = state.map { state -> ErrorMessageViewModel? in
      switch state {
      case .loadingError(let error):
        return ErrorMessageViewModel(title: error.localizedDescription, buttonTitle: "Повторить")
      case .isLoading, .dataLoaded:
        return nil
      }
    }
    // .distinctUntilChanged() - ⚠️ здесь этот оператор применять не нужно
    .asSignal(onErrorJustReturn: nil)
    
    return ProfilePresenterOutput(viewModel: viewModel,
                                  isContentViewVisible: isContentViewVisible,
                                  initialLoadingIndicatorVisible: initialLoadingIndicatorVisible,
                                  hideRefreshControl: hideRefreshControl,
                                  showError: showError)
  }
}

extension ProfilePresenter {
  private enum Helper: Namespace {
    static func viewModel(_ state: Observable<ProfileInteractorState>) -> Driver<ProfileViewModel> {
      return state.compactMap { state -> ProfileViewModel? in
        switch state {
        case .dataLoaded(let profile):
          let emailTitle: String = (profile.email == nil ? "Добавить e-mail" : "E-mail")
          
          return ProfileViewModel(firstName: TitledText(title: "Имя", text: profile.firstName),
                                  lastName: TitledText(title: "Фамилия", text: profile.lastName),
                                  middleName: TitledOptionalText(title: "Отчество", maybeText: profile.middleName),
                                  login: TitledText(title: "Никнейм", text: profile.login),
                                  email: TitledOptionalText(title: emailTitle, maybeText: profile.email),
                                  phone: TitledOptionalText(title: "Телефон", maybeText: profile.phone),
                                  myOrders: "Мои заказы")
          
        case .loadingError, .isLoading:
          return nil
        }
      }
      .distinctUntilChanged()
      .asDriverIgnoringError()
    }
  }
}
