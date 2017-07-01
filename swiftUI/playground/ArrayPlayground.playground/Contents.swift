//: Playground - noun: a place where people can play

import UIKit

//: ## 数组操作总结

let fib = [1,1,2,3,5,7,8]

//:迭代数组

for item in fib {
  print(item)
}

//:迭代除了第一个元素以外的数组其余部分

for item in fib.dropFirst() {
  print(item)
}

//:迭代除了最后五个以外的数组其余部分

for item in fib.dropLast(5) {
  print(item)
}

//:想要列举数组中的元素和对应的下标

for (index,element) in fib.enumerated() {
  print("\(index),\(element)")
}

//:想要寻找指定元素的位置

if let idx = fib.index(where:{ $0 == 1 }) {
  print(idx) // 0 返回第一个匹配到的下标
}

//:想要对数组中所有元素进行变形

let transFib = fib.map{ "￥\($0)" }
print(transFib) // ["￥1", "￥1", "￥2", "￥3", "￥5", "￥7", "￥8"]

//:想要筛选出符合某个标准的元素

let filterFib = fib.filter{ $0 > 5 }
print(filterFib) // [7, 8]

//: map最简单实现方式(不完善)


extension Array {

  func zz_map<T>(_ transform:(Element)->T) -> [T] {
    var result: [T] = []
    result.reserveCapacity(count)
    for x in self{
      result.append(transform(x))
    }
    return result
  }

}

let newMapFib = fib.zz_map{ $0*$0 }
print(newMapFib) // [1, 1, 4, 9, 25, 49, 64]

//:> Swift中，它实际上是`Sequence`的一个扩展，实际上这个函数的签名应该是`func map<T>(_ transform: (Element) throws -> T) rethrows -> [T]` 这里为了简单处理，没有加错误处理





