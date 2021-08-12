//
//  LoadingState.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 29.05.2020.
//  Copyright © 2020 IgnatyevProd. All rights reserved.
//

// MARK: - LoadingState

/// Состояние интеракторов, которое встречается на многих экранах..
/// L - Loading, D  - Data, E - Error
public enum LoadingState<D, E> {
  case isLoading
  case dataLoaded(D)
  case loadingError(E)
}

extension LoadingState: Equatable where D: Equatable, E: Equatable {}

extension LoadingState: Hashable where D: Hashable, E: Hashable {}

// MARK: - PagedLoadingState

/// На пагинированных списках загруженные данные хранятся не внутри enum'a, а в отдельном стриме (ScreenModel)
public enum PagedLoadingState<E: Error> {
  case initialDataLoading
  case initialDataLoaded
  case initialDataLoadingError(error: E)
  
  case nextPageLoading(nextPage: UInt)
  case nextPageDataLoaded
  case nextPageLoadingError(error: E, nextPage: UInt)
}

extension PagedLoadingState: GeneralizableState {
  /// case .initialDataLoading, case .nextPageLoading
  public var isLoadingState: Bool {
    switch self {
    case .initialDataLoading,
         .nextPageLoading:
      return true
      
    case .initialDataLoaded,
         .initialDataLoadingError,
         .nextPageDataLoaded,
         .nextPageLoadingError:
      return false
    }
  }
  
  /// case .initialDataLoaded, case .nextPageDataLoaded
  public var isDataLoadedState: Bool {
    switch self {
    case .initialDataLoaded,
         .nextPageDataLoaded:
      return true
      
    case .initialDataLoading,
         .initialDataLoadingError,
         .nextPageLoading,
         .nextPageLoadingError:
      return false
    }
  }

  /// case .initialDataLoadingError, case .nextPageLoadingError
  public var isLoadingErrorState: Bool {
    switch self {
    case .initialDataLoadingError,
         .nextPageLoadingError:
      return true
      
    case .initialDataLoading,
         .initialDataLoaded,
         .nextPageLoading,
         .nextPageDataLoaded:
      return false
    }
  }
}

extension PagedLoadingState: LoadingIndicatableState {
  public var shouldLoadingIndicatorBeVisible: Bool {
    switch self {
    case .initialDataLoading:
      return true
      
    case .initialDataLoaded,
         .initialDataLoadingError,
         .nextPageLoading,
         .nextPageDataLoaded,
         .nextPageLoadingError:
      return false
    }
  }
}

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
