//
//  Observable+filteredByState.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 12.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RxSwift

extension ObservableType {
  /// Оператор для случаев, когда в интеракторе необходимо фильтровать событие текущим состоянием. Например когда нажатие
  /// кнопки допустимо только в состоянии dataLoaded.
  /// Заменяет собой комбинацию операторов withLatestFrom + filter + map.
  ///
  /// ```
  /// event
  ///    .withLatestFrom(readonlyState, resultSelector: { ($0, $1) })
  ///    .filter { _, state in
  ///        switch state {
  ///        case .isLoading: return true
  ///        default: return false
  ///        }
  ///    }
  ///    .map { value, _ in value }
  /// ```
  public func filteredByState<State>(_ state: Observable<State>,
                                     filter predicate: @escaping (State) -> Bool,
                                     file: StaticString = #fileID,
                                     line: UInt = #line) -> Observable<Element> {
    let predicateAdapter: (Element, State) -> Bool = { _, state -> Bool in
      predicate(state)
    }
    
    return withLatestFrom(state, resultSelector: { ($0, $1) })
      .filter(predicateAdapter)
      .map { value, _ in value }
  }
  
  /// Оператор для случаев, когда в интеракторе необходимо фильтровать событие текущим состоянием. Например когда нажатие
  /// кнопки допустимо только в состоянии dataLoaded.
  /// Заменяет собой комбинацию операторов withLatestFrom + filter + map.
  ///
  /// Вместо оператора filter используется оператор compactMap, который выполняет ту же самую роль.
  /// Это нужно в случаях, когда вместе с фильтрацией требуется также извлечь данные из конкретного состояния.
  /// Если проводить аналогию с работой filter(), то значение типа U эквивалентно true, а nil эквивалентен false
  ///
  /// ```
  /// retryButtonTap
  ///   .withLatestFrom(readonlyState, resultSelector: { ($0, $1) })
  ///   .compactMap { _, state -> String? in
  ///     switch state {
  ///     case .requestError(_, smsCode): return smsCode
  ///     default: return nil
  ///     }
  ///   }
  /// ```
  public func filteredByState<State, U>(_ state: Observable<State>,
                                        filterMap: @escaping (_ state: State) -> U?,
                                        file: StaticString = #fileID,
                                        line: UInt = #line) -> Observable<(Element, U)> {
    let compactMapAdapter: (Element, State) -> (Element, U)? = { element, state -> (Element, U)? in
      let maybeOutput = filterMap(state)
      return maybeOutput.map { (element, $0) } // Элемент SO + результат функции compactMap
    }
    
    return withLatestFrom(state, resultSelector: { ($0, $1) })
      .compactMap(compactMapAdapter)
  }
  
  // MARK: - Синтаксически подслащённые варианты filteredByState
  
  /// см. filteredByState(_:, compactMap:) -> Observable<(Element, U)> .
  ///
  /// Отличие от указанного метода заключается в том, что если элемент Source Observable имеет тип Void, то элемент
  /// типа Void имеет смысл убрать из RO. Таким образом, мы получим только элемент типа U.
  ///
  /// Если его не убрать, то получается кортеж вида: (Void, U), где элемент типа Void:
  ///
  /// а) на практике не нужен
  ///
  /// б) мешает и вынуждает использовать оператор map чтоб от него избавиться. Пример: map { _, value in value }
  public func filteredByState<State, U>(_ state: Observable<State>,
                                        filterMap: @escaping (_ state: State) -> U?,
                                        file: StaticString = #fileID,
                                        line: UInt = #line) -> Observable<U> where Element == Void {
    let compactMapAdapter: (Element, State) -> U? = { _, state -> U? in
      let maybeOutput = filterMap(state)
      return maybeOutput // результат функции compactMap
    }
    
    return withLatestFrom(state, resultSelector: { ($0, $1) })
      .compactMap(compactMapAdapter)
  }
  
  /// см. filteredByState(_:, compactMap:) -> Observable<(Element, U)> .
  ///
  /// Отличие от указанного метода заключается в том, что compactMap используется как функция filter. Это бывает удобно,
  /// когда мы переиспользуем функции фильтрации.
  /// Рассмотрим такой случай:
  ///
  /// ```
  /// let showLoadingError = loadingError
  ///     .filteredByState(trait.readOnlyState, compactMap: byCheckingCodeState)
  /// ```
  ///
  /// showNearlySentError имеет тип Observable<(BaseError, String)>, а нам нужен Observable<BaseError>.
  /// При этом мы хотим переиспользовать существующую функцию фильтрации:
  /// ```
  /// private static let byCheckingCodeState: (State) -> String? = { state in
  ///     guard case let .checkingCode(smsCode) = state else { return nil }
  ///     return smsCode
  /// }
  /// ```
  /// Чаще всего эту функцию мы используем как compactMap, однако конкретно в данном случае хотим, чтобы она фактически работала как filter, и тем самым
  /// не добавляла к элементам SO результат compactMap. Таким образом, мы получим нужный нам тип 'BaseError',  а не <(BaseError, String)>.
  public func filteredByState<State, U>(_ state: Observable<State>,
                                        compactMapAsFilter compactMap: @escaping (State) -> U?)
    -> Observable<Element> {
    let filterAdapter: (State) -> Bool = { state in
      compactMap(state) == nil ? false : true
    }
    
    return filteredByState(state, filter: filterAdapter)
  }
}
