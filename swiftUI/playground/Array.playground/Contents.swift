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

//: map最简单实现方式(不完善) 这里为了和系统map函数区分，加了前缀

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

//: 如果需要检查是否包含
let b = fib.contains(1)
print(b) // true

let fb = fib.contains(where: { $0 > 5 })
print(fb) // true

//: 不要使用filter 除非你要使用filter的结果

fib.filter{ $0>5 }.count > 0 // true 这种会比上面的慢很多

//:> map 和 filter 都作用在一个数组上，并产生另一个新的、经过修改的数组 . reduce 可以把所有元素合并为一个新的值

// 数组的累加
let result = fib.reduce(0) { result,num in
                result + num
              }
print(result) // 27


let res2 = fib.reduce("") { (result, num) -> String in
  if result != "" {
    return "\(result),\(num)"
  }else{
    return "\(num)"
  }
}
print(res2) // 1,1,2,3,5,7,8

//: 但是分隔符有更简单的方式 joined 只针对[String]

let res3 = fib.map{"\($0)"}.joined(separator: ",")
print(res3) // 1,1,2,3,5,7,8


//: reduce的实现

extension Array {
  func zz_reduce<Result>(_ initialResult:Result,_ nextPartialResult:(Result,Element)->Result)->Result{
    var result = initialResult
    for x in self {
      result = nextPartialResult(result,x)
    }
    return result
  }
}


//: 使用reduce实现map和filter , 下面的方法随着元素增加 复杂度指数增长 效率低

extension Array {

  func re_map<T>(_ transform:(Element)->T)->[T]{
    return reduce([], { (result, element) -> [T] in
      result + [transform(element)]
    })
  }
  
  func re_filter(_ isInclude:(Element)->Bool) -> [Element]{
    return reduce([], { (result, element) -> [Element] in
      isInclude(element) ? result+[element]:result
    })
  }

}



let ranks = ["J","Q","K","A","2","3","4","5","6","7","8","8","10"]
let suits = ["♠︎","♣︎","♥︎","♦︎"]

let resultw = ranks.flatMap { rank in
  suits.map { suit in
    "\(suit)\(rank)"
  }
}
print(resultw)


//: forEach 的便捷用法例子
func doPrint(_ i:Int){
  print("print - \(i)")
}

fib.forEach(doPrint(_:))


//: forEach 和 for in 的一个区别 
fib.forEach { (value) in
  print(value)
  if value > 2 {
    return
  }
}

//:>这里会把所有元素打印出来  因为return仅仅return的是闭包 并不是循环，小心这里的陷阱。尽量使用 for in  可读性更高一些


//: 切片 

let slice = fib[1..<fib.endIndex]
print(slice) // [1, 2, 3, 5, 7, 8]
type(of: slice) // ArraySlice<Int> 这里返回的是一个数组切片类型

//:>ArraySlice 和 Array 具有的方法是一致的，因此你可以把它当数组来处理,也可以转换 `Array(slice)`














