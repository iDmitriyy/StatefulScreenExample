//
//  MainScreenViewController.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 08.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

final class MainScreenViewController: UIViewController, MainScreenViewControllable {
  @IBOutlet private weak var stackViewScreenButton: UIButton!
  @IBOutlet private weak var tableViewScreenButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    initialSetup()
  }
}

extension MainScreenViewController {
  private func initialSetup() {}
}

// MARK: - BindableView

extension MainScreenViewController: BindableView {
  func getOutput() -> MainScreenViewOutput {
    return MainScreenViewOutput(stackViewButtonTap: stackViewScreenButton.rx.tap,
                                tableViewButtonTap: tableViewScreenButton.rx.tap)
  }

  func bindWith(_ input: Empty) {}
}

// MARK: - RibStoryboardInstantiatable

extension MainScreenViewController: RibStoryboardInstantiatable {}
