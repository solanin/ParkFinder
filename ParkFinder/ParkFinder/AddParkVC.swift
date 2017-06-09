//
//  AddBookmarkVC.swift
//  Bookmarker
//
//  Created by Jacob Westerback (RIT Student) on 4/5/17.
//  Copyright © 2017 tony. All rights reserved.
//

import UIKit

class AddParkVC: UIViewController {
    
    var park:StatePark?
    @IBOutlet weak var titleField:UITextField!
    @IBOutlet weak var urlField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Park"
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //let name = (titleField.text?.characters.count)! > 0 ? titleField.text! : "No title entered"
        //let url = (urlField.text?.characters.count)! > 0 ? urlField.text! : "No url entered"
        
        //park = StatePark(name: name, latitude: <#T##Float#>, longitude: <#T##Float#>, url: url, address: String, desc: <#T##String#>, fav: <#T##Bool#>)
    }
    
}
