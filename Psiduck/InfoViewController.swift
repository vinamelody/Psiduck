//
//  InfoViewController.swift
//  Psiduck
//
//  Created by Vina Melody on 8/9/16.
//  Copyright © 2016 Vina Rianti. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let url: NSURL! = NSURL(string: "https://dl.dropboxusercontent.com/u/28350025/psi.html")
        let requestObj = NSURLRequest(URL: url)
        webView.loadRequest(requestObj)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
