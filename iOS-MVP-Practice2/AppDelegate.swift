//
//  AppDelegate.swift
//  iOS-MVP-Practice2
//
//  Created by 坂本龍哉 on 2021/04/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! SearchMovieViewController
        let model = SearchMovieModel()
        let presenter = SearchMoviePresenter(view: view, model: model)
        
        view.inject(presenter: presenter)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = view
        window?.makeKeyAndVisible()
        
        return true
    }

    // MARK: UISceneSession Lifecycle



}

