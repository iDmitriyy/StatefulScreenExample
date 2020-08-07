//
//  StoryboardInstantiatable.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 07.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import UIKit

/** Протокольное решение инициализации viewController'ов из StoryBoard'a
 Условия работы фичи: storyboardId в Storyboard должен быть названием класса */
public protocol StoryboardInstantiatable: AnyObject {
  static var storyboardId: String { get }
  static var storyboardName: String { get }
}

extension StoryboardInstantiatable where Self: UIViewController {
  public static var storyboardId: String {
    return String(describing: self)
  }

  private static func instantiateFromStoryboard(inBundle storyboardBundle: Bundle) -> Self {
    let identifier = storyboardId
    let storyboard = UIStoryboard(name: storyboardName, bundle: storyboardBundle)

    let viewController = storyboard
      .instantiateViewController(withIdentifier: identifier) as! Self // swiftlint:disable:this force_cast
    return viewController
  }

  public static func instantiateFromStoryboard() -> Self {
    return instantiateFromStoryboard(inBundle: Bundle(for: self))
  }
}

/** Протокольное решение инициализации viewController'а для случаев, когда внутри 1-го сториборда находится 1 ViewController */
public protocol RibStoryboardInstantiatable: StoryboardInstantiatable {}

extension RibStoryboardInstantiatable where Self: UIViewController {
  public static var storyboardName: String {
    return storyboardId
  }
}
