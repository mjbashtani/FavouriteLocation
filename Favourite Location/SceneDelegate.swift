//
//  SceneDelegate.swift
//  Favourite Location
//
//  Created by Mohammad Javad Bashtani on 6/20/1401 AP.
//

import UIKit
import CoreLocation


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let locationFetcher = LocationFetcher()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        let markerController = MarkerController()
        let viewController = GMMapViewController(markerController: markerController)
        markerController.mapView = viewController
        locationFetcher.start()
        locationFetcher.userLocationUpdated = { [weak viewController] location in
            viewController?.currentUserLocation = location
            markerController.currentLocation = location

        }
        let child =  PersonListViewController(collectionFlowViewLayout: UICollectionViewFlowLayout())
        viewController.add(child: child, container: viewController.view)
        child.view.anchor(top: nil, leading: viewController.view.leadingAnchor, bottom: viewController.view.safeAreaLayoutGuide.bottomAnchor, trailing: viewController.view.trailingAnchor)
        child.view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let id = UUID().uuidString
        let secondID = UUID().uuidString
        let thirdID = UUID().uuidString
        let persons = [Person(id: id, firstName: "mamadffdfdfdfdfdfdfd", lastName: "ali", location: .init(latitude: 35.7219, longitude: 51.3347)), Person(id: secondID, firstName: "mamad", lastName: "ali", location: .init(latitude: 35.7519, longitude: 51.3347)), Person(id: thirdID, firstName: "asghar", lastName: "mo", location: .init(latitude: 35.7519, longitude: 50.3347))]
        
        let cellControllers = persons.map { person -> CellController in
            let pc = PersonCellController(viewModel: .init(name: person.firstName, lastName:person.lastName))
            pc.selection = {
                markerController.addMarker(with: .init(latitude: person.location.latitude , longitude: person.location.longitude), id: person.id, title: person.firstName)
            }
            
            pc.deselection = {
                markerController.deleteMarker(with: person.id)
            }
            return CellController(id: person.id, pc)
        }
        child.display(cellControllers)
        window?.rootViewController = SelectLocationViewController(currentUserLocation: .init(latitude: 35.7519, longitude: 51.3347))
        window?.makeKeyAndVisible()
        
    
    }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

