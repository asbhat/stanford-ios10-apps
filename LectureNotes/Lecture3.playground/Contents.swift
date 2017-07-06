//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


/*
       -----------
      | Optionals |
       -----------
*/

// an Optional is just an enum
enum ExampleOptional<T> {  // the <T> is a generic type (e.g. Array<T>)
    case none
    case some(T)
}

let s1: String? = nil
// is the same as ...
let s2 = ExampleOptional<String>.none

let s3: String? = "hello"
// is the same as ...
let s4 = ExampleOptional.some("hello")

let s5 = s3!
// is the same as ...
switch s4 {
case .some(let value): let s6 = value
case .none: fatalError()  // raise an exception
}

if let s7 = s3 {
    s7
}
// is the same as ...
switch s4 {
case .some(let value):
    value
case .none:
    break
}


// Chaining Optionals
var display: UILabel?
if let temp1 = display {
    if let temp2 = temp1.text {
        let x = temp2.hashValue
    }
}
// ... becomes ...
if let x = display?.text?.hashValue {}  // x is an Int
let x = display?.text?.hashValue  // x is an Int?


// Optional Defaulting
let s: String? = "blah"
if s != nil {
    display?.text = s
} else {
    display?.text = " "
}
// ... becomes ...
display?.text = s ?? " "


/*
       --------
      | Tuples |
       --------
*/

// a grouping of values
let t1: (String, Int, Double) = ("hello", 5, 0.85)
let (word, number, value) = t1
word
number
value

let t2: (w: String, i:Int, v:Double) = ("hello", 5, 0.85)
t2.w
t2.i
t2.v

// as return types
func getSize() -> (weight: Double, height: Double) { return (250, 80) }

let size = getSize()
"weight is \(size.weight)"
"height is \(size.height)"


/*
       --------
      | Ranges |
       --------
*/

// two end points; can represent a selection in a String or a portion of an Array
struct ExampleRange<T> {
    // kind of like this, but actually more complicated
    // T's are restricted to 'comparable' types (to make sure startIndex < endIndex)
    var startIndex: T
    var endIndex: T
}

// a CountableRange also has consecutive values in between endpoints; can be iterated over or indexed into

1..<5  // 1 -> 4 inclusive (excludes 5)
1...5  // 1 -> 5 inclusive

let a1 = ["a", "b", "c", "d"]
let slice1 = a1[2...3]
let slice2 = a1[2..<3]
// will crash if:
//  - indeces are out of bounds
//  - lowerBound > upperBound

// a String subrange is NOT Range<Int>, it's Range<String.Index>

for i in stride(from: 0.5, through: 15.25, by: 0.3) {
}
// this is equivalent to `for (i=0.5, i<=15.25, i+=0.3)`


/*
       -----------------
      | Data Structures |
       -----------------
*/

// Classes, Structures, Enumerations, and Protocols

// Classes, Structures, Enumerations
//  - Declaration
//      - classes can declare a Superclass
//  - Properties and Functions
//      - no stored properties in an enum (but can have computed properties)
//  - Initializers
//      - no initializers for an enum
//  - Inheritance
//      - class only
//  - Type
//      - Struct / Enum are value types
//      - Class is a reference type


/*
       ---------
      | Methods |
       ---------
*/

func foo(externalFirst first: Int, externalSecond second: Double) -> Double {
    var sum = 0.0
    for _ in 0..<first { sum += second }
    return sum
}
func bar() -> Double {
    return foo(externalFirst: 123, externalSecond: 5.5)
}

// use `override` to change a func or var from a superclass
// any propery or method or even whole class marked with `final` cannot be overridden

// Type methods and properties are denoted with `static`
Double.pi  // Type property
Double.maximum(324.0, 514.2)  // Type method


/*
       ------------
      | Properties |
       ------------
*/

// Observers
var someStoredProperty = 42 {
    willSet { newValue }
    didSet { oldValue }
}

class ExampleBaseClass {
    var inheritedProperty: String = ""
}
class ExampleClass: ExampleBaseClass {
    override var inheritedProperty: String {
        willSet { newValue }
        didSet { oldValue }
    }
}
// for a mutable value type (e.g., dictionary) willSet & didSet will be called every time the data is changed

// Lazy initialization
//  no initialization until it is accessed
//  - necessary to call a method as part of initializaiton
//  - normally all vars need to be initialized when an object is created


/*
       --------
      | Arrays |
       --------
*/

var a2 = Array<String>()
// ... is the same as ...
var a3 = [String]()

let animals = ["Giraffe", "Cow", "Doggie", "Bird"]
for animal in animals {
    // can enumerate since Arrays are a 'sequence'
    animal
}

let bigNumbers = [2, 47, 188, 5, 9].filter({ $0 > 20 })
bigNumbers

let stringified = [1,2,3].map { String($0) }  // trailing closure syntax
stringified

let sum1 = [1,2,3].reduce(0) {$0 + $1}
let sum2 = [1,2,3].reduce(0, +)
sum1 == sum2


