//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, Range and Sequence"

//: #### Range
let sigleDigitalNum = 1..<10
type(of: sigleDigitalNum) // CountableRange<Int> 可数范围 只有这类可以被迭代

let lowercaseLetters = "a"..."z"
type(of: lowercaseLetters) // ClosedRange<String>

type(of: 1...3) // CountableClosedRange<Int>

//: Right

for x in sigleDigitalNum {
  print(x)
}

//: Wrong “ClosedRange<Character>' 类型不遵守 'Sequence' 协议”

//for x in lowercaseLetters {
//  print(x)
//}



//: #### Sequence

//:>Array，Dictionary 和 Set，它们并非空中楼阁，而是建立在一系列由 Swift 标准库提供的用来处理元素序列的抽象之上的.Sequence 和 Collection 协议 , 他们是构成这套集合类型的基石。




//: `Sequence` 协议是集合类型结构中的接触。一个序列(Sequence)代表的是一系列具有相同类型的值，你可以使用 for 循环对这些值进行迭代。满足 `Sequence`协议的要求很简单 ， 你需要做的所有事情就是提供一个迭代器(iterator) 的 makeIterator() 方法

/*:
  ```
 protocol Sequence {
   associatedtype Iterator: IteratorProtocol
   func makeIterator() -> Iterator
 }
  ```
 */


//: ##### 迭代器

//:>序列通过创建一个迭代器来提供对元素的访问。迭代器每次产生一个序列的值，并且当遍历序列时对遍历状态进行管理。在 IteratorProtocol 协议中唯一的一个方法是 next()，这个方法需要在每次被调用时返回序列中的下一个值。当序列被耗尽时，next() 应该返回 nil

//: 一个不断返回相同值得迭代器
struct ConstantIterator: IteratorProtocol {
  typealias Element = Int
  mutating func next() -> Int? {
    return 1
  }
}


var iterator = ConstantIterator()
let x = iterator.next()
print(x ?? 0)

//: 更有意义的例子 FibsIterator












