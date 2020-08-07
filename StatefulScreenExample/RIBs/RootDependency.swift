//
//  Dependency.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 07.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import RIBs

protocol RootDependency: Dependency {
  var profileService: ProfileService { get }
}