/*
       --------------
      | Dictionaries |
       --------------
*/

var pac12teamRankings = Dictionary<String,Int>()
// ... is the same as ...
var pac12TeamRankings = [String:Int]()

pac12TeamRankings = ["Stanford": 1, "USC": 11]
let ohioRanking = pac12TeamRankings["Ohio State"]
pac12TeamRankings["Cal"] = 12
for (key, value) in pac12TeamRankings {
    "Team \(key) is ranked number \(value)"
}


/*
       ---------
      | Strings |
       ---------
*/

// made up of Unicodes internally, which is why it's such a complicated object

let s01 = "hello"
let firstIndex = s01.startIndex  // can't index with Int, so need a String.Index
let firstChar = s01[firstIndex]
let secondIndex = s01.index(after: firstIndex)
let secondChar = s01[secondIndex]
let fifthChar = s01[s01.index(firstIndex, offsetBy: 4)]
let substring = s01[firstIndex...secondIndex]

// can use .characters var to access the Strings "characters"
for c in s01.characters {}

let count = s01.characters.count
let firstSpace = s01.characters.index(of: " ")

let hello = "hello"  // immutable (since String is a struct)
var greeting = hello  // mutable!
greeting += " there"

if let firstGreetingSpace = greeting.characters.index(of: " ") {
    greeting.insert(contentsOf: " you".characters, at: firstGreetingSpace)
}

greeting.endIndex  // this is NEVER a valid index into the String

greeting.hasPrefix("hello ")
greeting.hasSuffix(" there")
greeting.hasSuffix(" hello you there")

s01.localizedLowercase
s01.localizedUppercase
s01.localizedCapitalized

var s02 = s01
s02.replaceSubrange(s02.startIndex..<s02.endIndex, with: "new contents")
let sArray = "1,2,3".components(separatedBy: ",")


/*
       ---------------
      | Other Classes |
       ---------------
*/

// NSObject
//  - base class for all Obj-C classes
//  - some advanced features will require subclassing it

// NSNumber
//  - generic number holding class (reference type)
let n1 = NSNumber(value: 35.5)
let n2: NSNumber = 35.5
n1 == n2

n1.intValue
n1.doubleValue
n1.boolValue

// Date
//  - see also: Calendar(), DateFormatter(), DateComponents()
//  - needed for date localization


// Data
//  - a "bag o' bits" (value type)
//  - used to save / restore / transmit raw data
//  - e.g., an image


/*
       ----------------
      | Initialization |
       ----------------
*/

// Are uncommon because you can use the following:
//  - set defaults using =
//  - use Optionals, which start out nil
//  - initialize a specific property with a closure
//  - use lazy

// Only if NONE of the above work, do you need an init
// Can overload it (e.g., String has many inits for each datatype: Double, String, Int, etc...)

// Free inits
//  - all base classes (no superclass) get an init with no arguments
//  - a struct without an init will get a free init with all its properties as arguments

// init()
//  - can set a properties value, even if they are already set (including let properties)
//  - can call other init methods (using self.init(<args>))
//  - in a class, can call super.init(<args>)

// Class init requirements
//  - all properties must have values (Optionals can be nil)
//  - designated init (non-convenience)
//      - can only call a designated init in its immediate superclass
//      - must initialize all new properties before calling super.init()
//      - must call super.init() before changing any inherited values
//  - convenience init
//      - can only call an init in its own class
//      - must call that init before setting any property values
//      - all inits must be complete before getting properties and calling methods

// Inheriting inits
//  - only if you DO NOT implement any designated inits, then you'll inherit all of your superclass's designated inits
//  - if you override all of your superclass's designated inits, then you'll inherit all of its convenience inits

// Required init
//  - you can mark an init as 'required' (all subclasses will need to implement it, but can inherit it)

// Failable init
//  - `init?(arg1: Type1, ...) {}`
//  - will return an Optional (e.g., Double("hello"))


/*
       ------------------
      | Any / Any Object |
       ------------------
*/

// Any can be anything (value or reference)
// AnyObject can be any reference type
// Generally used for Obj-c compatability

// In Swift want to keep things strongly typed
//  - Won't be able to use a method until Any or AnyObject is converted to a type
//  - use an enum for mixed types

// Casting

let unknown: Any = "hello"
if let foo = unknown as? String {
    foo.characters.count
}

//  - can cast any type
//      - generally used to 'downcast' a superclass to a subclass


/*
       --------------
      | UserDefaults |
       ---------------
*/

// a very tiny database that persists between app launches
//  - good for 'settings'
//  - do NOT use for anything big

// Property List
//  - can only store property list data:
//      - Array
//      - Dictionary
//      - String
//      - Date
//      - Data
//      - or a number (e.g., Int, etc...)

let defaults = UserDefaults.standard
defaults.set(1.0, forKey: "TestDouble")  // value has to be a Property List or it will crash
defaults.double(forKey: "TestDouble")


/*
       ------------
      | Assertions |
       ------------
*/

// a debuggin aid
assert(true, "this is not true")