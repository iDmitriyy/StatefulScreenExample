//
//  AppComponent.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 08.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import RIBs

final class AppComponent: Component<EmptyDependency>, RootDependency {
  let profileService: ProfileService = ProfileServiceImp()
  
  init() {
    super.init(dependency: EmptyComponent())
  }
}
