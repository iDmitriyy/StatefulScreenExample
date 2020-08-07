//
//  Rx+Extension.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 07.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import RxCocoa
import RxSwift

extension ObservableType {
  public func compactMap<R>() -> Observable<R> where Element == R? {
    return filter { $0 != nil }.map { $0! }
  }

  public func filteredByState<State>(_ state: Observable<State>,
                                     filter predicate: @escaping (State) -> Bool) -> Observable<Element> {
    let predicateAdapter: (Element, State) -> Bool = { _, state -> Bool in
      predicate(state)
    }

    return withLatestFrom(state, resultSelector: latestFromBothValues())
      .filter(predicateAdapter)
      .map { value, _ in value }
  }

  public func mapAsVoid() -> Observable<Void> {
    return map { _ in Void() }
  }

  /// Оператор нужен для случаев, когда .asDriver(onErrorJustReturn:) не получается использовать
  /// Например для Driver<Profile> мы его исапользовать не можем, т.к создать профайл не получится, он приходт с бэка
  /// Если можно использовать стандартный оператор .asDriver(onErrorJustReturn:), то лучше использовать его
  public func asDriverIgnoringError() -> Driver<Element> {
    let signal = map { element -> Element? in element }.asDriver(onErrorJustReturn: nil).compactMap()
    return signal
  }
  
  /// Отличается от обычного оператора take(_ count: Int) тем, что не завершает последовательность терминальным событием onCompleted.
  public func take(prefix count: Int) -> RxSwift.Observable<Self.Element> {
    if count < 1 {
      return Observable.never()
    } else {
      return enumerated()
        .flatMapLatest { index, element -> Observable<Element> in
          index < count ? Observable.just(element) : Observable.never()
      }
    }
  }
}

//extension ControlEvent {
//  public func mapAsVoid() -> ControlEvent<Void> {
//    let voidEvents = map { _ in Void() }
//
//    return ControlEvent<Void>(events: voidEvents)
//  }
//}

extension SharedSequenceConvertibleType {
  /// Для Driver'ов и Signal'ов
  public func compactMap<R>() -> RxCocoa.SharedSequence<Self.SharingStrategy, R> where Self.Element == R? {
    return filter { $0 != nil }.map { $0! }
  }
}

/**
 Вовзращает замыкание для оператора .withLatestFrom(_:, resultSelector:)
 Замыкание возвращает те же самые параметры, что и получило
 Нужно для того, чтоб не писать этот код руками, т.к часто при использовании .withLatestFrom нужны
 данные из обоих исходных Observable
 **/
public func latestFromBothValues<F, S>() -> ((F, S) -> (F, S)) {
  let bothValuesResult: (F, S) -> (F, S) = { firstValue, secondValue in (firstValue, secondValue) }
  return bothValuesResult
}

extension PublishRelay {
  public func asControlEvent() -> ControlEvent<Element> {
    ControlEvent(events: self)
  }
}

extension ObservableType {
  /// Метод реализует повторяющуюся boilerplate конструкцию:
  ///
  /// ```
  /// .bind(to: trait._state)
  /// .disposed(by: trait.disposeBag)
  /// ```
  public func bindToAndDisposedBy(trait: StateTransformTrait<Element>) {
    bind(to: trait._state).disposed(by: trait.disposeBag)
  }
}
