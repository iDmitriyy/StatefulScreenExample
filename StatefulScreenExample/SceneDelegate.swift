//
//  SceneDelegate.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 05.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
    guard let _ = (scene as? UIWindowScene) else { return }
  }
  
  func sceneDidDisconnect(_: UIScene) {}
  
  func sceneDidBecomeActive(_: UIScene) {}
  
  func sceneWillResignActive(_: UIScene) {}
  
  func sceneWillEnterForeground(_: UIScene) {}
  
  func sceneDidEnterBackground(_: UIScene) {}
}
