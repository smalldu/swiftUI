//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var json = "{\"age\":1,\"name\":\"mr wang\",\"score\":98.8,\"isStu\":true}"




protocol Transable {
  
}

extension Transable where Self: NSObject {
  
  func transfor(json: String){
    let dic:[String: Any] = ["age":1,"name":"mr wang","score":98.8,"isStu":true]
    let mirror:Mirror = Mirror(reflecting: self)
    print(mirror.subjectType)
    print(mirror.displayStyle)
    print(mirror.superclassMirror)
    print(mirror.children)
    for item in mirror.children{
      print("\(item.label ?? ""),\(item.value)")
      print(type(of: item.value))
      
      if "\(type(of: item.value))" == "B" {
        let mb = Mirror(reflecting: item.value)
        for item in mb.children {
          print("\(item.label ?? ""),\(item.value)")
        }
      }
     
    }
    
    
    
  }
  
}

class A: NSObject , Transable {
  var age: Int? = 0
  var name: String? = ""
  var score: Double = 0.0
  var we: Double = 0
  var isStu: Bool = false
  var b:B = B()
 
}

class B {
  var k: String?
}




var a = A()
a.transfor(json: "--")



































