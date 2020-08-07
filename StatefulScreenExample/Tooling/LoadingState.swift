//
//  LoadingState.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 29.05.2020.
//  Copyright © 2020 IgnatyevProd. All rights reserved.
//

/// Состояние интеракторов, которое встречается на многих экранах..
/// L - Loading, D  - Data, E - Error
public enum LoadingState<D, E> {
  case isLoading
  case dataLoaded(D)
  case loadingError(E)
}

extension LoadingState: Equatable where D: Equatable, E: Equatable {}

extension LoadingState: Hashable where D: Hashable, E: Hashable {}

// MARK: - GeneralizableState

/// Состояние, которое предоставляет обобщенную информацию о том, что данные грузятся, загрузились или загрузка завершилась
/// ошибкой
public protocol GeneralizableState {
  var isLoadingState: Bool { get }
  var isDataLoadedState: Bool { get }
  var isLoadingErrorState: Bool { get }
}

extension LoadingState: GeneralizableState {
  public var isLoadingState: Bool {
    guard case .isLoading = self else { return false }
    return true
  }
  
  public var isDataLoadedState: Bool {
    guard case .dataLoaded = self else { return false }
    return true
  }
  
  public var isLoadingErrorState: Bool {
    guard case .loadingError = self else { return false }
    return true
  }
}

/// Протокол нужен для возможности использовать метод refreshLoadingIndicatorEvents(state:) с enum'ами состояний разных интеракторов.
/// Также может быть полезен для нужд  Presenter'ов.
public protocol LoadingIndicatableState {
  /// Сделано с целью более простой реализации isLoadingIndicatorVisible: Driver<Bool> в PresenterOutput'e.
  /// Эта проперти похожа на 'isLoadingState' у протокола GeneralizableState, однако её смысл отличается.
  /// Если интерактор находится в состоянии 'isLoadingState', это не обзятально означает что нужно показывать индикатор загрзки. Так бывает, например,
  /// на экранах предиктивного поиска: пока пользователь пишет текст в строке поиска, экран меняет своё состояние между 'isLoading' / 'dataLoaded', однако
  /// индикатор загрузки на экране не появляется.
  var shouldLoadingIndicatorBeVisible: Bool { get }
}

extension LoadingState: LoadingIndicatableState {
  public var shouldLoadingIndicatorBeVisible: Bool {
    guard case .isLoading = self else { return false }
    return true
  }
}
