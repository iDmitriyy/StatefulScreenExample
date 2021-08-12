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
    filter { $0 != nil }.map { $0! }
  }
  
  public func mapAsVoid() -> Observable<Void> {
    map { _ in Void() }
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
  
  /// Оператор необходим, когда нужно держать текущую версию и предыдущую версию какой-либо модели. Первый элемент
  /// из SO будет использован и как previous и как current.
  public func previousAndCurrent<R>() -> Observable<(previous: R, current: R)> where Element == R {
    let previousAndCurrent = map { element -> R? in element }
      .scan(nil) { accumulator, newElement -> (previous: R, current: R)? in
        guard let newElement = newElement else { return nil }
        
        if let accumulator = accumulator {
          return (previous: accumulator.current, current: newElement)
        } else {
          return (previous: newElement, current: newElement)
        }
      }
      .compactMap()
    
    return previousAndCurrent
  }
  
  /// Возвращает Observable, который генерирует 1 элемент.
  /// В  отличии от оператора just(), после генерации 1 элемента не будет события 'onCompleted'.
  /// just() завершается событием 'onCompleted', а это не подходит для реализации логики и событий экранов).
  /// Также не стоит путать с Single<T> контрактом, который может сгенерировать либо 1 элемент, либо 'onError'.
  ///
  /// Оператор never() создает Observable, который генерирует onCompleted событие.
  /// Оператор error() создает Observable, который генерирует onError событие.
  /// Однако нет дефолтного оператора, который генерирует только 1 элемент. По этой причине создан этот оператор.
  ///
  /// - parameter element: Single element in the resulting observable sequence.
  /// - returns: An observable sequence containing the single specified element.
  public static func singleElement(_ element: Self.Element) -> Observable<Self.Element> {
    Observable<Element>.create { observer -> Disposable in
      observer.onNext(element)
      return Disposables.create()
    }
  }
  
  /// Ignores the elements of an observable sequence based on a predicate.
  ///
  /// - seealso: [filter operator on reactivex.io](http://reactivex.io/documentation/operators/filter.html)
  /// - seealso: [ignoreElements operator on reactivex.io](http://reactivex.io/documentation/operators/ignoreelements.html)
  ///
  /// - parameter predicate: A function to test each source element for a condition.
  /// - returns: An observable sequence that contains elements from the input sequence except those that satisfy the condition.
  public func ignoreWhen(_ predicate: @escaping (Element) throws -> Bool) -> Observable<Element> {
    filter { try !predicate($0) }
  }
  
  /// Partition a stream into two separate streams of elements that match, and don't match, the provided predicate.
  ///
  /// - parameter predicate: A predicate used to filter matching and non-matching elements.
  ///
  /// - returns: A tuple of two streams of elements that match, and don't match, the provided predicate.
  public func split(_ predicate: @escaping (Element) throws -> Bool)
    -> (matches: Observable<Element>, nonMatches: Observable<Element>) {
    let stream = map { ($0, try predicate($0)) }.share()
    
    let hits = stream.filter { $0.1 }.map { $0.0 }
    let misses = stream.filter { !$0.1 }.map { $0.0 }
    
    return (hits, misses)
  }
}

extension ObservableType {
  /// Оператор нужен для случаев, когда .asDriver(onErrorJustReturn:) не получается использовать
  /// Например для Driver<Profile> мы его исапользовать не можем, т.к создать профайл не получится, он приходт с бэка
  /// Если можно использовать стандартный оператор .asDriver(onErrorJustReturn:), то лучше использовать его
  public func asDriverIgnoringError() -> Driver<Element> {
    let signal = map { element -> Element? in element }.asDriver(onErrorJustReturn: nil).compactMap()
    return signal
  }
  
  /// Оператор нужен для случаев, когда .asSignal(onErrorJustReturn:) не получается использовать
  /// Например для Driver<Tariff> мы его использовать не можем, т.к создать тариф не получится, он приходит с бэка
  /// Если можно использовать стандартный оператор .asSignal(onErrorJustReturn:), то лучше использовать его
  public func asSignalIgnoringError() -> Signal<Element> {
    let signal = map { element -> Element? in element }.asSignal(onErrorJustReturn: nil).compactMap()
    return signal
  }
}

extension SharedSequenceConvertibleType {
  /// Для Driver'ов и Signal'ов
  public func compactMap<R>() -> RxCocoa.SharedSequence<Self.SharingStrategy, R> where Self.Element == R? {
    filter { $0 != nil }.map { $0! }
  }
}

/**
 Вовзращает замыкание для оператора .withLatestFrom(_:, resultSelector:)
 Замыкание возвращает те же самые параметры, что и получило
 Нужно для того, чтоб не писать этот код руками, т.к часто при использовании .withLatestFrom нужны
 данные из обоих исходных Observable
 **/
// public func latestFromBothValues<F, S>() -> ((F, S) -> (F, S)) {
//  let bothValuesResult: (F, S) -> (F, S) = { firstValue, secondValue in (firstValue, secondValue) }
//  return bothValuesResult
// }

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
