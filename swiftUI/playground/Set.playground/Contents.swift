//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, Set"

//:>标准库中第三种主要的集合类型是集合 Set,集合是一组无序的元素，每个元素只会出现一次，可以想象为之存储了Key而没有Value的字典。也是通过哈希表实现的。当需要保证序列中不出现重复的元素又不关心顺序的时候，集合是更好的选择


//: 可以用数组字面量的方式进行集合的初始化 因为他实现了 `ExpressibleByArrayLiteral` 协议 

let naturals: Set = [1,2,3,2]
print(naturals) // [2, 3, 1]  自动去重

naturals.contains(2) // true
naturals.contains(0)  // false


//:>和其他集合类型一样，集合也支持我们已经见过的那些基本操作：你可以用 for 循环进行迭代，对它进行 map 或 filter 操作，或者做其他各种事情


//: 我们可以进行一些结合运算

var set1:Set = [1,2,3,4,5]
let set2:Set = [4,5]

//: 补集
set1.subtract(set2)
print(set1) // [2, 3, 1]

set1 = [1,2,3,4,5]
//: 交集
let newSet = set1.intersection([3,2,6])
print(newSet) // [2, 3]

set1 = [1,2,3,4,5]
//: 并集
set1.formUnion([0,9,3,4,2])
print(set1) // [2, 4, 9, 5, 0, 3, 1]


var indices = IndexSet()
indices.insert(integersIn: 1..<5)
indices.insert(integersIn: 11..<15)

let eventIndies = indices.filter{ $0 % 2 == 0 }
print(eventIndies) // [2, 4, 12, 14]


//: 为Sequence实现一个去重复的扩展
extension Sequence where Iterator.Element: Hashable {
  func unique() -> [Iterator.Element] {
    var seen: Set<Iterator.Element> = []
    return self.filter{
      if seen.contains($0) {
        return false
      }else{
        seen.insert($0)
        return true
      }
    }
  }
}


let uniqueArr = [1,2,3,1,2,3,4,4,5,6,7,8,9,0,5,4].unique()
print(uniqueArr) // [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]









