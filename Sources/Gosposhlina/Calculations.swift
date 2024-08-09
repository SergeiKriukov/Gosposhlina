//
//  Calculations.swift
//  Gosposhlina

import Foundation

/// Model
public enum CourtType: String {
    case commonUrisdiction
    case arbitrazh
}

public enum InstanceType {
    case one
    case two
    case three
}

public enum FeeMode: Int, CaseIterable {
    case ruCurrent
    case ru2024
    case ru1995
    case ru1991
    case kz1995
    
    var title: String {
        switch self {
        case .ruCurrent:
            "Действующая (с 01.01.2005)"
        case .ru2024:
            "Проект от 08.07.2024 года"
        case .ru1995:
            "С 31.12.1995 по 01.01.2005 года"
        case .ru1991:
            "С 09.12.1991 по 31.12.1995 года"
        case .kz1995:
            "KZ: С 31.12.1995 по 01.01.2005 года"
        }
    }
}

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
    private var textLabel = ""

    public var feeMode = FeeMode.ruCurrent
    
    public init() {}
    
    public var feeModeTitle: String {
        feeMode.title
    }
    
    // Метод расчета с 2024 года
    public func courtFee2024(_ amount: Double, courtType: CourtType, instanceType: InstanceType) -> (Double, String) {
        
        // суд общей юрисдикции
        if amount <= 100000 {
            calculatedAmount = 4000
            textResultSOU = "Берётся 4000 руб."
        } else if amount <= 500000 {
            calculatedAmount = 4000 + (amount - 100000) * 0.04
            textResultSOU = String(format: "4000 руб. + 4 проц. от (%.2f руб. - 100000 руб.) = %.2f руб.", amount, calculatedAmount)
        } else if amount <= 1000000 {
            calculatedAmount = 20000 + (amount - 500000) * 0.02
            textResultSOU = String(format: "20000 руб. + 2 проц. от (%.2f руб. - 500000 руб.) = %.2f руб.", amount, calculatedAmount)
        } else if amount <= 10000000 {
            calculatedAmount = 30000 + (amount - 1000000) * 0.01
            textResultSOU = String(format: "30000 руб. + 1 проц. от (%.2f руб. - 1000000 руб.) = %.2f руб.", amount, calculatedAmount)
        } else if amount <= 50000000 {
            calculatedAmount = 120000 + (amount - 10000000) * 0.005
            textResultSOU = String(format: "120000 руб. + 0.5 проц. от (%.2f руб. - 10000000 руб.) = %.2f руб.", amount, calculatedAmount)
        } else {
            calculatedAmount = 320000 + (amount - 50000000) * 0.002
            textResultSOU = String(format: "320000 руб. + 0.2 проц. от (%.2f руб. - 50000000 руб.) = %.2f руб.", amount, calculatedAmount)
        }
        
        // арбитраж
        if amount <= 100000 {
            calculatedAmount2 = 10000
            textResultAS = "Берётся 10000 руб."
        } else if amount <= 1000000 {
            calculatedAmount2 = 10000 + (amount - 100000) * 0.05
            textResultAS = String(format: "10000 руб. + 5 проц. от (%.2f руб. - 100000 руб.) = %.2f руб.", amount, calculatedAmount2)
        } else if amount <= 10000000 {
            calculatedAmount2 = 55000 + (amount - 1000000) * 0.03
            textResultAS = String(format: "55000 руб. + 3 проц. от (%.2f руб. - 1000000 руб.) = %.2f руб.", amount, calculatedAmount2)
        } else if amount <= 50000000 {
            calculatedAmount2 = 325000 + (amount - 10000000) * 0.01
            textResultAS = String(format: "325000 руб. + 1 проц. от (%.2f руб. - 10000000 руб.) = %.2f руб.", amount, calculatedAmount2)
        } else {
            calculatedAmount2 = 725000 + (amount - 50000000) * 0.005
            textResultAS = String(format: "725000 руб. + 0.5 проц. от (%.2f руб. - 50000000 руб.) = %.2f руб.", amount, calculatedAmount2)
        }
        
        
        // В зависимости от типа суда
        // возвращаем результат - сумму и описание
        switch courtType {
        case .commonUrisdiction:
            calculatedAmount = round(calculatedAmount)
            textLabel = textResultSOU
            
        case .arbitrazh:
            calculatedAmount = round(calculatedAmount2)
            textLabel = textResultAS
        }
        
        return (calculatedAmount, textLabel)
    }
    
    // Метод расчета с 2005 до 2024 года
    public func courtFee(_ amount: Double, courtType: CourtType, instanceType: InstanceType, isPrikaz: Bool, isPravaPotrebirel: Bool, isFizik: Bool) -> (Double, String) {
        // суд общей юрисдикции
        if amount <= 20000 {
            calculatedAmount = max(400, amount * 0.04)
            textResultSOU = String(format: "4 проц. от %.2f руб. = ", amount, calculatedAmount) + String(amount * 4 / 100) + " руб."
            if calculatedAmount == 400 {
                textResultSOU += " Берётся 400 руб."
            }
        } else if amount <= 100000 {
            calculatedAmount = 800 + (amount - 20000) * 0.03
            textResultSOU = String(format: "800 руб. + 3 проц. от (%.2f руб. - 20000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", amount, calculatedAmount, calculatedAmount)
        } else if amount <= 200000 {
            calculatedAmount = 3200 + (amount - 100000) * 0.02
            textResultSOU = String(format: "3200 руб. + 2 проц. от (%.2f руб. - 100000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", amount, calculatedAmount, calculatedAmount)
        } else if amount <= 1000000 {
            calculatedAmount = 5200 + (amount - 200000) * 0.01
            textResultSOU = String(format: "5200 руб. + 1 проц. от (%.2f руб. - 200000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", amount, calculatedAmount, calculatedAmount)
        } else {
            calculatedAmount = min(60000, 13200 + (amount - 1000000) * 0.005)
            textResultSOU = String(format: "13200 руб. + 0.5 проц. от (%.2f руб. - 1000000 руб.) = " + String(13200 + (amount - 1000000) * 0.005) + " руб. Берётся %.2f руб.", amount, calculatedAmount, calculatedAmount)
        }
        // арбитраж
        if amount <= 100000 {
            calculatedAmount2 = max(2000, amount * 0.04)
            textResultAS = String(format: "4 проц. от %.2f руб. = ", amount, calculatedAmount) + String(amount * 4 / 100) + " руб."
            if calculatedAmount2 == 2000 {
                textResultAS += " Берётся 2000 руб."
            }
        } else if amount <= 200000 {
            calculatedAmount2 = round(4000 + (amount - 100000) * 0.03)
            textResultAS += String(format: "4000 руб. + 3 проц. от (%.2f руб. - 100000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", amount, calculatedAmount2, calculatedAmount2)
        } else if amount <= 1000000 {
            calculatedAmount2 = 7000 + (amount - 200000) * 0.02
            textResultAS += String(format: "7000 руб. + 2 проц. от (%.2f руб. - 200000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", amount, calculatedAmount2, calculatedAmount2)
            
        } else if amount <= 2000000 {
            calculatedAmount2 = 23000 + (amount - 1000000) * 0.01
            textResultAS += String(format: "23000 руб. + 1 проц. от (%.2f руб. - 1000000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", amount, calculatedAmount2, calculatedAmount2)
            
        } else {
            calculatedAmount2 = min(33000 + (amount - 2000000) * 0.005, 200000)
            textResultAS += String(format: "33000 руб. + 0.5 проц. от (%.2f руб. - 2000000 руб.) = " + String(33000 + (amount - 2000000) * 0.005) + " руб. Берётся %.2f руб.", amount, calculatedAmount2, calculatedAmount2)
        }
        
        // В зависимости от типа суда
        // возвращаем результат - сумму и описание
        switch courtType {
        case .commonUrisdiction:
            calculatedAmount = round(calculatedAmount)
            textLabel = textResultSOU
            
        case .arbitrazh:
            calculatedAmount = round(calculatedAmount2)
            textLabel = textResultAS
        }
        
        return (calculatedAmount, textLabel)
    }

    // Метод расчета госпошлины до 2005 года
    public func courtFeeBefore2005(_ amount: Double, courtType: CourtType) -> (Double, String) {
        
        // Суд общей юрисдикции
        if amount <= 1000000 / 1000 {
            calculatedAmount = amount * 0.005
            textResultSOU = String(format: "5 проц. от %.2f руб. = %.2f руб.", amount, calculatedAmount)
        } else if amount <= 10000000 / 1000 {
            calculatedAmount = 50000 / 1000 + (amount - 1000000 / 1000) * 0.04
            textResultSOU = String(format: "50 тыс. руб. + 4 проц. от (%.2f руб. - 1 млн. руб.) = %.2f руб.", amount, calculatedAmount)
        } else if amount <= 50000000 / 1000 {
            calculatedAmount = 410000 / 1000 + (amount - 10000000 / 1000) * 0.03
            textResultSOU = String(format: "410 тыс. руб. + 3 проц. от (%.2f руб. - 10 млн. руб.) = %.2f руб.", amount, calculatedAmount)
        } else if amount <= 100000000 / 1000 {
            calculatedAmount = 1610000 / 1000 + (amount - 50000000 / 1000) * 0.02
            textResultSOU = String(format: "1 млн. 610 тыс. руб. + 2 проц. от (%.2f руб. - 50 млн. руб.) = %.2f руб.", amount, calculatedAmount)
        } else if amount <= 500000000 / 1000 {
            calculatedAmount = 2610000 / 1000 + (amount - 100000000 / 1000) * 0.01
            textResultSOU = String(format: "2 млн. 610 тыс. руб. + 1 проц. от (%.2f руб. - 100 млн. руб.) = %.2f руб.", amount, calculatedAmount)
        } else {
            calculatedAmount = amount * 0.015
            textResultSOU = String(format: "1.5 проц. от %.2f руб. = %.2f руб.", amount, calculatedAmount)
        }
        
        // Арбитраж
        if amount <= 10000000 / 1000 {
            calculatedAmount2 = max(amount * 0.05, 1)
            textResultAS = String(format: "5 проц. от %.2f руб., но не менее 1 руб. = %.2f руб.", amount, calculatedAmount2)
        } else if amount <= 50000000 / 1000 {
            calculatedAmount2 = 500000 / 1000 + (amount - 10000000 / 1000) * 0.04
            textResultAS = String(format: "500 тыс. руб. + 4 проц. от (%.2f руб. - 10 млн. руб.) = %.2f руб.", amount, calculatedAmount2)
        } else if amount <= 100000000 / 1000 {
            calculatedAmount2 = 2100000 / 1000 + (amount - 50000000 / 1000) * 0.03
            textResultAS = String(format: "2 млн. 100 тыс. руб. + 3 проц. от (%.2f руб. - 50 млн. руб.) = %.2f руб.", amount, calculatedAmount2)
        } else if amount <= 500000000 / 1000 {
            calculatedAmount2 = 3600000 / 1000 + (amount - 100000000 / 1000) * 0.02
            textResultAS = String(format: "3 млн. 600 тыс. руб. + 2 проц. от (%.2f руб. - 100 млн. руб.) = %.2f руб.", amount, calculatedAmount2)
        } else if amount <= 1000000000 / 1000 {
            calculatedAmount2 = 11600000 / 1000 + (amount - 500000000 / 1000) * 0.01
            textResultAS = String(format: "11 млн. 600 тыс. руб. + 1 проц. от (%.2f руб. - 500 млн. руб.) = %.2f руб.", amount, calculatedAmount2)
        } else {
            calculatedAmount2 = 16600000 / 1000 + (amount - 1000000000 / 1000) * 0.005
            textResultAS = String(format: "16 млн. 600 тыс. руб. + 0.5 проц. от (%.2f руб. - 1 млрд. руб.) = %.2f руб.", amount, calculatedAmount2)
        }
        
        // В зависимости от типа суда
        // возвращаем результат - сумму и описание
        switch courtType {
        case .commonUrisdiction:
            calculatedAmount = round(calculatedAmount)
            textLabel = textResultSOU
            
        case .arbitrazh:
            calculatedAmount = round(calculatedAmount2)
            textLabel = textResultAS
        }
        
        return (calculatedAmount, textLabel)
    }

    
    
    
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
    
    // Новая функция расчета на 2024 год
    public func calculateCourtFee2024(_ claimAmount: String, courtTypeFee: String, instanceFee: String) -> (Double, Double, String, String) {
        guard let claimAmount = Double(claimAmount) else { return (0, 0, "", "") }
        
        // суд общей юрисдикции
        if claimAmount <= 100000 {
            calculatedAmount = 4000
            textResultSOU = "Берётся 4000 руб."
        } else if claimAmount <= 500000 {
            calculatedAmount = 4000 + (claimAmount - 100000) * 0.04
            textResultSOU = String(format: "4000 руб. + 4 проц. от (%.2f руб. - 100000 руб.) = %.2f руб.", claimAmount, calculatedAmount)
        } else if claimAmount <= 1000000 {
            calculatedAmount = 20000 + (claimAmount - 500000) * 0.02
            textResultSOU = String(format: "20000 руб. + 2 проц. от (%.2f руб. - 500000 руб.) = %.2f руб.", claimAmount, calculatedAmount)
        } else if claimAmount <= 10000000 {
            calculatedAmount = 30000 + (claimAmount - 1000000) * 0.01
            textResultSOU = String(format: "30000 руб. + 1 проц. от (%.2f руб. - 1000000 руб.) = %.2f руб.", claimAmount, calculatedAmount)
        } else if claimAmount <= 50000000 {
            calculatedAmount = 120000 + (claimAmount - 10000000) * 0.005
            textResultSOU = String(format: "120000 руб. + 0.5 проц. от (%.2f руб. - 10000000 руб.) = %.2f руб.", claimAmount, calculatedAmount)
        } else {
            calculatedAmount = 320000 + (claimAmount - 50000000) * 0.002
            textResultSOU = String(format: "320000 руб. + 0.2 проц. от (%.2f руб. - 50000000 руб.) = %.2f руб.", claimAmount, calculatedAmount)
        }
        
        // арбитраж
        if claimAmount <= 100000 {
            calculatedAmount2 = 10000
            textResultAS = "Берётся 10000 руб."
        } else if claimAmount <= 1000000 {
            calculatedAmount2 = 10000 + (claimAmount - 100000) * 0.05
            textResultAS = String(format: "10000 руб. + 5 проц. от (%.2f руб. - 100000 руб.) = %.2f руб.", claimAmount, calculatedAmount2)
        } else if claimAmount <= 10000000 {
            calculatedAmount2 = 55000 + (claimAmount - 1000000) * 0.03
            textResultAS = String(format: "55000 руб. + 3 проц. от (%.2f руб. - 1000000 руб.) = %.2f руб.", claimAmount, calculatedAmount2)
        } else if claimAmount <= 50000000 {
            calculatedAmount2 = 325000 + (claimAmount - 10000000) * 0.01
            textResultAS = String(format: "325000 руб. + 1 проц. от (%.2f руб. - 10000000 руб.) = %.2f руб.", claimAmount, calculatedAmount2)
        } else {
            calculatedAmount2 = 725000 + (claimAmount - 50000000) * 0.005
            textResultAS = String(format: "725000 руб. + 0.5 проц. от (%.2f руб. - 50000000 руб.) = %.2f руб.", claimAmount, calculatedAmount2)
        }
        
        calculatedAmount = round(calculatedAmount)
        calculatedAmount2 = round(calculatedAmount2)
        
        return (calculatedAmount, calculatedAmount2, textResultSOU, textResultAS)
    }
    
    // Функция расчета госпошлины до 2005 года
       public func calculateCourtFeeBefore2005(_ claimAmount: String, courtTypeFee: String) -> (Double, Double, String, String) {
           guard let claimAmount = Double(claimAmount) else { return (0, 0, "", "") }
           
           // Суд общей юрисдикции
           if claimAmount <= 1000000 / 1000 {
               calculatedAmount = claimAmount * 0.005
               textResultSOU = String(format: "5 проц. от %.2f руб. = %.2f руб.", claimAmount, calculatedAmount)
           } else if claimAmount <= 10000000 / 1000 {
               calculatedAmount = 50000 / 1000 + (claimAmount - 1000000 / 1000) * 0.04
               textResultSOU = String(format: "50 тыс. руб. + 4 проц. от (%.2f руб. - 1 млн. руб.) = %.2f руб.", claimAmount, calculatedAmount)
           } else if claimAmount <= 50000000 / 1000 {
               calculatedAmount = 410000 / 1000 + (claimAmount - 10000000 / 1000) * 0.03
               textResultSOU = String(format: "410 тыс. руб. + 3 проц. от (%.2f руб. - 10 млн. руб.) = %.2f руб.", claimAmount, calculatedAmount)
           } else if claimAmount <= 100000000 / 1000 {
               calculatedAmount = 1610000 / 1000 + (claimAmount - 50000000 / 1000) * 0.02
               textResultSOU = String(format: "1 млн. 610 тыс. руб. + 2 проц. от (%.2f руб. - 50 млн. руб.) = %.2f руб.", claimAmount, calculatedAmount)
           } else if claimAmount <= 500000000 / 1000 {
               calculatedAmount = 2610000 / 1000 + (claimAmount - 100000000 / 1000) * 0.01
               textResultSOU = String(format: "2 млн. 610 тыс. руб. + 1 проц. от (%.2f руб. - 100 млн. руб.) = %.2f руб.", claimAmount, calculatedAmount)
           } else {
               calculatedAmount = claimAmount * 0.015
               textResultSOU = String(format: "1.5 проц. от %.2f руб. = %.2f руб.", claimAmount, calculatedAmount)
           }
           
           // Арбитраж
           if claimAmount <= 10000000 / 1000 {
               calculatedAmount2 = max(claimAmount * 0.05, 1)
               textResultAS = String(format: "5 проц. от %.2f руб., но не менее 1 руб. = %.2f руб.", claimAmount, calculatedAmount2)
           } else if claimAmount <= 50000000 / 1000 {
               calculatedAmount2 = 500000 / 1000 + (claimAmount - 10000000 / 1000) * 0.04
               textResultAS = String(format: "500 тыс. руб. + 4 проц. от (%.2f руб. - 10 млн. руб.) = %.2f руб.", claimAmount, calculatedAmount2)
           } else if claimAmount <= 100000000 / 1000 {
               calculatedAmount2 = 2100000 / 1000 + (claimAmount - 50000000 / 1000) * 0.03
               textResultAS = String(format: "2 млн. 100 тыс. руб. + 3 проц. от (%.2f руб. - 50 млн. руб.) = %.2f руб.", claimAmount, calculatedAmount2)
           } else if claimAmount <= 500000000 / 1000 {
               calculatedAmount2 = 3600000 / 1000 + (claimAmount - 100000000 / 1000) * 0.02
               textResultAS = String(format: "3 млн. 600 тыс. руб. + 2 проц. от (%.2f руб. - 100 млн. руб.) = %.2f руб.", claimAmount, calculatedAmount2)
           } else if claimAmount <= 1000000000 / 1000 {
               calculatedAmount2 = 11600000 / 1000 + (claimAmount - 500000000 / 1000) * 0.01
               textResultAS = String(format: "11 млн. 600 тыс. руб. + 1 проц. от (%.2f руб. - 500 млн. руб.) = %.2f руб.", claimAmount, calculatedAmount2)
           } else {
               calculatedAmount2 = 16600000 / 1000 + (claimAmount - 1000000000 / 1000) * 0.005
               textResultAS = String(format: "16 млн. 600 тыс. руб. + 0.5 проц. от (%.2f руб. - 1 млрд. руб.) = %.2f руб.", claimAmount, calculatedAmount2)
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
