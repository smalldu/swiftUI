//: Playground - noun: 字典的操作

import UIKit

var str = "Hello, Dictionary"


//:> 和数组不同，字典是无序的，使用for循环来枚举字典的键值对，顺序是不确定的。

//: 下面实现一个类似git merge的方法 合并两个字典 ，取第二个字典的最新值

extension Dictionary {
  // 这里传入的参数必须是实现Sequence协议 ， Iterator.Element必须是（Key,Value） 。 也可以直接指定为字典类型
  mutating func merge<S>(_ other: S)
    where S:Sequence,S.Iterator.Element == (key:Key,value:Value) {
    for (k,v) in other{
      self[k] = v
    }
  }
}


var defaultDic = [1:"a",2:"b",3:"c"]
var dic1 = [4:"d",2:"c"]

defaultDic.merge(dic1)
print(defaultDic)  // [2: "c", 3: "c", 1: "a", 4: "d"]


let arr = (1..<5).map{ $0 }
print(arr) // [1, 2, 3, 4]


//: 已上面这种字面量的方式 初始化字典

extension Dictionary {
  // 刚好用到上面的merge方法
  init<S:Sequence>(_ sequence:S)
    where S.Iterator.Element == (key:Key,value:Value) {
    self = [:]
    self.merge(sequence)
  }

}

let defaultAlarm =  (1..<5).map{ (key:"Alarm\($0)",value:false) }
let alarmsDic = Dictionary(defaultAlarm)
print(alarmsDic) // ["Alarm3": false, "Alarm2": false, "Alarm1": false, "Alarm4": false]

//: Dictionary 已经有一个map方法但是转换的结果是数组 我们可以写个转换的结果为字典的


let mDics = defaultDic.map{ "\($0) - \($1)" }
print(mDics) // ["2 - c", "3 - c", "1 - a", "4 - d"]


extension Dictionary {
  
  func mapValues<NewValue>(_ transform:(Value)->NewValue)->[Key:NewValue]{
    return Dictionary<Key,NewValue>(
      map{ (key,value) in
        return (key,transform(value))
      }
    )
  }

}

let newMDic = defaultDic.mapValues{ $0.uppercased() }
print(newMDic) // [2: "C", 3: "C", 1: "A", 4: "D"]

/*: 
 *Note*
 ***
  字典其实是哈希表 ， 字典通过键的 `hashValue` 为每个键指定一个位置，以及他所对应的存储。 `Dictionary` 要求它的`Key`需要遵循`Hashable`协议。标准库中所有基本数据类型都是遵守`Hashable`协议的。如果那你需要自定义的类型用于字典的键，那么你必须手动为你的类型添加`Hashable`协议。需要实现 `hashValue` 属性。此外 ， 由于`Hashable`本身是对`Equatable`的扩展，所有你还需要为你的类型重载 `==` 运算符。 而且要保证哈希不变原则： 两个童谣的实例必须拥有相同的哈希值。 不过反过来不必为真。不同的哈希值的数量是有限的，然而很多可以被哈希的类型 (比如字符串) 的个数是无穷的。
 
   哈希值可能重复这一特性，意味着 Dictionary 必须能够处理哈希碰撞。不必说，优秀的哈希算法总是能给出较少的碰撞，这将保持集合的性能特性。理想状态下，我们希望得到的哈希值在整个整数范围内平均分布。在极端的例子下，如果你的实现对所有实例返回相同的哈希值 (比如 0)，那么这个字典的查找性能将下降到 O(n)。
 
   优秀哈希算法的第二个特质是它应该很快。记住，在字典中进行插入，移除，或者查找时，这些哈希值都要被计算。如果你的 hashValue 实现要消耗太多时间，那么它很可能会拖慢你的程序，让你从字典的 O(1) 特性中得到的好处损失殆尽。
 
   写一个能同时做到这些要求的哈希算法并不容易。对于一些由本身就是 Hashable 的数据类型组成的类型来说，将成员的哈希值进行“异或” (XOR) 运算往往是一个不错的起点
 ***
*/

struct Person {
  
  var name: String
  var zipCode: Int
  var birthDay: Date
}

extension Person: Equatable{
  static func == (lhs:Person,rhs:Person)-> Bool{
    return lhs.name == rhs.name
    && lhs.zipCode == rhs.zipCode
    && lhs.birthDay == rhs.birthDay
  }
}


extension Person: Hashable {
  var hashValue: Int {
    return name.hashValue ^ zipCode.hashValue ^ birthDay.hashValue
  }
}



//:>当你使用不具有值语义的类型 (比如可变的对象) 作为字典的键时，需要特别小心。如果你在将一个对象用作字典键后，改变了它的内容，它的哈希值和/或相等特性往往也会发生改变。这时候你将无法再在字典中找到它。这时字典会在错误的位置存储对象，这将导致字典内部存储的错误。对于值类型来说，因为字典中的键不会和复制的值共用存储，因此它也不会被从外部改变，所以不存在这个的问题。






