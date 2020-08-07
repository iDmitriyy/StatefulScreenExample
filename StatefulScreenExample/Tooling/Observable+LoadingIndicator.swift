//
//  Observable+LoadingIndicator.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 29.05.2020.
//  Copyright © 2020 IgnatyevProd. All rights reserved.
//

import RxCocoa
import RxSwift

/// Generic решение для случаев, когда индикатор загрузки по центру экрана нужно показывать только при 1-й подгрузке данных.
/// При повторных загрузках из-за pullToRefresh уже будет виден UIRefreshControl. Его нужно необходимо прятать, когда данные
/// загрузились.
/// Метод корректно обрабатывает ситуацию, когда первчиная загрузка данных завершается ошибкой.
public func refreshLoadingIndicatorEvents<State: GeneralizableState & LoadingIndicatableState>(state: Observable<State>)
  -> (initialLoadingIndicatorVisible: Driver<Bool>, hideRefreshControl: Signal<Void>) {
    let didLoadData = state
      .map { state -> Void? in
        switch state.isDataLoadedState {
        case true: return Void()
        case false: return nil
        }
    }
    .compactMap()
    
    // initialLoadingIndicatorVisible (показ/сокрытие лоудера в центре экрана)
    // Только при первой загрузке данных должен отображаться лоудер в центре экрана
    let didLoadInitialData = didLoadData.take(prefix: 1)
    
    let isInitialDataLoaded = didLoadInitialData
      .map { _ in true }
      .startWith(false)
    
    let isLoading = state
      .map { $0.shouldLoadingIndicatorBeVisible }
    
    let initialLoadingIndicatorVisible = Observable.combineLatest(isInitialDataLoaded, isLoading)
      .map { isInitialDataLoaded, isLoading -> Bool in
        if isInitialDataLoaded {
          return false
        } else {
          return isLoading
        }
    }
    .distinctUntilChanged() //.loaderVisibilityObservable()
    .asDriverIgnoringError()
    
    // Биндим hideRefreshControl(сокрытие рефреш лоудера)
    let didLoadRefreshedData = didLoadData.skip(1)
    
    let hideRefreshControl = didLoadRefreshedData.asSignal(onErrorJustReturn: Void())
    
    return (initialLoadingIndicatorVisible, hideRefreshControl)
}
