# PsiLite

PsiLite shows you the latest Pollutant Standards Index (PSI) for the five regions in Singapore, taken from (NEA's Data)[https://data.gov.sg/dataset/psi] website.

PsiLite is made using Apple Swift version 2.2 on XCode Version 7.3.1 (7D1014).


## User Interface Elements

The main view shows you a Singapore island with 5 pins. Each pin represents a region in Singapore: central, east, west, north and south.

- Tap on any pin to show the latest PSI reading pusblished from NEA
- Tap Refresh button to refresh the information. Take note that generally, NEA updates the data hourly.
- Tap Info link to see General Information about PSI

![UI](http://i.imgur.com/DYHpbWL.png) ![Info](http://i.imgur.com/o6uA0P8.png)

### Error Handling

PsiLite requires active Internet connection. In the case where Internet is not available, it will show an error message. Once Internet connection is available, user should tap on Refresh button to try to retrieve the data again.

![Error Screen](http://i.imgur.com/LWiSV9R.png)

## Unit Tests

A basic unit test is done for the `ViewController.swift`, you can check out the source code. A snippet of it looks like:

```swift
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
```
