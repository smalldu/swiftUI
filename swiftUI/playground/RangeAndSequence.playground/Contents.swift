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

struct FibsIterator: IteratorProtocol {
  var state = (0,1)
  mutating func next() -> Int? {
    let upComingNum = 0
    state = ( state.0 , state.0 + state.1 )
    return upComingNum
  }
}


//: 有限序列的迭代器

struct PrefixIterator: IteratorProtocol {
  let string: String
  var offset: String.Index
  init(string: String) {
    self.string = string
    offset = string.startIndex
  }
  mutating func next() -> String? {
    guard offset < string.endIndex else { return nil }
    offset = string.index(after: offset)
    return string[string.startIndex..<offset]
  }
}

var prefix = PrefixIterator(string: "tsdwefr")

while let next = prefix.next() {
  print(next)
}
//t
//ts
//tsd
//tsdw
//tsdwe
//tsdwef
//tsdwefr


//: 有了Iterator 定义一个Sequence就很简单了 

struct PrefixSequence: Sequence {
  let string:String
  func makeIterator() -> PrefixIterator {
    return PrefixIterator(string: string)
  }
}

for item in PrefixSequence(string: "hello") {
  print(item)
}

//h
//he
//hel
//hell
//hello


//: 具有值语义的迭代器

let seq = stride(from: 0, to: 10, by: 1)

var i1 = seq.makeIterator()
i1.next() // 0
i1.next() // 1

var i2 = i1

i1.next() // 2
i2.next() // 2


//: 不具有值语义的迭代器 

var i3 = AnyIterator(i1)
var i4 = i3

i3.next() // 3
i4.next() // 4
i3.next() // 5
i3.next() // 6


//: 基于函数的迭代器和序列 

//:>AnyIterator 还有另一个初始化方法，那就是直接接受一个 next 函数作为参数。与对应的 AnySequence 类型结合起来使用，我们可以做到不定义任何新的类型，就能创建迭代器和序列


func fibsIterator() -> AnyIterator<Int>{
  var state = (0,1)
  return AnyIterator{
    let upComingNum = state.0
    state = (state.1,state.0+state.1)
    return upComingNum
  }
}

let fibsSequence = AnySequence(fibsIterator)
Array( fibsSequence.prefix(10) ) // [0, 1, 1, 2, 3, 5, 8, 13, 21, 34] 

//: sequence 函数

//>sequence(first:next:) 将使用第一个参数的值作为序列的首个元素，并使用 next 参数传入的闭包生成序列的后续元素。


let randomNums = sequence(first: 100) { (pre:UInt32) in
  let newValue = arc4random_uniform(pre)
  guard newValue > 0 else {
    return nil
  }
  return newValue
}

Array(randomNums) // [100, 43, 22, 4, 2, 1]

//:>sequence(state:next:)，因为它可以在两次 next 闭包被调用之间保存任意的可变状态，所以它更强大一些。我们可以用它来通过以及一个单一的方法调用来构建出斐波纳契序列

let fibsSequence2 = sequence(state: (0,1)) { (state:inout(Int,Int)) -> Int? in
  let upComingNum = state.0
  state = (state.1,state.0+state.1)
  return upComingNum
}


Array(fibsSequence2.prefix(10)) // [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]

//:>sequence(first:next:) 和 sequence(state:next:) 的返回值类型是 UnfoldSequence。这个术语来自函数式编程，在函数式编程中，这种操作被称为展开 (unfold)。sequence 是和 reduce 对应的 (在函数式编程中 reduce 又常被叫做 fold)。reduce 将一个序列缩减 (或者说折叠) 为一个单一的返回值，而 sequence 则将一个单一的值展开形成一个序列。


//: 不稳定序列

/*:Sequence 协议并不关心遵守该协议的类型是否会在迭代后将序列的元素销毁。也就是说，请不要假设对一个序列进行多次的 for-in 循环将继续之前的循环迭代或者是从头再次开始：
 
 ```
  for element in sequence {
    if ... some condition { break }
  }
  for element in sequence {
    // 未定义行为
  }
 ```
 
  一个非集合的序列可能会在第二次 for-in 循环时产生随机的序列元素。
*/


























