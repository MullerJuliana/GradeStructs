//
//  main.swift
//  gradeStruct
//
//  Created by StudentPM on 2/11/25.
//
import CSV

// Define the Student struct to store all student-related information
struct Student {
    var name: String
    var finalScore: Double
    var scores: [String]
}

// Create an empty array of Student objects
var students: [Student] = []

do {
    // Specify the path to the CSV file
    let filePath = "/Users/studentpm/Desktop/GradeManagement/inventory/inventory/schoolList.csv"
    // Read the contents of the file
    let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
    
    // Split the file contents into rows
    let rows = fileContents.components(separatedBy: "\n")
    
    // Process each row of data
    for row in rows {
        let columns = row.components(separatedBy: ",")
        handleData(data: columns) // Call the function to handle the data
    }
} catch {
    print("There was an error reading the file")
}

// Function to handle data from the CSV and create Student objects
func handleData(data: [String]) {
    var tempScores: [String] = [] // Temporary array to store scores
    var tempFinalScore: Double = 0.0 // Variable to calculate final score
    var sum: Double = 0.0 // Variable to accumulate the sum of scores
    
    // Iterate through the columns of the data
    for i in data.indices {
        if i == 0 {
            continue // Skip the first index (student name)
        } else {
            tempScores.append(data[i]) // Add scores to the temporary array
            if let score = Double(data[i]) {
                sum += score // Add to the sum if the score is valid
            }
        }
    }
    
    // Calculate final score if there are valid scores
    if !tempScores.isEmpty {
        tempFinalScore = sum / Double(tempScores.count)
    }
    
    // Create a new Student object and add it to the students array
    let tempStudent = Student(name: data[0], finalScore: tempFinalScore, scores: tempScores)
    students.append(tempStudent)
}

// Main loop to keep the program running
var isRunning = true
while isRunning {
    mainMenu() // Display the main menu
}

// Function to display the main menu and handle user input
func mainMenu() {
    print("Welcome to the Grade Manager!")
    print("\nWhat would you like to do? (Enter the number):")
    print("1. Display grade of a single student")
    print("2. Display all grades for a student")
    print("3. Display all grades of ALL students")
    print("4. Find the average grade of the class")
    print("5. Find the average grade of an assignment")
    print("6. Find the lowest grade in the class")
    print("7. Find the highest grade of the class")
    print("8. Filter students by grade range")
    print("9. Quit")
    
    // Get user input
    if let userInput = readLine() {
        switch userInput {
        case "1":
            singleGrade()
        case "2":
            allGrades()
        case "3":
            allGradesStudents()
        case "4":
            avrgGradeClass()
        case "5":
            avrgGradeAsgmt()
        case "6":
            lwstGrade()
        case "7":
            hgstGrade()
        case "8":
            studentRange()
        case "9":
            quit()
            isRunning = false // Exit the loop
        default:
            print("Please choose an appropriate option!")
        }
    }
}

// Function to display the grade of a single student
func singleGrade() {
    print("Which student would you like to choose?")
    if let itemInput = readLine() {
        for student in students {
            if student.name == itemInput {
                // Display the final score for the selected student
                print("\(student.name)'s grade in the class is \(student.finalScore)")
                return
            }
        }
        print("Student not found. Please try again.")
    }
}

// Function to display all grades for a specific student
func allGrades() {
    print("Which student would you like to choose?")
    if let itemInput = readLine() {
        for student in students {
            if student.name == itemInput {
                // Display all scores for the selected student
                print("\(student.name)'s grades for this class are: \(student.scores.joined(separator: " "))")
                return
            }
        }
        print("Student not found. Please try again.")
    }
}

// Function to display all grades for all students
func allGradesStudents() {
    for student in students {
        // Display all scores for each student
        print("\(student.name)'s grades for this class are: \(student.scores.joined(separator: " "))")
    }
}

// Function to calculate and display the average grade of the class
func avrgGradeClass() {
    var totalSum: Double = 0.0
    var validCount: Int = 0 // Track students with valid scores

    // Iterate through the students to calculate the total sum and count valid students
    for student in students {
        if student.scores.count > 0 { // Ensure the student has scores
            totalSum += student.finalScore
            validCount += 1
        }
    }

    // Calculate and display the class average if there are valid students
    if validCount > 0 {
        let classAverage = totalSum / Double(validCount)
        print("The class average is: \(String(format: "%.2f", classAverage))")
    } else {
        print("No valid student data available to calculate the average.")
    }
}

// Function to calculate and display the average grade of a specific assignment
func avrgGradeAsgmt() {
    print("Which assignment would you like to get the average of (1-10):")
    if let itemInput = readLine(), let index = Int(itemInput), index > 0, index <= 10 {
        var sum: Double = 0.0
        var count: Int = 0 // Track valid scores

        // Iterate through the students to calculate the total score for the specified assignment
        for student in students {
            if student.scores.indices.contains(index - 1), let score = Double(student.scores[index - 1]) {
                sum += score
                count += 1
            }
        }

        // Calculate and display the average for the specified assignment
        if count > 0 {
            let average: Double = sum / Double(count)
            print("The average for assignment #\(index) is \(String(format: "%.2f", average))")
        } else {
            print("No valid scores found for assignment #\(index).")
        }
    } else {
        print("Please enter a valid assignment number (1-10).")
    }
}

// Function to find and display the student with the lowest grade
func lwstGrade() {
    if let lowestStudent = students.min(by: { $0.finalScore < $1.finalScore }) {
        print("\(lowestStudent.name) is the student with the lowest grade: \(String(format: "%.2f", lowestStudent.finalScore))")
    } else {
        print("No students found.")
    }
}

// Function to find and display the student with the highest grade
func hgstGrade() {
    if let highestStudent = students.max(by: { $0.finalScore < $1.finalScore }) {
        print("\(highestStudent.name) is the student with the highest grade: \(String(format: "%.2f", highestStudent.finalScore))")
    } else {
        print("No students found.")
    }
}

// Function to filter and display students based on a grade range
func studentRange() {
    print("Enter the low range you would like to use:")
    if let lowestIndex = readLine(), let lowest = Double(lowestIndex) {
        print("Enter the high range you would like to use:")
        if let highestIndex = readLine(), let highest = Double(highestIndex) {
            if highest <= lowest {
                print("High range must be greater than low range.")
                mainMenu()
            } else {
                // Display students within the specified grade range
                for student in students {
                    if student.finalScore > lowest && student.finalScore < highest {
                        print("\(student.name): \(String(format: "%.2f", student.finalScore))")
                    }
                }
            }
        }
    }
}

// Function to exit the program
func quit() {
    print("Have a great rest of your day!")
}

