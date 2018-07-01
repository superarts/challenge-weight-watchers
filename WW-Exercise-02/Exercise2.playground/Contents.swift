//: Playground - noun: a place where people can play

import UIKit

/// INSTRUCTIONS
/// - Fix compilation errors.
/// - Assign the teacher the name "Alice" and an age of 31.
/// - Implement 'addStudents()' to add Cecilia, Ellen, and Bob to Alice's list of students.
/// - In 'printStudents()' print the student's age if it's available. Otherwise, just print the name.

protocol Person {
	var firstName: String { get }
	var age: Int? { get }
}

protocol Teaching {
    func printStudents()
    mutating func addStudents(_ students: [Student])
}

struct Teacher: Person, Teaching {
	var firstName: String
	var age: Int?
    private var students = [Student]()
    
	init(firstName: String, age: Int? = nil) {
		self.firstName = firstName
		self.age = age
	}
    
    func printStudents() {
        for student in students {
			//	print(student.firstName == "Robert" ? "Bob" : student.firstName)
			print("\(student.firstName)" + (student.age == nil ? "" : " (\(student.age!))"))
        }
        print("\(firstName) has \(students.count) students.")
    }
	
	mutating func addStudents(_ students: [Student]) {
		self.students.append(contentsOf: students)
	}
}

struct Student: Person {
    let firstName: String
    let age: Int?
}

var teacher = Teacher(firstName: "Alice", age: 31)

/// DO NOT MODIFY FROM HERE
let students = [
    Student(firstName: "Cecilia", age: 25),
    Student(firstName: "Ellen", age: nil),
    Student(firstName: "Robert", age: 30)
]

teacher.addStudents(students)
teacher.printStudents()

