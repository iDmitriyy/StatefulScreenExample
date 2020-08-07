//
//  RootNavigationInteractor.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 08.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import RIBs
import RxSwift

final class RootNavigationInteractor: Interactor, RootNavigationInteractable {
  weak var router: RootNavigationRouting?
}
