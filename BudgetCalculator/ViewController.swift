//
//  ViewController.swift
//  BudgetCalculator
//
//  Created by fiston madimba on 10/10/18.
//  Copyright © 2018 fiston madimba. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var displayLabel: UILabel!
    
    var displayedNumber = 0.0
    var numbersToCompute = [Double]()
    var operations = [String]()
    var operationClicked: Bool = false
    var lastComputedNumber = 0.0
    var lastOperationClicked = ""
    var globalTotal = 0.0
    
    //for consecutive operation clicked beside equals
    var plusOrMinus = 0
    var multiplyOrDivide = 0
    
    var plusIsLastClicked: Bool = false
    var minusIsLastClicked: Bool = false
    var multiplyIsLastClicked: Bool = false
    var divideIsLastClicked: Bool = false
    var equalIsLastClicked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        displayLabel.text = "0"
    }
    
    @IBAction func displayNumber(_ sender: UIButton) {
        if displayLabel.text == "0" {
            displayLabel.text = ""
        }
        
        if !operationClicked {
            displayLabel.text = displayLabel.text! + String(sender.tag)
        }
        else {
            displayLabel.text = String(sender.tag)
        }
        
        operationClicked = false
    }
    
    @IBAction func compute(_ sender: UIButton)  {
        var displayedOperation = "";
        displayedNumber = Double(displayLabel.text!)!
        
        numbersToCompute.append(displayedNumber)
        
        displayedOperation = convertTagToOperation(sender.tag)
        operations.append(displayedOperation)
        
        operationClicked = true
        equalIsLastClicked = false
        
        if displayedOperation == "+" {
            globalTotal = globalTotal + displayedNumber
        } else if displayedOperation == "-" {
            globalTotal = globalTotal - displayedNumber
        } else if displayedOperation == "/" {
            globalTotal = globalTotal / displayedNumber
        } else if displayedOperation == "*" {
           globalTotal = globalTotal * displayedNumber
        }
        
        consecutiveOperationClicked(displayedOperation)
        
        if plusOrMinus >= 2 {
            var result = 0.0
            result = globalTotal
            
            displayLabel.text = String(removeTrailingZero(temp: result))
            
            resetArrays()
            resetOperationsLastClicked()
            multiplyOrDivide = 0
            
        } else if multiplyOrDivide >= 2 {
            var result = 0.0
            result = globalTotal
            
            displayLabel.text = String(removeTrailingZero(temp: result))
            
            resetArrays()
            resetOperationsLastClicked()
            multiplyOrDivide = 0
        }
    }
    
    @IBAction func equals()  {
        if equalIsLastClicked == true {
            if lastOperationClicked == "+" {
                globalTotal = globalTotal + lastComputedNumber
                displayLabel.text = String(removeTrailingZero(temp: globalTotal))
            } else if lastOperationClicked == "-" {
                globalTotal = globalTotal - lastComputedNumber
                displayLabel.text = String(removeTrailingZero(temp: globalTotal))
            } else if lastOperationClicked == "/" {
                globalTotal = globalTotal / lastComputedNumber
                displayLabel.text = String(removeTrailingZero(temp: globalTotal))
            } else if lastOperationClicked == "*" {
                globalTotal = globalTotal * lastComputedNumber
                displayLabel.text = String(removeTrailingZero(temp: globalTotal))
            }
 
            resetArrays()
            operationClicked = true
            resetOperationsLastClicked()
            equalIsLastClicked = true
        }
        else {
            submit()
            resetArrays()
            operationClicked = true
            resetOperationsLastClicked()
            equalIsLastClicked = true
        }
    }
    
    // Light gray button
    @IBAction func resetDisplay() {
        displayLabel.text = "0"
        globalTotal = 0.0
        lastComputedNumber = 0.0
        lastOperationClicked = ""
        resetArrays()
        resetOperationsLastClicked()
    }
    
    @IBAction func addMinusSign() {
        displayLabel.text = "-" + displayLabel.text!
    }
    
    @IBAction func percentCalc() {
        displayedNumber = Double(displayLabel.text!)!/100
        displayLabel.text = String(displayedNumber)
    }
    
    // convert operation tag to operation
    func convertTagToOperation(_ tag: Int) -> String {
        
        var operation = ""
        
        if tag == 10 {
            operation = "/"
            divideIsLastClicked = true
        } else if tag == 11 {
            operation = "*"
            multiplyIsLastClicked = true
        } else if tag == 12 {
            operation = "-"
            minusIsLastClicked = true
        } else if tag == 13 {
            operation = "+"
            plusIsLastClicked = true
        }
        
        return operation
    }
    
    //reset array when submit (equal) is clicked
    func resetArrays() {
        operations.removeAll()
        numbersToCompute.removeAll()
    }
    
    func resetOperationsLastClicked() {
        plusIsLastClicked = false
        minusIsLastClicked = false
        multiplyIsLastClicked = false
        divideIsLastClicked = false
        equalIsLastClicked = false
    }
    
    //remove trailing zero for double
    func removeTrailingZero(temp: Double) -> String {
        let tempVar = String(format: "%g", temp)
        return tempVar
    }
    
    func consecutiveOperationClicked(_ operation: String) {
        
        if operation == "+" || operation == "-" {
            plusOrMinus = plusOrMinus + 1
        } else if operation == "*" || operation == "/" {
            multiplyOrDivide = multiplyOrDivide + 1
        }
    }
    
    func submit() {
        var result = 0.0
        
        displayedNumber = Double(displayLabel.text!)!
        numbersToCompute.append(displayedNumber)
        
        for i in 0..<operations.count {
            if operations[i] == "+" {
                result += numbersToCompute[i] + numbersToCompute[i+1]
            } else if operations[i] == "-" {
                result += numbersToCompute[i] - numbersToCompute[i+1]
            } else if operations[i] == "/" {
                result += numbersToCompute[i] / numbersToCompute[i+1]
            } else if operations[i] == "*" {
                result += numbersToCompute[i] * numbersToCompute[i+1]
            }
        }
        
        displayLabel.text = removeTrailingZero(temp: result)
        
        globalTotal = result
        lastOperationClicked = operations[operations.count - 1]
        lastComputedNumber = numbersToCompute[numbersToCompute.count - 1]
        
        resetOperationsLastClicked()
    }
}

