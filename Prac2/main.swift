//
//  main.swift
//  Prac2
//
//  Created by 김재승 on 2017. 5. 27..
//  Copyright © 2017년 김재승. All rights reserved.
//

import Foundation

let path = NSHomeDirectory().appending("/students.json")
var text: String = ""
do{
    text = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
}catch{print(error)}

let data = text.data(using: .utf8)!
var allEntries = [[String:Any]]()
allEntries = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]

var grades:Dictionary<String,Any> = [String:Any]()
for entry in allEntries{
    let grade = entry["grade"] as! [String:Any]
    var total : Int = 0
    var avg : Double = 0.0
    for (key,value) in grade{
        total += value as! Int
    }
    avg = Double(total)/Double(grade.count)
    grades[entry["name"] as! String] = round(avg*100)/100
}
let sortedGrade = grades.sorted(by: {$0.0 < $1.0})
var allTot: Double = 0
for (key,value) in sortedGrade {
    allTot += value as! Double
}
let allAvg: Double = allTot/Double(sortedGrade.count)
var result: String = "성적결과표\n\n"
result.append("전체 평균 : \(allAvg)\n\n")
result.append("개인별 학점\n")
var passStudent:Array<String> = Array<String>()
var count: Int = 0
for (key,value) in sortedGrade {
    if value as! Double >= 70 {
        passStudent.append(key)
    }
    result.append(key.padding(toLength: 11, withPad: " ", startingAt: 0))
    result.append(": ")
    switch value as! Double {
    case 90..<101:
        result.append("A")
    case 80..<90:
        result.append("B")
    case 70..<80:
        result.append("C")
    case 60..<70:
        result.append("D")
    default:
        result.append("F")
    }
    result.append("\n")
}
result.append("\n수료생\n")
for pass in passStudent {
    if pass == passStudent.last{
        result.append(pass)
    }
    else {
        result.append("\(pass), ")
    }
}
let path2 = NSHomeDirectory().appending("/result.txt")
try result.write(toFile: path2, atomically: true, encoding: String.Encoding.utf8)
