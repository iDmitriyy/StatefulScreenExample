//
//  StateTransformTrait.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 29.05.2020.
//  Copyright © 2020 IgnatyevProd. All rights reserved.
//

import RxCocoa
import RxSwift

/// Необходим для совместной передачи параметров состояний в методы StateTransform.
/// (таким образом заменили повторяющиеся 3 строчки на 1)
public struct StateTransformTrait<State> {
  public let readOnlyState: Observable<State>
  
  public let _state: BehaviorRelay<State>
  
  public let disposeBag: DisposeBag
  
  public init(_state: BehaviorRelay<State>, disposeBag: DisposeBag) {
    readOnlyState = _state.asObservable()
    self._state = _state
    
    self.disposeBag = disposeBag
  }
}
