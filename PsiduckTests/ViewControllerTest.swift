//
//  ViewControllerTest.swift
//  Psiduck
//
//  Created by Vina Melody on 8/9/16.
//  Copyright © 2016 Vina Rianti. All rights reserved.
//


import Quick
import Nimble
import Psiduck
import SwiftyJSON

class ViewControllerTest: QuickSpec {

    override func spec() {
        
        var viewController: ViewController!
        
        
        beforeEach {
            let storyboard = UIStoryboard(name:"Main", bundle: NSBundle.mainBundle())
            viewController = storyboard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        }
        
        describe(".mainActions") {
            
            context("PSI Data is fetched successfully") {
                
                it("can decode and parse the data") {
                    
                    var json: JSON?
                    viewController.getPsiReadingFromNea{json = $0}
                    
                    expect(json).toEventuallyNot(beNil())
                    
                }
                
                it("can add annotation to the map") {
                    
                    viewController.mainAction()
                    
                    // Must have 5 Singapore region annotations
                    expect(viewController.annotations.count).toEventually(equal(5))
                    
                }
                
            }
            context("There is an error fetching PSI Data") {
                
                it("shows an alert with error") {
                    
                    // not sure how to fake error
                    // expect(viewController.presentedViewController).toEventually(beAnInstanceOf(UIAlertController))
                    
                }
            }
            
        }
    }
}
