
//  ViewController.swift
//  ToDoList
//
//  Created by Кирилл Котыло on 26.02.26.
//

import UIKit

class ListViewController: UIViewController {
    
    private let listView = ListView()
    
    override func loadView() {
        super.loadView()
        view = listView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }


}
