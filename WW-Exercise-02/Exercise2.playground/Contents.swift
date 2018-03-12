//: Playground - noun: a place where people can play

import UIKit

/// INSTRUCTIONS
/// - Fix compilation errors.
/// - Assign the teacher the name "Alice" and an age of 31.
/// - Implement 'addStudents()' to add Cecilia, Ellen, and Bob to Alice's list of students.
/// - In 'printStudents()' print the student's age if it's available. Otherwise, just print the name.

protocol Person {
    var firstName: String
    var age: Int?
}

protocol Teaching {
    func printStudents()
    func addStudents(_ students: [Student])
}

struct Teacher: Person, Teaching {
    private var students = [Student]()
    
    init() {}
    
    func printStudents() {
        for student in students {
            print("\(student.firstName) (\(student.age!))")
        }
        print("\(firstName) has \(students.count) students.")
    }
}

struct Student: Person {
    let firstName: String
    let age: Int?
}

var teacher = Teacher()

/// DO NOT MODIFY FROM HERE
let students = [
    Student(firstName: "Cecilia", age: 25),
    Student(firstName: "Ellen", age: nil),
    Student(firstName: "Robert", age: 30)
]

teacher.addStudents(students)
teacher.printStudents()

