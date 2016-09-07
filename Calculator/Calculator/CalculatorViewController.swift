//
//  ViewController.swift
//  Calculator
//
//  Created by CAOYE on 8/17/16.
//  Copyright © 2016 CAOYE. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    private var typingFlag = false
    private var model = CalculatorModel()
    
    // Operand操作数
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        //println("digit = \(digit)");
        
        if typingFlag {
            // Only ONE .
            if (digit == ".") && (display.text!.rangeOfString(".") != nil) { return }
            
            // Leading 0s
            if (digit == "0") && ((display.text == "0") || (display.text == "-0")) { return }
            if (digit != ".") && ((display.text == "0") || (display.text == "-0")) {
                if (display.text == "0") {
                    display.text = digit
                } else {
                    display.text = "-" + digit
                }
            } else {
                display.text = display.text! + digit
            }
        } else {
            if digit == "." {
                display.text = "0."
            } else {
                display.text = digit
            }
            history.text = model.description != "?" ? model.description : ""
            typingFlag = true
        }
    }
    
    // Operation操作符
    @IBAction func operate(sender: UIButton) {
        if let operation = sender.currentTitle {
            if typingFlag {
                if operation == "±" {
                    let text = display.text!
                    if (text.rangeOfString("-") != nil) {
                        display.text = String(text.characters.dropFirst())
                    } else {
                        display.text = "-" + text
                    }
                    return
                }
                enter()
            }
            
            if let result = model.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func enter() {
        typingFlag = false
        if let result = model.pushOperand(displayValue!) {
            displayValue = result
        } else {
            // error?
            displayValue = 0;
        }
    }
    
    @IBAction func clear() {
        model = CalculatorModel()
        displayValue = 0
        history.text = ""
    }

    @IBAction func backSpace() {
        if typingFlag {
            let text = display.text!
            if text.characters.count > 1 {
                display.text = String(text.characters.dropLast())
                if (text.characters.count == 2) && (text.rangeOfString("-") != nil) { //display.text?
                    display.text = "0"
                }
            } else {
                display.text = "0"
            }
        } else {
            if let result = model.popOperand() {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
    }
    
    @IBAction func storeVariable(sender: UIButton) {
        if let variable = sender.currentTitle!.characters.last {
            if displayValue != nil {
                model.variableValues["\(variable)"] = displayValue
                if let result = model.evaluate() {
                    displayValue = result
                } else {
                    displayValue = nil
                }
            }
        }
        typingFlag = false
    }
    
    @IBAction func pushVariable(sender: UIButton) {
        if typingFlag {
            enter()
        }
        if let result = model.pushOperand(sender.currentTitle!) {
            displayValue = result
        } else {
            displayValue = nil
        }
    }
    
    var displayValue: Double? {
        get { return NSNumberFormatter().numberFromString(display.text!)?.doubleValue }
        set {
            if newValue != nil {
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = .DecimalStyle
                numberFormatter.maximumFractionDigits = 10
                display.text = numberFormatter.stringFromNumber(newValue!)
            } else {
                if let result = model.evaluateAndReportErrors() as? String {
                    display.text = result
                } else {
                    display.text = " ";
                }
            }
            typingFlag = false
            history.text = model.description + " ="
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController
        if let nc = destination as? UINavigationController {
            destination = nc.visibleViewController!
        }
        if let gvc = destination as? GraphViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case "Show Graph":
                    gvc.title = model.description == "" ? "Graph" : model.description.componentsSeparatedByString(", ").last
                    gvc.program = model.program
                default:
                    break
                }
            }
        }
    }
}

