//
//  DocumentBrowserViewController.swift
//  SheepList_documentBased
//
//  Created by Andreas Våge on 04.12.2017.
//  Copyright © 2017 Andreas Våge. All rights reserved.
//

import UIKit


class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate, UIViewControllerTransitioningDelegate {
    
    var transitioningController: UIDocumentBrowserTransitionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        allowsDocumentCreation = false
        allowsPickingMultipleItems = false
        
        template = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
            ).appendingPathComponent("Untitled.sheepList")
        if template != nil {
            allowsDocumentCreation = FileManager.default.createFile(atPath: template!.path, contents: Data())
        }
        // Update the style of the UIDocumentBrowserViewController
        // browserUserInterfaceStyle = .dark
        // view.tintColor = .white
        
        // Specify the allowed content types of your application via the Info.plist.
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var template: URL?
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        importHandler(template, .copy)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
        print("MY ERROR MESSAGE: \(Error.self)")
    }
    
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
        print("Presenting Document")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let documentVC = storyBoard.instantiateViewController(withIdentifier: "DocumentMVC") as? UITabBarController else {return}
        guard let splitViewController = documentVC.viewControllers?.first as? UISplitViewController else {return}
        guard let sheepListController = splitViewController.viewControllers.first?.childViewControllers.first as? SheepListController else {return}
        
        
        sheepListController.modelC = ModelController()
        sheepListController.modelC.document = SheepDocument(fileURL: documentURL)
        
        guard let splitViewController2 = documentVC.viewControllers![1] as? UISplitViewController else {return}
        guard let workingSetController = splitViewController2.viewControllers.first?.childViewControllers.first as? WorkingSetController else {return}
        
        workingSetController.modelC = sheepListController.modelC
        
        
        
        present(documentVC, animated: true)
    }
}

