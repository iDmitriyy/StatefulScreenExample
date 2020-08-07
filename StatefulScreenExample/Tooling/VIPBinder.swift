//
//  VIPBinder.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 07.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import UIKit

public enum VIPBinder: Namespace {
  public typealias VIPOutput<V, I, P> = (viewOutput: V, interactorOutput: I, presenterOutput: P)
  public typealias VIOutput<V, I> = (viewOutput: V, interactorOutput: I)
  
  public struct DeferredVIPOutput<VOutput, IOutput, POutput> {
    public let viewOutput: VOutput
    public let interactorOutput: IOutput
    public let presenterOutput: POutput
  }
  
  /// Новый вариант бингдинга, без принудительной загрузки вью. Название временное, поменять после рефакторинга.
  @discardableResult
  public static func unforcedBind<V, I, P>(view: V, interactor: I, presenter: P)
    -> VIPOutput<V.Output, I.Output, P.Output>
    where V: BindableView, I: IOTransformer, P: IOTransformer,
    V.Output == I.Input, I.Output == P.Input, P.Output == V.Input {
    let viewOutput = view.getOutput()
    let interactorOutput = interactor.transform(viewOutput)
    let presenterOutput = presenter.transform(interactorOutput)
    view.bindWith(presenterOutput)
    
    return (viewOutput: viewOutput, interactorOutput: interactorOutput, presenterOutput: presenterOutput)
  }
  
  /// Вариант бингдинга, когда данные от View (UIViewController) поступают сразу в Interactor (минуя Prseneter).
  @discardableResult
  public static func bind<V, I, P>(view viewController: V, interactor: I, presenter: P)
    -> VIPOutput<V.Output, I.Output, P.Output>
    where V: BindableView & UIViewController, I: IOTransformer, P: IOTransformer,
    V.Output == I.Input, I.Output == P.Input, P.Output == V.Input {
    viewController.loadViewIfNeeded()
    let viewOutput = viewController.getOutput()
    let interactorOutput = interactor.transform(viewOutput)
    let presenterOutput = presenter.transform(interactorOutput)
    viewController.bindWith(presenterOutput)
    
    return (viewOutput: viewOutput, interactorOutput: interactorOutput, presenterOutput: presenterOutput)
  }
  
  /** Для случаев, когда loadViewIfNeeded() у вьюконтрлллера не может быть вызван.
   Метод возвращает замыкание, которое должно быть выполнено 1 раз в методе viewDidLoad у ViewCintroller'a
   */
  public static func deferredBinding<V, I, P>(view viewController: V,
                                              interactor: I,
                                              presenter: P,
                                              completion: @escaping (DeferredVIPOutput<V.Output, I.Output, P.Output>) -> Void)
    -> VoidClosure where V: BindableView & UIViewController, I: IOTransformer, P: IOTransformer,
    V.Output == I.Input, I.Output == P.Input, P.Output == V.Input {
    let deferredBinding: VoidClosure = { [weak viewController, weak interactor, weak presenter] in
      guard let viewController = viewController, let interactor = interactor, let presenter = presenter else {
        return
      }
      
      // У вьюконтроллера loadViewIfNeeded() не вызываем
      let viewOutput = viewController.getOutput()
      let interactorOutput = interactor.transform(viewOutput)
      let presenterOutput = presenter.transform(interactorOutput)
      viewController.bindWith(presenterOutput)
      
      let vipOutput = DeferredVIPOutput(viewOutput: viewOutput,
                                        interactorOutput: interactorOutput,
                                        presenterOutput: presenterOutput)
      completion(vipOutput)
    }
    
    return deferredBinding
  }
  
  /// Вариант биндинга, когда в модуле отсутствует Preseneter
  @discardableResult
  public static func bind<V: BindableView & UIViewController, I: IOTransformer>(viewController: V,
                                                                                interactor: I) -> VIOutput<V.Output, I.Output>
    where V.Output == I.Input, I.Output == V.Input {
    viewController.loadViewIfNeeded()
    let viewOutput = viewController.getOutput()
    let interactorOutput = interactor.transform(viewOutput)
    viewController.bindWith(interactorOutput)
    
    return (viewOutput: viewOutput, interactorOutput: interactorOutput)
  }
  
  /// Вариант отложенного биндинга, когда в модуле отсутствует Preseneter
  public static func deferredBinding<V, I>(view viewController: V,
                                           interactor: I,
                                           completion: @escaping (VIOutput<V.Output, I.Output>) -> Void)
    -> VoidClosure where V: BindableView & UIViewController, I: IOTransformer,
    V.Output == I.Input, I.Output == V.Input {
    let deferredBinding: VoidClosure = { [weak viewController, weak interactor] in
      guard let viewController = viewController, let interactor = interactor else {
        return
      }
      
      // У вьюконтроллера loadViewIfNeeded() не вызываем
      let viewOutput = viewController.getOutput()
      let interactorOutput = interactor.transform(viewOutput)
      viewController.bindWith(interactorOutput)
      
      let vipOutput: VIOutput = (viewOutput, interactorOutput)
      completion(vipOutput)
    }
    
    return deferredBinding
  }
}
