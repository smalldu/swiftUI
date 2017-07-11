//: Playground - noun: a place where people can play

import UIKit

//: ## 集合类型

//:>集合类型 (Collection) 指的是那些稳定的序列，它们能够被多次遍历且保持一致。除了线性遍历以外，集合中的元素也可以通过下标索引的方式被获取到。下标索引通常是整数，至少在数组中是这样。

//:“Collection 协议是建立在 Sequence 协议上的。除了从 Sequence 继承了全部方法以外，得益于可以获取指定位置的元素以及稳定迭代的保证，集合还获取了一些新的能力。比如 count 属性，如果序列是不稳定的，那么对序列计数将会消耗序列中的元素，这显然不是我们的目的。但是对于稳定的集合类型，我们就可以对其进行计数。”

//:“Array，Dictionary 和 Set 以外，String 的四种表示方式都是集合类型。另外还有 CountableRange 和 UnsafeBufferPointer 也是如此。更进一步，我们可以看到标准库外的一些类型也遵守了 Collection 协议。有两个我们熟知的类型通过这种方法获得了很多新的能力，它们是 Data 和 IndexSet，它们都来自 Foundation 框架。”

//: 设计一个队列的集合 


// 为队列设计一个协议    它到底是什么

// 一个能将元素入队和出队的类型
protocol Queue {
  
  /// 在`self`中所持有的元素类型
  associatedtype Element
  
  // 入队新元素到 self 
  mutating func enqueue(_ newElement: Element)
  
  // 出队
  mutating func dequeue()-> Element?
}



// 一个高效的 FIFO 队列 其中元素类型`Element`

struct FIFOQueue<Element>: Queue {

  fileprivate var left:[Element] = []
  fileprivate var right:[Element] = []
  
  
  // 将元素添加到队列最后  复杂度O(1)
  mutating func enqueue(_ newElement: Element) {
    right.append(newElement)
  }
  
  mutating func dequeue() -> Element? {
    if left.isEmpty {
      left = right.reversed()
      right.removeAll()
    }
    return left.popLast()
  }

}

//: 遵循 Collection 协议 

//>“** 遵守 Collection 协议 ** 要使你的类型满足 Collection，你可以声明 startIndex 和 endIndex 属性，并提供一个下标方法，使其至少能够读取你的类型的元素。最后，你还需要提供 index(after:) 方法来在你的集合索引之间进行步进。”

/*:
我们需要实现的有：

```
protocol Collection: Indexable, Sequence {
  /// 一个表示集合中位置的类型
  associatedtype Index: Comparable
  
  /// 一个非空集合中首个元素的位置
  var startIndex: Index { get }
  /// 集合中超过末位的位置，也就是比最后一个有效下标值大 1 的位置
  var endIndex: Index { get }
  /// 返回在给定索引之后的那个索引值
  func index(after i: Index) -> Index
  /// 访问特定位置的元素
  subscript(position: Index) -> Element { get }
}
```
 
*/

//:让 FIFOQueue 满足 Collection

extension FIFOQueue: Collection {
  
  public var startIndex: Int { return 0 }
  public var endIndex: Int { return left.count + right.count  }
  
  public func index(after i: Int) -> Int {
    precondition(i<endIndex)
    return i+1
  }
  
  public subscript(position:Int) -> Element {
    precondition((0..<endIndex).contains(position),"Index out of bounds, 越界啦")
    
    if position < left.endIndex {
      return left[left.count - position - 1]
    }else{
      return right[position-left.count]
    }
  }
}


// 有了这几行代码，我们的队列已经拥有超过 40 个方法和属性供我们使用了。我们可以迭代队列：

var q = FIFOQueue<String>()
for x in ["1","2","wwe","4"] {
  q.enqueue(x)
}

for s in q {
  print(s,terminator: " ") // 1 2 wwe 4
}

var a = Array(q)
a.append(contentsOf: q[2...3]) // ["1", "2", "wwe", "4", "wwe", "4"]

q.map { $0.uppercased() }
q.flatMap{ Int($0) }
q.sorted()
q.joined(separator: ",")
q.isEmpty
q.count
q.first
q.dequeue()

//: 遵守 ExpressibleByArrayLiteral 协议

//:> “当实现一个类似队列这样的集合类型时，最好也去实现一下 ExpressibleByArrayLiteral。这可以让用户能够以他们所熟知的 [value1, value2, etc] 语法创建一个队列”

extension FIFOQueue: ExpressibleByArrayLiteral {
  
  public init(arrayLiteral elements: Element...) {
    self.init(left: elements.reversed(), right: [])
  }
  
}

let queue: FIFOQueue = [1,2,3]

//FIFOQueue<Int>
print(queue) // FIFOQueue<Int>(left: [8, 9, 0, 2, 3, 5, 4, 3, 2, 1], right: [])

// 这里 [1,2,3] 并不是一个数组只是一个“数组字面量”,一种写法 ， 可以用它来创建人和遵循 ExpressibleByArrayLiteral 协议的类型 。比如能够创建任意遵守 ExpressibleByIntegerLiteral 的整数型字面量。

//: “这些字面量有“默认”的类型，如果你不指明类型，那些 Swift 将假设你想要的就是默认的类型。正如你所料，数组字面量的默认类型是 Array，整数字面量的默认类型是 Int，浮点数字面量默认为 Double，而字符串字面量则对应 String”






















