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
    case four
}

public enum LawType {
    case fizik, urik
}

public enum FeeMode: Int, CaseIterable {
    case ru09092024
    case ru01012005_08092024
    case ru31121995_31122004
    case ru09121991_31121995
    case kz31121995_01012005
    
    
    public var title: String {
        switch self {
        case .ru09092024:
            "Действующий c 09.09.2024 года"
        case .ru01012005_08092024:
            "С 01.01.2005 по 08.09.2024 года"
        case .ru31121995_31122004:
            "С 31.12.1995 по 31.12.2004 года"
        case .ru09121991_31121995:
            "С 09.12.1991 по 31.12.1995 года"
        case .kz31121995_01012005:
            "KZ: С 31.12.1995 по 01.01.2005 года"
        }
    }
}

public struct FeeResult {
    public var toPay: Double
    public var description: String
    
    public init(toPay: Double, description: String) {
        self.toPay = toPay
        self.description = description
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
//    public var apellKassifSOUfl = 0.0
//    public var apellKassifASfl = 0.0
//    public var apellKassifSOUurl = 0.0
//    public var apellKassifASurl = 0.0
    public var textResultSOU = ""
    public var textResultAS = ""
    private var textLabel = ""

    public var feeMode = FeeMode.ru09092024
    
    public init() {}
    
    public var feeModeTitle: String {
        feeMode.title
    }
    
    /// Common method
    public func courtFeeFor(_ mode: FeeMode, courtType: CourtType, instanceType: InstanceType, isPrikaz: Bool, potrebitel: Bool, lawType: LawType, of amount: Double) -> FeeResult {
        var result = FeeResult(toPay: 0, description: "")
        
        switch mode {
        case .ru09092024:
            switch courtType {
            case .commonUrisdiction:
                
                // все расчеты для СОЮ
                switch instanceType {
                case .one:
                    // расчеты госпошлины по первой инстанции
                    // Суд общей юрисдикции, первая инстанция
                    if amount <= 100000 {
                        calculatedAmount = 4000
                        textLabel = "Берётся 4000 руб."
                    } else if amount <= 300000 {
                        calculatedAmount = 4000 + (amount - 100000) * 0.03
                        textLabel = String(format: "4000 руб. + 3 %% от (%.2f руб. - 100000 руб.) = %.2f руб.", amount, calculatedAmount)
                    } else if amount <= 500000 {
                        calculatedAmount = 10000 + (amount - 300000) * 0.025
                        textLabel = String(format: "10000 руб. + 2.5 %% от (%.2f руб. - 300000 руб.) = %.2f руб.", amount, calculatedAmount)
                    } else if amount <= 1000000 {
                        calculatedAmount = 15000 + (amount - 500000) * 0.02
                        textLabel = String(format: "15000 руб. + 2 %% от (%.2f руб. - 500000 руб.) = %.2f руб.", amount, calculatedAmount)
                    } else if amount <= 3000000 {
                        calculatedAmount = 25000 + (amount - 1000000) * 0.01
                        textLabel = String(format: "25000 руб. + 1 %% от (%.2f руб. - 1000000 руб.) = %.2f руб.", amount, calculatedAmount)
                    } else if amount <= 8000000 {
                        calculatedAmount = 45000 + (amount - 3000000) * 0.007
                        textLabel = String(format: "45000 руб. + 0.7 %% от (%.2f руб. - 3000000 руб.) = %.2f руб.", amount, calculatedAmount)
                    } else if amount <= 24000000 {
                        calculatedAmount = 80000 + (amount - 8000000) * 0.0035
                        textLabel = String(format: "80000 руб. + 0.35 %% от (%.2f руб. - 8000000 руб.) = %.2f руб.", amount, calculatedAmount)
                    } else if amount <= 50000000 {
                        calculatedAmount = 136000 + (amount - 24000000) * 0.003
                        textLabel = String(format: "136000 руб. + 0.3 %% от (%.2f руб. - 24000000 руб.) = %.2f руб.", amount, calculatedAmount)
                    } else if amount <= 100000000 {
                        calculatedAmount = 214000 + (amount - 50000000) * 0.002
                        textLabel = String(format: "214000 руб. + 0.2 %% от (%.2f руб. - 50000000 руб.) = %.2f руб.", amount, calculatedAmount)
                    } else {
                        // Для суммы свыше 100 000 000 рублей
                        calculatedAmount = min(314000 + (amount - 100000000) * 0.0015, 900000)
                        textLabel = String(format: "314000 руб. + 0.15 %% от (%.2f руб. - 100000000 руб.) = %.2f руб., но не более 900000 руб.", amount, calculatedAmount)
                    }
                    
                    // Если приказ
                    if isPrikaz {
                        calculatedAmount = calculatedAmount/2
                        if amount <= 500000
                        {
                            textLabel = String("Цена иска менее 500000 рублей, поэтому возможно заявление о вынесении приказа.")
                         
                        } else {
                            textLabel = String("Цена иска более 500000 рублей, поэтому приказ не предусмотрен.")
                        }
  
                    }
                        
                    //    Если защита прав потребителей
                    if potrebitel {
                        //
                        if amount <= 1000000 {
                            calculatedAmount = 0
                        } else {
                            calculatedAmount = calculatedAmount - 25000
                          //  придумать обработку случая, когда почти 900000
                        }
                        textLabel = String("В случае, если цена иска превышает 1 000 000 рублей, госпошлина уплачивается в сумме, исчисленной в соответствии с подпунктом 1 пункта 1 статьи 333.19 НК РФ и уменьшенной на сумму государственной пошлины, подлежащей уплате при цене иска 1 000 000 рублей. При цене иска 1 000 000 рублей госпошлина составляет 25 000 рублей.")
                    }
                    
                case .two:
                    //   апелляция
                    switch lawType {
                    case .fizik:
                        calculatedAmount = 3000
                        textLabel = "Фиксированная сумма за аппеляцию физического лица"
                    case .urik:
                        calculatedAmount = 15000
                        textLabel = "Фиксированная сумма за аппеляцию юридического лица"
                    }

                case .three:
                    //   кассация
                    switch lawType {
                    case .fizik:
                        calculatedAmount = 5000
                        textLabel = "Фиксированная сумма за кассацию физического лица"
                    case .urik:
                        calculatedAmount = 20000
                        textLabel = "Фиксированная сумма за кассацию юридического лица"
                    }
                    
                case .four:
                    //   кассация ВС РФ
                    switch lawType {
                    case .fizik:
                        calculatedAmount = 7000
                        textLabel = "Фиксированная сумма за кассацию физического лица"
                    case .urik:
                        calculatedAmount = 25000
                        textLabel = "Фиксированная сумма за кассацию юридического лица"
                    }
                }
                                
            case .arbitrazh:
                print("arbitrazh")
                // все расчеты для АС
                switch instanceType {
                case .one:
                    // расчеты госпошлины по первой инстанции в АС
                    
                    if amount <= 100000 {
                        calculatedAmount = 10000
                        textLabel = "Берётся 10000 руб."
                    } else if amount <= 1000000 {
                        calculatedAmount = 10000 + (amount - 100000) * 0.05
                        textLabel = String(format: "10000 руб. + 5 %% от (%.2f руб. - 100000 руб.) = %.2f руб.", amount, calculatedAmount)
                    } else if amount <= 10000000 {
                        calculatedAmount = 55000 + (amount - 1000000) * 0.03
                        textResultAS = String(format: "5000 руб. + 3 %% от (%.2f руб. - 1000000 руб.) = %.2f руб.", amount, calculatedAmount)
                    } else if amount <= 50000000 {
                        calculatedAmount = 325000 + (amount - 10000000) * 0.01
                        textLabel = String(format: "325000 руб. + 1 %% от (%.2f руб. - 10000000 руб.) = %.2f руб.", amount, calculatedAmount)
                    } else {
                        // Ограничение на максимальную сумму
                        calculatedAmount = min(725000 + (amount - 50000000) * 0.005, 10000000)
                        textLabel = String(format: "725000 руб. + 0.5 %% от (%.2f руб. - 50000000 руб.) = %.2f руб., но не более 10000000 руб.", amount, calculatedAmount)
                    }
                    
                    // Если приказ
                    if isPrikaz {
                        calculatedAmount = calculatedAmount/2
                        if amount < 750000
                        {
                            textLabel = String("Цена иска менее 750000 рублей, поэтому возможно заявление о вынесении приказа.")
                         
                        } else {
                            textLabel = String("Цена иска более 750000 рублей, поэтому приказ не предусмотрен.")
                        }
  
                    }

                    
                case .two:
                    //   апелляция
                    switch lawType {
                    case .fizik:
                        calculatedAmount = 10000
                        textLabel = "Фиксированная сумма за аппеляцию физического лица"
                    case .urik:
                        calculatedAmount = 30000
                        textLabel = "Фиксированная сумма за аппеляцию юридического лица"
                    }
                    
                    
                case .three:
                    //   кассация  в АС
                    switch lawType {
                    case .fizik:
                        calculatedAmount = 2000
                        textLabel = "Фиксированная сумма за кассацию физического лица"
                    case .urik:
                        calculatedAmount = 50000
                        textLabel = "Фиксированная сумма за кассацию юридического лица"
                    }
                case .four:
                    //   кассация ВС РФ в АС
                    switch lawType {
                    case .fizik:
                        calculatedAmount = 30000
                        textLabel = "Фиксированная сумма за кассацию физического лица"
                    case .urik:
                        calculatedAmount = 80000
                        textLabel = "Фиксированная сумма за кассацию юридического лица"
                    }
                }
            }
            
            
        case .ru01012005_08092024:
           // print("calculate mode: \(mode.title)")
            switch courtType {
            case .commonUrisdiction:
                
                // все расчеты для СОЮ
                switch instanceType {
                case .one:
                    // расчеты госпошлины по первой инстанции
                    // Суд общей юрисдикции, первая инстанция
                    if amount <= 20000 {
                        calculatedAmount = max(400, amount * 0.04)
                        textLabel = String(format: "4 %% от %.2f руб. = ", amount, calculatedAmount) + String(amount * 4 / 100) + " руб."
                        if calculatedAmount == 400 {
                            textLabel += " Берётся 400 руб."
                        }
                    } else if amount <= 100000 {
                        calculatedAmount = 800 + (amount - 20000) * 0.03
                        textLabel = String(format: "800 руб. + 3 %% от (%.2f руб. - 20000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", amount, calculatedAmount, calculatedAmount)
                    } else if amount <= 200000 {
                        calculatedAmount = 3200 + (amount - 100000) * 0.02
                        textLabel = String(format: "3200 руб. + 2 %% от (%.2f руб. - 100000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", amount, calculatedAmount, calculatedAmount)
                    } else if amount <= 1000000 {
                        calculatedAmount = 5200 + (amount - 200000) * 0.01
                        textLabel = String(format: "5200 руб. + 1 %% от (%.2f руб. - 200000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", amount, calculatedAmount, calculatedAmount)
                    } else {
                        calculatedAmount = min(60000, 13200 + (amount - 1000000) * 0.005)
                        textLabel = String(format: "13200 руб. + 0.5 %% от (%.2f руб. - 1000000 руб.) = " + String(13200 + (amount - 1000000) * 0.005) + " руб. Берётся %.2f руб.", amount, calculatedAmount, calculatedAmount)
                    }
                    
                    // Если приказ
                    if isPrikaz {
                        calculatedAmount = calculatedAmount/2
                        if amount <= 500000
                        {
                            textLabel = String("Цена иска менее 500000 рублей, поэтому возможно заявление о вынесении приказа.")
                         
                        } else {
                            textLabel = String("Цена иска более 500000 рублей, поэтому приказ не предусмотрен.")
                        }
  
                    }
                    
                    //    Если защита прав потребителей
                    if potrebitel {
                        //
                        if amount <= 1000000 {
                            calculatedAmount = 0
                        } else {
                            calculatedAmount = calculatedAmount - 13200
                        }
                        textLabel = String("В случае, если цена иска превышает 1 000 000 рублей, госпошлина уплачивается в сумме, исчисленной в соответствии с подпунктом 1 пункта 1 статьи 333.19 НК РФ и уменьшенной на сумму государственной пошлины, подлежащей уплате при цене иска 1 000 000 рублей. При цене иска 1 000 000 рублей госпошлина составляет 13 200 рублей.")
                    }
                    
                case .two:
                    //   апелляция
                    switch lawType {
                    case .fizik:
                        calculatedAmount = 150
                        textLabel = "Фиксированная сумма за аппеляцию физического лица"
                    case .urik:
                        calculatedAmount = 3000
                        textLabel = "Фиксированная сумма за аппеляцию юридического лица"
                    }

                case .three:
                    //   кассация
                    switch lawType {
                    case .fizik:
                        calculatedAmount = 150
                        textLabel = "Фиксированная сумма за кассацию физического лица"
                    case .urik:
                        calculatedAmount = 3000
                        textLabel = "Фиксированная сумма за кассацию юридического лица"
                    }
                    
                case .four:
                    //   кассация ВС РФ
                    switch lawType {
                    case .fizik:
                        calculatedAmount = 300
                        textLabel = "Фиксированная сумма за кассацию в ВС РФ физического лица"
                    case .urik:
                        calculatedAmount = 6000
                        textLabel = "Фиксированная сумма за кассацию в ВС РФ юридического лица"
                    }
                }
                                
            case .arbitrazh:
                print("arbitrazh")
                // все расчеты для АС
                switch instanceType {
                case .one:
                    // расчеты госпошлины по первой инстанции в АС
                    
                    if amount <= 100000 {
                        calculatedAmount = max(2000, amount * 0.04)
                        textLabel = String(format: "4 %% от %.2f руб. = ", amount, calculatedAmount) + String(amount * 4 / 100) + " руб."
                        if calculatedAmount == 2000 {
                            textLabel += " Берётся 2000 руб."
                        }
                    } else if amount <= 200000 {
                        calculatedAmount = round(4000 + (amount - 100000) * 0.03)
                        textLabel = String(format: "4000 руб. + 3 %% от (%.2f руб. - 100000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", amount, calculatedAmount, calculatedAmount)
                    } else if amount <= 1000000 {
                        calculatedAmount = 7000 + (amount - 200000) * 0.02
                        textLabel = String(format: "7000 руб. + 2 %% от (%.2f руб. - 200000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", amount, calculatedAmount, calculatedAmount)
                        
                    } else if amount <= 2000000 {
                        calculatedAmount = 23000 + (amount - 1000000) * 0.01
                        textLabel = String(format: "23000 руб. + 1 %% от (%.2f руб. - 1000000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", amount, calculatedAmount, calculatedAmount)
                        
                    } else {
                        calculatedAmount = min(33000 + (amount - 2000000) * 0.005, 200000)
                        textLabel = String(format: "33000 руб. + 0.5 %% от (%.2f руб. - 2000000 руб.) = " + String(33000 + (amount - 2000000) * 0.005) + " руб. Берётся %.2f руб.", amount, calculatedAmount, calculatedAmount)
                    }
                    
                    // Если приказ
                    if isPrikaz {
                        calculatedAmount = calculatedAmount/2
                        if amount <= 750000
                        {
                            textLabel = String("Цена иска менее 750000 рублей, поэтому возможно заявление о вынесении приказа.")
                         
                        } else {
                            textLabel = String("Цена иска более 750000 рублей, поэтому приказ не предусмотрен.")
                        }
  
                    }

                    
                case .two:
                    //   апелляция
                    switch lawType {
                    case .fizik:
                        calculatedAmount = 150
                        textLabel = "Фиксированная сумма за аппеляцию физического лица"
                    case .urik:
                        calculatedAmount = 3000
                        textLabel = "Фиксированная сумма за аппеляцию юридического лица"
                    }
                    
                    
                case .three:
                    //   кассация  в АС
                    switch lawType {
                    case .fizik:
                        calculatedAmount = 150
                        textLabel = "Фиксированная сумма за кассацию физического лица"
                    case .urik:
                        calculatedAmount = 3000
                        textLabel = "Фиксированная сумма за кассацию юридического лица"
                    }
                case .four:
                    //   кассация ВС РФ в АС
                    switch lawType {
                    case .fizik:
                        calculatedAmount = 300
                        textLabel = "Фиксированная сумма за кассацию в ВС РФ физического лица"
                    case .urik:
                        calculatedAmount = 6000
                        textLabel = "Фиксированная сумма за кассацию в ВС РФ юридического лица"
                    }
                }
            }
            
            
        case .ru31121995_31122004:
            print("calculate mode: \(mode.title)")
            
            
            

        case .ru09121991_31121995:
            print("calculate mode: \(mode.title)")
            
            
            

        case .kz31121995_01012005:
            print("calculate mode: \(mode.title)")
            
            
            

        }
        
        result.toPay = round(calculatedAmount)
        result.description = textLabel
        return result
    }
    
    // Метод расчета с 09.09.2024 года (новая функция)
    public func courtFee2024(_ amount: Double, courtType: CourtType, instanceType: InstanceType, isPrikaz: Bool, isPravaPotrebirel: Bool, isFizik: Bool) -> (Double, String) {
        

            
            if courtType == .commonUrisdiction {
                // все расчеты для СОЮ
                if instanceType == .one {
                    // расчеты госпошлины по первой инстанции
                    // Суд общей юрисдикции, первая инстанция
               if amount <= 100000 {
                   calculatedAmount = 4000
                   textResultSOU = "Берётся 4000 руб."
               } else if amount <= 300000 {
                   calculatedAmount = 4000 + (amount - 100000) * 0.03
                   textResultSOU = String(format: "4000 руб. + 3 %% от (%.2f руб. - 100000 руб.) = %.2f руб.", amount, calculatedAmount)
               } else if amount <= 500000 {
                   calculatedAmount = 10000 + (amount - 300000) * 0.025
                   textResultSOU = String(format: "10000 руб. + 2.5 %% от (%.2f руб. - 300000 руб.) = %.2f руб.", amount, calculatedAmount)
               } else if amount <= 1000000 {
                   calculatedAmount = 15000 + (amount - 500000) * 0.02
                   textResultSOU = String(format: "15000 руб. + 2 %% от (%.2f руб. - 500000 руб.) = %.2f руб.", amount, calculatedAmount)
               } else if amount <= 3000000 {
                   calculatedAmount = 25000 + (amount - 1000000) * 0.01
                   textResultSOU = String(format: "25000 руб. + 1 %% от (%.2f руб. - 1000000 руб.) = %.2f руб.", amount, calculatedAmount)
               } else if amount <= 8000000 {
                   calculatedAmount = 45000 + (amount - 3000000) * 0.007
                   textResultSOU = String(format: "45000 руб. + 0.7 %% от (%.2f руб. - 3000000 руб.) = %.2f руб.", amount, calculatedAmount)
               } else if amount <= 24000000 {
                   calculatedAmount = 80000 + (amount - 8000000) * 0.0035
                   textResultSOU = String(format: "80000 руб. + 0.35 %% от (%.2f руб. - 8000000 руб.) = %.2f руб.", amount, calculatedAmount)
               } else if amount <= 50000000 {
                   calculatedAmount = 136000 + (amount - 24000000) * 0.003
                   textResultSOU = String(format: "136000 руб. + 0.3 %% от (%.2f руб. - 24000000 руб.) = %.2f руб.", amount, calculatedAmount)
               } else if amount <= 100000000 {
                   calculatedAmount = 214000 + (amount - 50000000) * 0.002
                   textResultSOU = String(format: "214000 руб. + 0.2 %% от (%.2f руб. - 50000000 руб.) = %.2f руб.", amount, calculatedAmount)
               } else {
                   // Для суммы свыше 100 000 000 рублей
                   calculatedAmount = min(314000 + (amount - 100000000) * 0.0015, 900000)
                   textResultSOU = String(format: "314000 руб. + 0.15 %% от (%.2f руб. - 100000000 руб.) = %.2f руб., но не более 900000 руб.", amount, calculatedAmount)
               }

                    
                } else if instanceType == .two {
                 //   апелляция
                    if isFizik {
                        calculatedAmount = 3000
                        textLabel = "Фиксированная сумма за аппеляцию физического лица"
                    } else {
                        calculatedAmount = 15000
                        textLabel = "Фиксированная сумма за аппеляцию юридического лица"
                    }

                    
                } else if instanceType == .three {
                    //   кассация
                       if isFizik {
                           calculatedAmount = 5000
                           textLabel = "Фиксированная сумма за кассацию физического лица"
                       } else {
                           calculatedAmount = 20000
                           textLabel = "Фиксированная сумма за кассацию юридического лица"
                       }
                } else if instanceType == .four {
                    //   кассация ВС РФ
                       if isFizik {
                           calculatedAmount = 7000
                           textLabel = "Фиксированная сумма за кассацию физического лица"
                       } else {
                           calculatedAmount = 25000
                           textLabel = "Фиксированная сумма за кассацию юридического лица"
                       }
                }
                
            } else if courtType == .arbitrazh {
                // все расчеты для АС
                if instanceType == .one {
                    // расчеты госпошлины по первой инстанции в АС

                    if amount <= 100000 {
                        calculatedAmount2 = 10000
                        textResultAS = "Берётся 10000 руб."
                    } else if amount <= 1000000 {
                        calculatedAmount2 = 10000 + (amount - 100000) * 0.05
                        textResultAS = String(format: "10000 руб. + 5 %% от (%.2f руб. - 100000 руб.) = %.2f руб.", amount, calculatedAmount2)
                    } else if amount <= 10000000 {
                        calculatedAmount2 = 55000 + (amount - 1000000) * 0.03
                        textResultAS = String(format: "5000 руб. + 3 %% от (%.2f руб. - 1000000 руб.) = %.2f руб.", amount, calculatedAmount2)
                    } else if amount <= 50000000 {
                        calculatedAmount2 = 325000 + (amount - 10000000) * 0.01
                        textResultAS = String(format: "325000 руб. + 1 %% от (%.2f руб. - 10000000 руб.) = %.2f руб.", amount, calculatedAmount2)
                    } else {
                        // Ограничение на максимальную сумму
                        calculatedAmount2 = min(725000 + (amount - 50000000) * 0.005, 10000000)
                        textResultAS = String(format: "725000 руб. + 0.5 %% от (%.2f руб. - 50000000 руб.) = %.2f руб., но не более 10000000 руб.", amount, calculatedAmount2)
                    }

                    
                } else if instanceType == .two {
                    //   апелляция
                       if isFizik {
                           calculatedAmount = 10000
                           textLabel = "Фиксированная сумма за аппеляцию физического лица"
                       } else {
                           calculatedAmount = 30000
                           textLabel = "Фиксированная сумма за аппеляцию юридического лица"
                       }

                       
                   } else if instanceType == .three {
                       //   кассация  в АС
                          if isFizik {
                              calculatedAmount = 2000
                              textLabel = "Фиксированная сумма за кассацию физического лица"
                          } else {
                              calculatedAmount = 50000
                              textLabel = "Фиксированная сумма за кассацию юридического лица"
                          }
                   } else if instanceType == .four {
                       //   кассация ВС РФ в АС
                          if isFizik {
                              calculatedAmount = 30000
                              textLabel = "Фиксированная сумма за кассацию физического лица"
                          } else {
                              calculatedAmount = 80000
                              textLabel = "Фиксированная сумма за кассацию юридического лица"
                          }
                   }
                
                    
                   
                
            }
        
      
        
    
        
        // Тип суда (СОЮ, АС). Потом еще добавим KS, TS01, TS02 и т.д.
        // Инстанция: 1, 2, 3, 4
        // Судебный приказ (true/false)
        // Защита прав потребителей (true/false)
        // Тип плательщика - ФЛ, ЮЛ
        
        
        // AS.1.PR0.ZPP0.UL
        // AS.1.PR0.ZPP-.-L основной расчет, первая инстанция АС, приказ - нет, ЗПП - не бывает в АС, лицо без разницы какое
           
        // Варианты:
        // СОЮ, 1, false, false, (ФЛ/ЮЛ)
        
        // SOU.1.PR0.ZPP0.-L основной расчет, первая инстанция СОЮ, приказ - нет, ЗПП - нет, лицо без разницы какое, поэтому "-" (так?)
        // SOU.1.PR1(max500000).ZPP0.-L  - основной расчет, первая инстация, выбран судебный приказ (при этом 500000 - это указание на максимальную цену иска, на которую может быть подан приказ (по ГПК РФ)),
 
        
        // СОЮ, 1, true, (false), (ФЛ/ЮЛ) СУДЕБНЫЙ ПРИКАЗ = 50% от 1 инстанции
        // АС, 1, true, (false), (ФЛ/ЮЛ) СУДЕБНЫЙ ПРИКАЗ = 50% от 1 инстанции, но не менее 8000 руб.
        
        // AS.1.PR1(max750000).ZPP-.-L(=min8000)   750000 - это указание на максимальную цену иска, на которую может быть подан приказ (АПК) - вариант 1, при этом минимальная сумма - 8000 рублей
        // AS.1.PR1(max100000).ZPP-.-L(=min8000)   100000 - это указание на максимальную цену иска, на которую может быть подан приказ (АПК) - вариант 2, при этом минимальная сумма - 8000 рублей
    
        
        // СОЮ, 1, (false - приказ не может быть если есть ЗПП), true, ФЛ (юрлицо не может быть) ЗАЩИТА ПРАВ ПОТРЕБИТЕЛЕЙ
        // SOU.1.PR0.ZPP1.FL
        
        
        // СОЮ, 2, (true), (false), ФЛ - 3000
        // СОЮ, 2, (true), (false), ЮЛ - 15000
        
        // SOU.2.PR0.ZPP0.FL = 3000
        // SOU.2.PR0.ZPP0.UL = 15000
        
        // СОЮ, 3, (true), (false), ФЛ - 5000
        // СОЮ, 3, (true), (false), ЮЛ - 20000
        
        // SOU.3.PR0.ZPP0.FL = 5000
        // SOU.3.PR0.ZPP0.UL = 20000
        
        // СОЮ, 4, (true), (false), ФЛ - 7000
        // СОЮ, 4, (true), (false), ЮЛ - 25000
        
        // SOU.4.PR0.ZPP0.FL = 7000
        // SOU.4.PR0.ZPP0.UL = 25000
        
        // АС, 2, (true), (false), ФЛ - 10000
        // АС, 2, (true), (false), ЮЛ - 30000
        
        // AS.2.PR0.ZPP0.FL = 10000
        // AS.2.PR0.ZPP0.UL = 30000
        
        
        // АС, 3, (true), (false), ФЛ - 20000
        // АС, 3, (true), (false), ЮЛ - 50000
        
        // AS.3.PR0.ZPP0.FL = 20000
        // AS.3.PR0.ZPP0.UL = 50000
        
        // АС, 4, (true), (false), ФЛ - 30000
        // АС, 4, (true), (false), ЮЛ - 80000
        
        // AS.4.PR0.ZPP0.FL = 30000
        // AS.4.PR0.ZPP0.UL = 80000
        
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
        
        // SOU.2.PR0.ZPP0.FL = 3000
        // SOU.2.PR0.ZPP0.UL = 15000
        
        return (calculatedAmount, textLabel)
    }
    
    // Метод расчета с 01.01.2005 до 08.09.2024 года (новая функция)
    public func courtFee(_ amount: Double, courtType: CourtType, instanceType: InstanceType, isPrikaz: Bool, isPravaPotrebirel: Bool, isFizik: Bool) -> (Double, String) {
        // суд общей юрисдикции
        if amount <= 20000 {
            calculatedAmount = max(400, amount * 0.04)
            textResultSOU = String(format: "4 %% от %.2f руб. = ", amount, calculatedAmount) + String(amount * 4 / 100) + " руб."
            if calculatedAmount == 400 {
                textResultSOU += " Берётся 400 руб."
            }
        } else if amount <= 100000 {
            calculatedAmount = 800 + (amount - 20000) * 0.03
            textResultSOU = String(format: "800 руб. + 3 %% от (%.2f руб. - 20000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", amount, calculatedAmount, calculatedAmount)
        } else if amount <= 200000 {
            calculatedAmount = 3200 + (amount - 100000) * 0.02
            textResultSOU = String(format: "3200 руб. + 2 %% от (%.2f руб. - 100000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", amount, calculatedAmount, calculatedAmount)
        } else if amount <= 1000000 {
            calculatedAmount = 5200 + (amount - 200000) * 0.01
            textResultSOU = String(format: "5200 руб. + 1 %% от (%.2f руб. - 200000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", amount, calculatedAmount, calculatedAmount)
        } else {
            calculatedAmount = min(60000, 13200 + (amount - 1000000) * 0.005)
            textResultSOU = String(format: "13200 руб. + 0.5 %% от (%.2f руб. - 1000000 руб.) = " + String(13200 + (amount - 1000000) * 0.005) + " руб. Берётся %.2f руб.", amount, calculatedAmount, calculatedAmount)
        }
        // арбитраж
        if amount <= 100000 {
            calculatedAmount2 = max(2000, amount * 0.04)
            textResultAS = String(format: "4 %% от %.2f руб. = ", amount, calculatedAmount) + String(amount * 4 / 100) + " руб."
            if calculatedAmount2 == 2000 {
                textResultAS += " Берётся 2000 руб."
            }
        } else if amount <= 200000 {
            calculatedAmount2 = round(4000 + (amount - 100000) * 0.03)
            textResultAS += String(format: "4000 руб. + 3 %% от (%.2f руб. - 100000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", amount, calculatedAmount2, calculatedAmount2)
        } else if amount <= 1000000 {
            calculatedAmount2 = 7000 + (amount - 200000) * 0.02
            textResultAS += String(format: "7000 руб. + 2 %% от (%.2f руб. - 200000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", amount, calculatedAmount2, calculatedAmount2)
            
        } else if amount <= 2000000 {
            calculatedAmount2 = 23000 + (amount - 1000000) * 0.01
            textResultAS += String(format: "23000 руб. + 1 %% от (%.2f руб. - 1000000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", amount, calculatedAmount2, calculatedAmount2)
            
        } else {
            calculatedAmount2 = min(33000 + (amount - 2000000) * 0.005, 200000)
            textResultAS += String(format: "33000 руб. + 0.5 %% от (%.2f руб. - 2000000 руб.) = " + String(33000 + (amount - 2000000) * 0.005) + " руб. Берётся %.2f руб.", amount, calculatedAmount2, calculatedAmount2)
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

    // Метод расчета госпошлины с 31.12.1995 по 31.12.2004 года (новая функция)
    public func courtFeeBefore2005(_ amount: Double, courtType: CourtType) -> (Double, String) {
        
        // Суд общей юрисдикции
        if amount <= 1000000 / 1000 {
            calculatedAmount = amount * 0.005
            textResultSOU = String(format: "5 %% от %.2f руб. = %.2f руб.", amount, calculatedAmount)
        } else if amount <= 10000000 / 1000 {
            calculatedAmount = 50000 / 1000 + (amount - 1000000 / 1000) * 0.04
            textResultSOU = String(format: "50 тыс. руб. + 4 %% от (%.2f руб. - 1 млн. руб.) = %.2f руб.", amount, calculatedAmount)
        } else if amount <= 50000000 / 1000 {
            calculatedAmount = 410000 / 1000 + (amount - 10000000 / 1000) * 0.03
            textResultSOU = String(format: "410 тыс. руб. + 3 %% от (%.2f руб. - 10 млн. руб.) = %.2f руб.", amount, calculatedAmount)
        } else if amount <= 100000000 / 1000 {
            calculatedAmount = 1610000 / 1000 + (amount - 50000000 / 1000) * 0.02
            textResultSOU = String(format: "1 млн. 610 тыс. руб. + 2 %% от (%.2f руб. - 50 млн. руб.) = %.2f руб.", amount, calculatedAmount)
        } else if amount <= 500000000 / 1000 {
            calculatedAmount = 2610000 / 1000 + (amount - 100000000 / 1000) * 0.01
            textResultSOU = String(format: "2 млн. 610 тыс. руб. + 1 %% от (%.2f руб. - 100 млн. руб.) = %.2f руб.", amount, calculatedAmount)
        } else {
            calculatedAmount = amount * 0.015
            textResultSOU = String(format: "1.5 %% от %.2f руб. = %.2f руб.", amount, calculatedAmount)
        }
        
        // Арбитраж
        if amount <= 10000000 / 1000 {
            calculatedAmount2 = max(amount * 0.05, 1)
            textResultAS = String(format: "5 %% от %.2f руб., но не менее 1 руб. = %.2f руб.", amount, calculatedAmount2)
        } else if amount <= 50000000 / 1000 {
            calculatedAmount2 = 500000 / 1000 + (amount - 10000000 / 1000) * 0.04
            textResultAS = String(format: "500 тыс. руб. + 4 %% от (%.2f руб. - 10 млн. руб.) = %.2f руб.", amount, calculatedAmount2)
        } else if amount <= 100000000 / 1000 {
            calculatedAmount2 = 2100000 / 1000 + (amount - 50000000 / 1000) * 0.03
            textResultAS = String(format: "2 млн. 100 тыс. руб. + 3 %% от (%.2f руб. - 50 млн. руб.) = %.2f руб.", amount, calculatedAmount2)
        } else if amount <= 500000000 / 1000 {
            calculatedAmount2 = 3600000 / 1000 + (amount - 100000000 / 1000) * 0.02
            textResultAS = String(format: "3 млн. 600 тыс. руб. + 2 %% от (%.2f руб. - 100 млн. руб.) = %.2f руб.", amount, calculatedAmount2)
        } else if amount <= 1000000000 / 1000 {
            calculatedAmount2 = 11600000 / 1000 + (amount - 500000000 / 1000) * 0.01
            textResultAS = String(format: "11 млн. 600 тыс. руб. + 1 %% от (%.2f руб. - 500 млн. руб.) = %.2f руб.", amount, calculatedAmount2)
        } else {
            calculatedAmount2 = 16600000 / 1000 + (amount - 1000000000 / 1000) * 0.005
            textResultAS = String(format: "16 млн. 600 тыс. руб. + 0.5 %% от (%.2f руб. - 1 млрд. руб.) = %.2f руб.", amount, calculatedAmount2)
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

    // Метод расчета госпошлины (старая функция)
    public func calculateCourtFee(_ claimAmount: String, courtTypeFee: String, instanceFee: String, isPrikaz: Bool, isPravaPotrebirel: Bool, typeIstec: String) -> (Double, Double, String, String) {
        guard let claimAmount = Double(claimAmount) else { return (0, 0, "", "") }
        // суд общей юрисдикции
        if claimAmount <= 20000 {
            calculatedAmount = max(400, claimAmount * 0.04)
            textResultSOU = String(format: "4 %% от %.2f руб. = ", claimAmount, calculatedAmount) + String(claimAmount * 4 / 100) + " руб."
            if calculatedAmount == 400 {
                textResultSOU += " Берётся 400 руб."
            }
        } else if claimAmount <= 100000 {
            calculatedAmount = 800 + (claimAmount - 20000) * 0.03
            textResultSOU = String(format: "800 руб. + 3 %% от (%.2f руб. - 20000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", claimAmount, calculatedAmount, calculatedAmount)
        } else if claimAmount <= 200000 {
            calculatedAmount = 3200 + (claimAmount - 100000) * 0.02
            textResultSOU = String(format: "3200 руб. + 2 %% от (%.2f руб. - 100000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", claimAmount, calculatedAmount, calculatedAmount)
        } else if claimAmount <= 1000000 {
            calculatedAmount = 5200 + (claimAmount - 200000) * 0.01
            textResultSOU = String(format: "5200 руб. + 1 %% от (%.2f руб. - 200000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", claimAmount, calculatedAmount, calculatedAmount)
        } else {
            calculatedAmount = min(60000, 13200 + (claimAmount - 1000000) * 0.005)
            textResultSOU = String(format: "13200 руб. + 0.5 %% от (%.2f руб. - 1000000 руб.) = " + String(13200 + (claimAmount - 1000000) * 0.005) + " руб. Берётся %.2f руб.", claimAmount, calculatedAmount, calculatedAmount)
        }
        // арбитраж
        if claimAmount <= 100000 {
            calculatedAmount2 = max(2000, claimAmount * 0.04)
            textResultAS = String(format: "4 %% от %.2f руб. = ", claimAmount, calculatedAmount) + String(claimAmount * 4 / 100) + " руб."
            if calculatedAmount2 == 2000 {
                textResultAS += " Берётся 2000 руб."
            }
        } else if claimAmount <= 200000 {
            calculatedAmount2 = round(4000 + (claimAmount - 100000) * 0.03)
            textResultAS += String(format: "4000 руб. + 3 %% от (%.2f руб. - 100000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", claimAmount, calculatedAmount2, calculatedAmount2)
        } else if claimAmount <= 1000000 {
            calculatedAmount2 = 7000 + (claimAmount - 200000) * 0.02
            textResultAS += String(format: "7000 руб. + 2 %% от (%.2f руб. - 200000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", claimAmount, calculatedAmount2, calculatedAmount2)
            
        } else if claimAmount <= 2000000 {
            calculatedAmount2 = 23000 + (claimAmount - 1000000) * 0.01
            textResultAS += String(format: "23000 руб. + 1 %% от (%.2f руб. - 1000000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", claimAmount, calculatedAmount2, calculatedAmount2)
            
        } else {
            calculatedAmount2 = min(33000 + (claimAmount - 2000000) * 0.005, 200000)
            textResultAS += String(format: "33000 руб. + 0.5 %% от (%.2f руб. - 2000000 руб.) = " + String(33000 + (claimAmount - 2000000) * 0.005) + " руб. Берётся %.2f руб.", claimAmount, calculatedAmount2, calculatedAmount2)
        }
        calculatedAmount = round(calculatedAmount)
        calculatedAmount2 = round(calculatedAmount2)
        return (calculatedAmount, calculatedAmount2, textResultSOU, textResultAS)
    }
    
    // Новая функция расчета с 09.09.2024 года (старая функция)
    public func calculateCourtFee2024(_ claimAmount: String, courtTypeFee: String, instanceFee: String) -> (Double, Double, String, String) {
        guard let claimAmount = Double(claimAmount) else { return (0, 0, "", "") }
        
        // суд общей юрисдикции
        if claimAmount <= 100000 {
            calculatedAmount = 4000
            textResultSOU = "Берётся 4000 руб."
        } else if claimAmount <= 500000 {
            calculatedAmount = 4000 + (claimAmount - 100000) * 0.04
            textResultSOU = String(format: "4000 руб. + 4 %% от (%.2f руб. - 100000 руб.) = %.2f руб.", claimAmount, calculatedAmount)
        } else if claimAmount <= 1000000 {
            calculatedAmount = 20000 + (claimAmount - 500000) * 0.02
            textResultSOU = String(format: "20000 руб. + 2 %% от (%.2f руб. - 500000 руб.) = %.2f руб.", claimAmount, calculatedAmount)
        } else if claimAmount <= 10000000 {
            calculatedAmount = 30000 + (claimAmount - 1000000) * 0.01
            textResultSOU = String(format: "30000 руб. + 1 %% от (%.2f руб. - 1000000 руб.) = %.2f руб.", claimAmount, calculatedAmount)
        } else if claimAmount <= 50000000 {
            calculatedAmount = 120000 + (claimAmount - 10000000) * 0.005
            textResultSOU = String(format: "120000 руб. + 0.5 %% от (%.2f руб. - 10000000 руб.) = %.2f руб.", claimAmount, calculatedAmount)
        } else {
            calculatedAmount = 320000 + (claimAmount - 50000000) * 0.002
            textResultSOU = String(format: "320000 руб. + 0.2 %% от (%.2f руб. - 50000000 руб.) = %.2f руб.", claimAmount, calculatedAmount)
        }
        
        // арбитраж
        if claimAmount <= 100000 {
            calculatedAmount2 = 10000
            textResultAS = "Берётся 10000 руб."
        } else if claimAmount <= 1000000 {
            calculatedAmount2 = 10000 + (claimAmount - 100000) * 0.05
            textResultAS = String(format: "10000 руб. + 5 %% от (%.2f руб. - 100000 руб.) = %.2f руб.", claimAmount, calculatedAmount2)
        } else if claimAmount <= 10000000 {
            calculatedAmount2 = 55000 + (claimAmount - 1000000) * 0.03
            textResultAS = String(format: "55000 руб. + 3 %% от (%.2f руб. - 1000000 руб.) = %.2f руб.", claimAmount, calculatedAmount2)
        } else if claimAmount <= 50000000 {
            calculatedAmount2 = 325000 + (claimAmount - 10000000) * 0.01
            textResultAS = String(format: "325000 руб. + 1 %% от (%.2f руб. - 10000000 руб.) = %.2f руб.", claimAmount, calculatedAmount2)
        } else {
            calculatedAmount2 = 725000 + (claimAmount - 50000000) * 0.005
            textResultAS = String(format: "725000 руб. + 0.5 %% от (%.2f руб. - 50000000 руб.) = %.2f руб.", claimAmount, calculatedAmount2)
        }
        
        calculatedAmount = round(calculatedAmount)
        calculatedAmount2 = round(calculatedAmount2)
        
        return (calculatedAmount, calculatedAmount2, textResultSOU, textResultAS)
    }
    
    // Функция расчета госпошлины до 2005 года (старая функция)
       public func calculateCourtFeeBefore2005(_ claimAmount: String, courtTypeFee: String) -> (Double, Double, String, String) {
           guard let claimAmount = Double(claimAmount) else { return (0, 0, "", "") }
           
           // Суд общей юрисдикции
           if claimAmount <= 1000000 / 1000 {
               calculatedAmount = claimAmount * 0.005
               textResultSOU = String(format: "5 %% от %.2f руб. = %.2f руб.", claimAmount, calculatedAmount)
           } else if claimAmount <= 10000000 / 1000 {
               calculatedAmount = 50000 / 1000 + (claimAmount - 1000000 / 1000) * 0.04
               textResultSOU = String(format: "50 тыс. руб. + 4 %% от (%.2f руб. - 1 млн. руб.) = %.2f руб.", claimAmount, calculatedAmount)
           } else if claimAmount <= 50000000 / 1000 {
               calculatedAmount = 410000 / 1000 + (claimAmount - 10000000 / 1000) * 0.03
               textResultSOU = String(format: "410 тыс. руб. + 3 %% от (%.2f руб. - 10 млн. руб.) = %.2f руб.", claimAmount, calculatedAmount)
           } else if claimAmount <= 100000000 / 1000 {
               calculatedAmount = 1610000 / 1000 + (claimAmount - 50000000 / 1000) * 0.02
               textResultSOU = String(format: "1 млн. 610 тыс. руб. + 2 %% от (%.2f руб. - 50 млн. руб.) = %.2f руб.", claimAmount, calculatedAmount)
           } else if claimAmount <= 500000000 / 1000 {
               calculatedAmount = 2610000 / 1000 + (claimAmount - 100000000 / 1000) * 0.01
               textResultSOU = String(format: "2 млн. 610 тыс. руб. + 1 %% от (%.2f руб. - 100 млн. руб.) = %.2f руб.", claimAmount, calculatedAmount)
           } else {
               calculatedAmount = claimAmount * 0.015
               textResultSOU = String(format: "1.5 %% от %.2f руб. = %.2f руб.", claimAmount, calculatedAmount)
           }
           
           // Арбитраж
           if claimAmount <= 10000000 / 1000 {
               calculatedAmount2 = max(claimAmount * 0.05, 1)
               textResultAS = String(format: "5 %% от %.2f руб., но не менее 1 руб. = %.2f руб.", claimAmount, calculatedAmount2)
           } else if claimAmount <= 50000000 / 1000 {
               calculatedAmount2 = 500000 / 1000 + (claimAmount - 10000000 / 1000) * 0.04
               textResultAS = String(format: "500 тыс. руб. + 4 %% от (%.2f руб. - 10 млн. руб.) = %.2f руб.", claimAmount, calculatedAmount2)
           } else if claimAmount <= 100000000 / 1000 {
               calculatedAmount2 = 2100000 / 1000 + (claimAmount - 50000000 / 1000) * 0.03
               textResultAS = String(format: "2 млн. 100 тыс. руб. + 3 %% от (%.2f руб. - 50 млн. руб.) = %.2f руб.", claimAmount, calculatedAmount2)
           } else if claimAmount <= 500000000 / 1000 {
               calculatedAmount2 = 3600000 / 1000 + (claimAmount - 100000000 / 1000) * 0.02
               textResultAS = String(format: "3 млн. 600 тыс. руб. + 2 %% от (%.2f руб. - 100 млн. руб.) = %.2f руб.", claimAmount, calculatedAmount2)
           } else if claimAmount <= 1000000000 / 1000 {
               calculatedAmount2 = 11600000 / 1000 + (claimAmount - 500000000 / 1000) * 0.01
               textResultAS = String(format: "11 млн. 600 тыс. руб. + 1 %% от (%.2f руб. - 500 млн. руб.) = %.2f руб.", claimAmount, calculatedAmount2)
           } else {
               calculatedAmount2 = 16600000 / 1000 + (claimAmount - 1000000000 / 1000) * 0.005
               textResultAS = String(format: "16 млн. 600 тыс. руб. + 0.5 %% от (%.2f руб. - 1 млрд. руб.) = %.2f руб.", claimAmount, calculatedAmount2)
           }
           
           calculatedAmount = round(calculatedAmount)
           calculatedAmount2 = round(calculatedAmount2)
           
           return (calculatedAmount, calculatedAmount2, textResultSOU, textResultAS)
       }
}
