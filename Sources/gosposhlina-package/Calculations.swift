//
//  Calculations.swift
//  Gosposhlina

import SwiftUI
import Foundation

    // Формирование чисел - округление до двух знаков, и всегда вверх
public let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
        // formatter.roundingMode = .up
    return formatter
}()


public class Calculations {
    public var calculatedAmount = 0.0
    public var calculatedAmount2 = 0.0
    public var apellKassifSOUfl = 0.0
    public var apellKassifASfl = 0.0
    public var apellKassifSOUurl = 0.0
    public var apellKassifASurl = 0.0
    public var textResultSOU = ""
    public var textResultAS = ""
    public init() {}
    
    public func calculateCourtFee(_ claimAmount: String, courtTypeFee: String, instanceFee: String, isPrikaz: Bool, isPravaPotrebirel: Bool, typeIstec: String) -> (Double, Double, String, String) {
        guard let claimAmount = Double(claimAmount) else { return (0, 0, "", "") }
        // суд общей юрисдикции
        if claimAmount <= 20000 {
            calculatedAmount = max(400, claimAmount * 0.04)
            textResultSOU = String(format: "4 проц. от %.2f руб. = ", claimAmount, calculatedAmount) + String(claimAmount * 4 / 100) + " руб."
            if calculatedAmount == 400 {
                textResultSOU += " Берётся 400 руб."
            }
        } else if claimAmount <= 100000 {
            calculatedAmount = 800 + (claimAmount - 20000) * 0.03
            textResultSOU = String(format: "800 руб. + 3 проц. от (%.2f руб. - 20000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", claimAmount, calculatedAmount, calculatedAmount)
        } else if claimAmount <= 200000 {
            calculatedAmount = 3200 + (claimAmount - 100000) * 0.02
            textResultSOU = String(format: "3200 руб. + 2 проц. от (%.2f руб. - 100000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", claimAmount, calculatedAmount, calculatedAmount)
        } else if claimAmount <= 1000000 {
            calculatedAmount = 5200 + (claimAmount - 200000) * 0.01
            textResultSOU = String(format: "5200 руб. + 1 проц. от (%.2f руб. - 200000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", claimAmount, calculatedAmount, calculatedAmount)
        } else {
            calculatedAmount = min(60000, 13200 + (claimAmount - 1000000) * 0.005)
            textResultSOU = String(format: "13200 руб. + 0.5 проц. от (%.2f руб. - 1000000 руб.) = " + String(13200 + (claimAmount - 1000000) * 0.005) + " руб. Берётся %.2f руб.", claimAmount, calculatedAmount, calculatedAmount)
        }
        // арбитраж
        if claimAmount <= 100000 {
            calculatedAmount2 = max(2000, claimAmount * 0.04)
            textResultAS = String(format: "4 проц. от %.2f руб. = ", claimAmount, calculatedAmount) + String(claimAmount * 4 / 100) + " руб."
            if calculatedAmount2 == 2000 {
                textResultAS += " Берётся 2000 руб."
            }
        } else if claimAmount <= 200000 {
            calculatedAmount2 = round(4000 + (claimAmount - 100000) * 0.03)
            textResultAS += String(format: "4000 руб. + 3 проц. от (%.2f руб. - 100000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", claimAmount, calculatedAmount2, calculatedAmount2)
        } else if claimAmount <= 1000000 {
            calculatedAmount2 = 7000 + (claimAmount - 200000) * 0.02
            textResultAS += String(format: "7000 руб. + 2 проц. от (%.2f руб. - 200000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", claimAmount, calculatedAmount2, calculatedAmount2)

        } else if claimAmount <= 2000000 {
            calculatedAmount2 = 23000 + (claimAmount - 1000000) * 0.01
            textResultAS += String(format: "23000 руб. + 1 проц. от (%.2f руб. - 1000000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", claimAmount, calculatedAmount2, calculatedAmount2)

        } else {
            calculatedAmount2 = min(33000 + (claimAmount - 2000000) * 0.005, 200000)
            textResultAS += String(format: "33000 руб. + 0.5 проц. от (%.2f руб. - 2000000 руб.) = " + String(33000 + (claimAmount - 2000000) * 0.005) + " руб. Берётся %.2f руб.", claimAmount, calculatedAmount2, calculatedAmount2)
        }
        calculatedAmount = round(calculatedAmount)
        calculatedAmount2 = round(calculatedAmount2)
        return (calculatedAmount, calculatedAmount2, textResultSOU, textResultAS)
    }
    
}



 /*
// Использование класса Calculations
let claimAmount: Double = 10000 // Значение для примера
var calculatedAmount: Double = 0
var calculatedAmount2: Double = 0
var calculationDescription: String = ""

let calc = Calculations()
let calculationResult = calc.calculateCourtFee(String(claimAmount), courtTypeFee: "String", instanceFee: "String", isPrikaz: true, isPravaPotrebirel: true, typeIstec: "String")
calculatedAmount = calculationResult.0
calculatedAmount2 = calculationResult.1
calculationDescription = calculationResult.2

print("Результат расчета 1: \(calculatedAmount)")
print("Результат расчета 2: \(calculatedAmount2)")
print("Текстовое описание расчета:\n\(calculationDescription)")
*/
