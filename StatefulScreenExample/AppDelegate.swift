//
//  AppDelegate.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 05.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import RIBs
import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  public var window: UIWindow?
  private var launchRouter: LaunchRouting?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    
    let appComponent = AppComponent()

    let builder = RootNavigationBuilder(dependency: appComponent)
    let launchRouter = builder.build()

    self.launchRouter = launchRouter
    launchRouter.launch(from: window)
    
//    window.rootViewController = UIViewController()
//    window.rootViewController?.view.backgroundColor = .cyan
//    window.makeKeyAndVisible()
    
    return true
  }
}
