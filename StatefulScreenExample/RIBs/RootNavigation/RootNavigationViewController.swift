//
//  RootNavigationViewController.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 08.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import RIBs
import RxSwift

final class RootNavigationViewController: UINavigationController, RootNavigationViewControllable {
  override func viewDidLoad() {
    super.viewDidLoad()
    initialSetup()
  }

  private func initialSetup() {}

  func setAsRootViewController(_ viewController: ViewControllable) {
    setViewControllers([viewController.uiviewController], animated: false)
  }
}
