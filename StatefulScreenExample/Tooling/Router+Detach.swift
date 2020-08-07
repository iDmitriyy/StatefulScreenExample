//
//  Router+Detach.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 08.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift

extension ViewableRouter {
  /**
   Метод для детача модуля из дерева RIB(ов), когда необходимо выполнить какие-то действия во время детача
   */
  public func detachWhenClosed(child: ViewableRouting,
                               disposedBy disposeBag: DisposeBag,
                               detachAction: (() -> Void)? = nil) {
    let vc = child.viewControllable.uiviewController
    vc.viewDidDisappearEvent.subscribe(onNext: { [weak self, weak vc] in
      /**
       (vc.isBeingDismissed || (vc.navigationController?.isBeingDismissed ?? false))
       необходимо для проверки что именно дисмиситься: UINavigationController или UIViewController
       */
      if let vc = vc,
        (vc.isBeingDismissed || (vc.navigationController?.isBeingDismissed ?? false)) || vc.isMovingFromParent {
        detachAction?()
        self?.detachChild(child)
      }
    }).disposed(by: disposeBag)
  }
}

public protocol ViewControllerLifeCycleObservable: AnyObject {
  var viewDidLoadEvent: ControlEvent<Void> { get }
  var viewWillAppearEvent: ControlEvent<Void> { get }
  var viewDidAppearEvent: ControlEvent<Void> { get }
  var viewWillDisappearEvent: ControlEvent<Void> { get }
  var viewDidDisappearEvent: ControlEvent<Void> { get }
}

/** Скрываем детали реализации возможностей подписки на события жизненного цикла ViewController'a за интерфейсом.
 Конформим UIViewControler'у протокол ViewControllerLifeCycle и создаёи дефолтную реализацию.
 Наследники UIViewControler могут переопределить любую проперти при необходимости.

 За основу было взято решение:
 https://github.com/ReactiveX/RxSwift/blob/master/Documentation/Traits.md#controlproperty--controlevent
 */
extension Reactive where Base: UIViewController {
  fileprivate var viewDidLoad: ControlEvent<Void> {
    let source = methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
    return ControlEvent(events: source)
  }

  fileprivate var viewWillAppear: ControlEvent<Void> {
    let source = methodInvoked(#selector(Base.viewWillAppear)).map { _ in Void() }
    return ControlEvent(events: source)
  }

  fileprivate var viewDidAppear: ControlEvent<Void> {
    let source = methodInvoked(#selector(Base.viewDidAppear)).map { _ in Void() }
    return ControlEvent(events: source)
  }

  fileprivate var viewWillDisappear: ControlEvent<Void> {
    let source = methodInvoked(#selector(Base.viewWillDisappear)).map { _ in Void() }
    return ControlEvent(events: source)
  }

  fileprivate var viewDidDisappear: ControlEvent<Void> {
    let source = methodInvoked(#selector(Base.viewDidDisappear)).map { _ in Void() }
    return ControlEvent(events: source)
  }
}

extension UIViewController: ViewControllerLifeCycleObservable {
  public var viewDidLoadEvent: ControlEvent<Void> { return rx.viewDidLoad }
  public var viewWillAppearEvent: ControlEvent<Void> { return rx.viewWillAppear }
  public var viewDidAppearEvent: ControlEvent<Void> { return rx.viewDidAppear }
  public var viewWillDisappearEvent: ControlEvent<Void> { return rx.viewWillDisappear }
  public var viewDidDisappearEvent: ControlEvent<Void> { return rx.viewDidDisappear }
}
