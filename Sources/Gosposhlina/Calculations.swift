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

    // Формирование чисел - округление до двух знаков, и всегда вверх
public let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
        // formatter.roundingMode = .up
    return formatter
}()

// Функция для форматирования числа
func formatNumber(_ number: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal             // Стиль форматирования
    formatter.locale = Locale(identifier: "ru_RU") // Локаль для замены точки на запятую
    formatter.maximumFractionDigits = 2          // Максимум два знака после запятой
    formatter.minimumFractionDigits = 2          // Минимум два знака после запятой
    formatter.groupingSeparator = " "            // Разделение разрядов пробелами
    return formatter.string(from: NSNumber(value: number)) ?? "0,00"
}


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
    
    // Обратный расчет госпошлины
    public func courtFeeReverse(_ modeReverse: FeeMode, courtType: CourtType, of amount: Double) -> (Double, String) {
        var result = (0.0, "")
        
        switch modeReverse {
        case .ru09092024:
            switch courtType {
      
                case .commonUrisdiction:
                
                if amount == 0 {
                    textLabel = "0"
                } else if amount == 4000 {
                    textLabel = "Любая сумма до 100 000 рублей. При цене иска до 100 000 рублей госпошлина равна 4 000 рублям, поэтому точно указать какая цена иска, если госпошлина равна 4 000 рублей – нельзя. Это любая сумма до 100 000 рублей."
                } else if amount < 4000 {
                    textLabel = "Госпошлина не может быть меньше 4 000 руб."
                } else if amount >= 900_000 {
                    textLabel = "Любая сумма свыше 490 666 667 руб. При цене иска 490 666 667 рублей госпошлина достигает размера 900 000 рублей и далее уже при любой цене иска госпошлина остается 900 000 рублей. Поэтому точно сказать, какая цена иска при госпошлине, равной 900 000 рублей, нельзя. Это любая сумма свыше 490 666 667 рублей."
                    
                    if amount > 900_000 {
                        textLabel = "Госпошлина не может превышать 900 000 рублей. Возможно, данная госпошлина – это сумма госпошлин по нескольким требованиям (т.к. больше максимальной суммы в 900 000 рублей). Такую ситуацию наш алгоритм не обрабатывает."
                    }
                    
                } else {
                    if amount <= 10000 {
                        // (4 000 руб. + 3% от суммы, превышающей 100 000 руб.)
                        calculatedAmount = (amount - 4000) / 0.03 + 100000
                    } else if amount > 10000 && amount <= 15000 {
                        // (10 000 руб. + 2.5% от суммы, превышающей 300 000 руб.)
                        calculatedAmount = (amount - 10000) / 0.025 + 300000
                    } else if amount > 15000 && amount <= 25000 {
                        // (15 000 руб. + 2% от суммы, превышающей 500 000 руб.)
                        calculatedAmount = (amount - 15000) / 0.02 + 500000
                    } else if amount > 25000 && amount <= 45000 {
                        // (25 000 руб. + 1% от суммы, превышающей 1 000 000 руб.)
                        calculatedAmount = (amount - 25000) / 0.01 + 1000000
                    } else if amount > 45000 && amount <= 80000 {
                        // (45 000 руб. + 0.7% от суммы, превышающей 3 000 000 руб.)
                        calculatedAmount = (amount - 45000) / 0.007 + 3000000
                    } else if amount > 80000 && amount <= 136000 {
                        // (80 000 руб. + 0.35% от суммы, превышающей 8 000 000 руб.)
                        calculatedAmount = (amount - 80000) / 0.0035 + 8000000
                    } else if amount > 136000 && amount <= 214000 {
                        // (136 000 руб. + 0.3% от суммы, превышающей 24 000 000 руб.)
                        calculatedAmount = (amount - 136000) / 0.003 + 24000000
                    } else if amount > 214000 && amount <= 314000 {
                        // (214 000 руб. + 0.2% от суммы, превышающей 50 000 000 руб.)
                        calculatedAmount = (amount - 214000) / 0.002 + 50000000
                    } else if amount > 314000 {
                        // (314 000 руб. + 0.15% от суммы, превышающей 100 000 000 руб., но не более 900 000 руб.)
                        calculatedAmount = (amount - 314000) / 0.0015 + 100000000
                    }
                    textLabel = formatNumber(calculatedAmount)
                }
    
                
            case .arbitrazh:
                if amount == 0 {
                    textLabel = "0"
                } else if amount == 10000 {
                    textLabel = "Любая сумма до 100 000 рублей. При цене иска до 100 000 рублей госпошлина равна 10 000 рублям, поэтому точно указать какая цена иска, если госпошлина равна 10 000 рублей – нельзя. Это любая сумма до 100 000 рублей."
                } else if amount < 10000 {
                    textLabel = "Госпошлина не может быть меньше 10 000 руб."
                } else if amount >= 10_000_000 {
                    textLabel = "Любая сумма свыше 1 905 000 000 руб. При цене иска 1 905 000 000 рублей госпошлина достигает размера 10 000 000 рублей и далее уже при любой цене иска госпошлина остается 10 000 000 рублей. Поэтому точно сказать, какая цена иска при госпошлине, равной 10 000 000 рублей, нельзя. Это любая сумма свыше 1 905 000 000 рублей."
                  

              

                        if amount > 10_000_000 {
                            textLabel = "Госпошлина не может превышать 10 000 000 рублей. Возможно, данная госпошлина – это сумма госпошлин по нескольким требованиям (т.к. больше максимальной суммы в 10 000 000 рублей). Такую ситуацию наш алгоритм не обрабатывает."
                        }
              
                    
                } else {
                    if amount <= 55000 {
                        // (10 000 руб. + 5% от суммы, превышающей 100 000 руб.)
                        calculatedAmount = (amount - 10000) / 0.05 + 100000
                    } else if amount > 55000 && amount <= 325000 {
                        // (55 000 руб. + 3% от суммы, превышающей 1 000 000 руб.)
                        calculatedAmount = (amount - 55000) / 0.03 + 1000000
                    } else if amount > 325000 && amount <= 725000 {
                        // (325 000 руб. + 1% от суммы, превышающей 10 000 000 руб.)
                        calculatedAmount = (amount - 325000) / 0.01 + 10000000
                    } else if amount > 725000 {
                        // (725 000 руб. + 0.5% от суммы, превышающей 50 000 000 руб.)
                        calculatedAmount = (amount - 725000) / 0.005 + 50000000

                    }
                    textLabel = formatNumber(calculatedAmount)
                }

            }
            
        case .ru01012005_08092024:
            switch courtType {
            case .commonUrisdiction:
                
                // Суд общей юрисдикции
                if amount == 0 {
                    textLabel = "0"
                } else if amount == 400 {
                    
                    textLabel = "Любая сумма до 10 000 рублей. При цене иска до 10000 рублей госпошлина равна 400 рублям, поэтому точно указать какая цена иска, если госпошлина равно 400 рублей – нельзя. Это любая сумма до 10000 рублей."
                    
                } else if amount < 400 {
                    textLabel = "Госпошлина не может быть меньше 400 руб."
                
                } else if amount >= 60000 {
                    textLabel = "Любая сумма свыше 10 360 000 руб. При цене иска 10 360 000 рублей госпошлина достигает размера 60000 рублей и далее уже при любой цене иска госпошлина остается 60 000 рублей. Поэтому точно сказать, какая цена иска при госпошлине, равной 60 000 рублей, нельзя. Это любая сумма свыше 10 360 000 рублей."
              
                    
                    if amount > 60000 {
                        textLabel = "Введенная госпошлина больше, чем 60000 рублей, поэтому, возможно, данная госпошлина – это сумма госпошлин по нескольким требованиям (т.к. больше максимальной суммы в 60000 рублей). Такую ситуацию наш алгоритм не обрабатывает."
                    }
                    
                } else {
                  
                            if amount >= 400 && amount <= 800 {
                                calculatedAmount = (amount - 400) / 0.04
                            } else if amount > 800 && amount <= 3200 {
                                calculatedAmount = (amount - 800) / 0.03 + 20000
                            } else if amount > 3200 && amount <= 5200 {
                                calculatedAmount = (amount - 3200) / 0.02 + 100000
                            } else if amount > 5200 && amount <= 13200 {
                                calculatedAmount = (amount - 5200) / 0.01 + 200000
                            } else if amount > 13200 && amount <= 60000 {
                                calculatedAmount = (amount - 13200) / 0.005 + 1000000
                            }

                        //    textLabel = ("\(calculatedAmount)")
                    textLabel = formatNumber(calculatedAmount)
                }
                
                
            case .arbitrazh:
                
                // Арбитражный суд
                if amount == 0 {
                    textLabel = "0"
        
                } else if amount == 2000 {
                    textLabel = "Любая сумма до 50 000 рублей. При цене иска до 50 000 рублей госпошлина равна 2 000 рублям, поэтому точно указать какая цена иска, если госпошлина равно 2 000 рублей – нельзя. Это любая сумма до 50 000 рублей."
               
                } else if amount < 2000 {
                    textLabel = "Госпошлина не может быть меньше 2000 руб."
                    
                } else if amount >= 200000 {
                    textLabel = "Любая сумма свыше 35 400 000 руб. При цене иска 35 400 000 рублей госпошлина достигает размера 200 000 рублей и далее уже при любой цене иска госпошлина остается 200 000 рублей. Поэтому точно сказать, какая цена иска при госпошлине, равной 200 000 рублей, нельзя. Это любая сумма свыше 35 400 000 рублей."
                      
                    if amount > 200000 {
                        textLabel = "Введенная госпошлина больше, чем 200000 рублей, поэтому, возможно, данная госпошлина – это сумма госпошлин по нескольким требованиям (т.к. больше максимальной суммы в 200000 рублей). Такую ситуацию наш алгоритм не обрабатывает."
                    }
                    
                } else {
                   
                    
                    //   Цена иска = (9862,5 - 7000) / 0.02 + 200000 = 343125
                    
                    if amount >= 2000 && amount <= 4000 {
                        calculatedAmount = (amount - 400) / 0.04
                    } else if amount > 4000 && amount <= 7000 {
                        calculatedAmount = (amount - 4000) / 0.03 + 100000
                    } else if amount > 7000 && amount <= 23000 {
                        calculatedAmount = (amount - 7000) / 0.02 + 200000
                    } else if amount > 23000 && amount <= 33000 {
                        calculatedAmount = (amount - 23000) / 0.01 + 1000000
                    } else if amount > 33000 && amount <= 200000 {
                        calculatedAmount = (amount - 33000) / 0.005 + 2000000
                    }
                    
                //    textLabel = ("\(calculatedAmount)")
                    textLabel = formatNumber(calculatedAmount)
                    
                }
           
            }
     
        case .ru31121995_31122004:
            switch courtType {
            case .commonUrisdiction:
                print("arbitrazh")
            case .arbitrazh:
                print("arbitrazh")
           
            }
        case .ru09121991_31121995:
            switch courtType {
            case .commonUrisdiction:
                print("arbitrazh")
            case .arbitrazh:
                print("arbitrazh")
           
            }
        case .kz31121995_01012005:
            switch courtType {
            case .commonUrisdiction:
                print("arbitrazh")
            case .arbitrazh:
                print("arbitrazh")
           
            }
        }

        
        let toPay = round(calculatedAmount)
        let description = textLabel
        return (toPay, description)
    }
    
    /// Common method
    public func courtFeeFor(_ mode: FeeMode, courtType: CourtType, instanceType: InstanceType, isPrikaz: Bool, potrebitel: Bool, lawType: LawType, of amount: Double) -> (Double, String) {
        var result = (0.0, "")
        
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
                        if 314000 + (amount - 100000000) * 0.0015 > 900000 {
                            textLabel = String(format: "314000 руб. + 0.15 %% от (%.2f руб. - 100000000 руб.) = %.2f руб., но не более 900000 руб.", amount, 314000 + (amount - 100000000) * 0.0015)
                        } else {
                            textLabel = String(format: "314000 руб. + 0.15 %% от (%.2f руб. - 100000000 руб.) = %.2f руб.", amount, 314000 + (amount - 100000000) * 0.0015)
                        }
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
                        textLabel = "Фиксированная сумма за кассацию в ВС РФ физического лица"
                    case .urik:
                        calculatedAmount = 25000
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
                        calculatedAmount = max(calculatedAmount/2, 8000)
                        if amount < 750000
                        {
                            textLabel = String("Цена иска менее 750000 рублей, поэтому возможно заявление о вынесении приказа. Но не менее 8000 рублей.")
                         
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
                        calculatedAmount = 20000
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
                        // Для периода с 01.01.2005 по 08.09.2024 года
                        // дополнительное деление на 2 для судебного приказа
                        // не применяется, чтобы минимальная сумма оставалась 2000 руб.
                        if amount <= 750000 {
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
            
            switch courtType {
            case .commonUrisdiction:
                
                // все расчеты для СОЮ
                switch instanceType {
                case .one:
                    // Суд общей юрисдикции
                    if amount <= 1000000 / 1000 {
                        calculatedAmount = amount * 0.005
                        textLabel = String(format: "5 %% от %.2f руб. = %.2f руб.", amount, calculatedAmount)
                    } else if amount <= 10000000 / 1000 {
                        calculatedAmount = 50000 / 1000 + (amount - 1000000 / 1000) * 0.04
                        textLabel = String(format: "50 тыс. руб. + 4 %% от (%.2f руб. - 1 млн. руб.) = %.2f руб.", amount, calculatedAmount)
                    } else if amount <= 50000000 / 1000 {
                        calculatedAmount = 410000 / 1000 + (amount - 10000000 / 1000) * 0.03
                        textLabel = String(format: "410 тыс. руб. + 3 %% от (%.2f руб. - 10 млн. руб.) = %.2f руб.", amount, calculatedAmount)
                    } else if amount <= 100000000 / 1000 {
                        calculatedAmount = 1610000 / 1000 + (amount - 50000000 / 1000) * 0.02
                        textLabel = String(format: "1 млн. 610 тыс. руб. + 2 %% от (%.2f руб. - 50 млн. руб.) = %.2f руб.", amount, calculatedAmount)
                    } else if amount <= 500000000 / 1000 {
                        calculatedAmount = 2610000 / 1000 + (amount - 100000000 / 1000) * 0.01
                        textLabel = String(format: "2 млн. 610 тыс. руб. + 1 %% от (%.2f руб. - 100 млн. руб.) = %.2f руб.", amount, calculatedAmount)
                    } else {
                        calculatedAmount = amount * 0.015
                        textLabel = String(format: "1.5 %% от %.2f руб. = %.2f руб.", amount, calculatedAmount)
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
//                        textLabel = String("В случае, если цена иска превышает 1 000 000 рублей, госпошлина уплачивается в сумме, исчисленной в соответствии с подпунктом 1 пункта 1 статьи 333.19 НК РФ и уменьшенной на сумму государственной пошлины, подлежащей уплате при цене иска 1 000 000 рублей. При цене иска 1 000 000 рублей госпошлина составляет 13 200 рублей.")
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
               
                // все расчеты для АС
                switch instanceType {
                case .one:
                    // Арбитраж
                    if amount <= 10000000 / 1000 {
                        calculatedAmount = max(amount * 0.05, 1)
                        textLabel = String(format: "5 %% от %.2f руб., но не менее 1 руб. = %.2f руб.", amount, calculatedAmount)
                    } else if amount <= 50000000 / 1000 {
                        calculatedAmount = 500000 / 1000 + (amount - 10000000 / 1000) * 0.04
                        textLabel = String(format: "500 тыс. руб. + 4 %% от (%.2f руб. - 10 млн. руб.) = %.2f руб.", amount, calculatedAmount)
                    } else if amount <= 100000000 / 1000 {
                        calculatedAmount = 2100000 / 1000 + (amount - 50000000 / 1000) * 0.03
                        textLabel = String(format: "2 млн. 100 тыс. руб. + 3 %% от (%.2f руб. - 50 млн. руб.) = %.2f руб.", amount, calculatedAmount)
                    } else if amount <= 500000000 / 1000 {
                        calculatedAmount = 3600000 / 1000 + (amount - 100000000 / 1000) * 0.02
                        textLabel = String(format: "3 млн. 600 тыс. руб. + 2 %% от (%.2f руб. - 100 млн. руб.) = %.2f руб.", amount, calculatedAmount)
                    } else if amount <= 1000000000 / 1000 {
                        calculatedAmount = 11600000 / 1000 + (amount - 500000000 / 1000) * 0.01
                        textLabel = String(format: "11 млн. 600 тыс. руб. + 1 %% от (%.2f руб. - 500 млн. руб.) = %.2f руб.", amount, calculatedAmount)
                    } else {
                        calculatedAmount = 16600000 / 1000 + (amount - 1000000000 / 1000) * 0.005
                        textLabel = String(format: "16 млн. 600 тыс. руб. + 0.5 %% от (%.2f руб. - 1 млрд. руб.) = %.2f руб.", amount, calculatedAmount)
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
            

        case .ru09121991_31121995:
            print("calculate mode: \(mode.title)")
            
            
            

        case .kz31121995_01012005:
            print("calculate mode: \(mode.title)")
            
            
            

        }
        
        let toPay = round(calculatedAmount)
        let description = textLabel
        return (toPay, description)
    }
    
//
//    // Метод расчета с 09.09.2024 года (новая функция)
//    public func courtFee2024(_ amount: Double, courtType: CourtType, instanceType: InstanceType, isPrikaz: Bool, isPravaPotrebirel: Bool, isFizik: Bool) -> (Double, String) {
//        
//
//            
//            if courtType == .commonUrisdiction {
//                // все расчеты для СОЮ
//                if instanceType == .one {
//                    // расчеты госпошлины по первой инстанции
//                    // Суд общей юрисдикции, первая инстанция
//               if amount <= 100000 {
//                   calculatedAmount = 4000
//                   textResultSOU = "Берётся 4000 руб."
//               } else if amount <= 300000 {
//                   calculatedAmount = 4000 + (amount - 100000) * 0.03
//                   textResultSOU = String(format: "4000 руб. + 3 %% от (%.2f руб. - 100000 руб.) = %.2f руб.", amount, calculatedAmount)
//               } else if amount <= 500000 {
//                   calculatedAmount = 10000 + (amount - 300000) * 0.025
//                   textResultSOU = String(format: "10000 руб. + 2.5 %% от (%.2f руб. - 300000 руб.) = %.2f руб.", amount, calculatedAmount)
//               } else if amount <= 1000000 {
//                   calculatedAmount = 15000 + (amount - 500000) * 0.02
//                   textResultSOU = String(format: "15000 руб. + 2 %% от (%.2f руб. - 500000 руб.) = %.2f руб.", amount, calculatedAmount)
//               } else if amount <= 3000000 {
//                   calculatedAmount = 25000 + (amount - 1000000) * 0.01
//                   textResultSOU = String(format: "25000 руб. + 1 %% от (%.2f руб. - 1000000 руб.) = %.2f руб.", amount, calculatedAmount)
//               } else if amount <= 8000000 {
//                   calculatedAmount = 45000 + (amount - 3000000) * 0.007
//                   textResultSOU = String(format: "45000 руб. + 0.7 %% от (%.2f руб. - 3000000 руб.) = %.2f руб.", amount, calculatedAmount)
//               } else if amount <= 24000000 {
//                   calculatedAmount = 80000 + (amount - 8000000) * 0.0035
//                   textResultSOU = String(format: "80000 руб. + 0.35 %% от (%.2f руб. - 8000000 руб.) = %.2f руб.", amount, calculatedAmount)
//               } else if amount <= 50000000 {
//                   calculatedAmount = 136000 + (amount - 24000000) * 0.003
//                   textResultSOU = String(format: "136000 руб. + 0.3 %% от (%.2f руб. - 24000000 руб.) = %.2f руб.", amount, calculatedAmount)
//               } else if amount <= 100000000 {
//                   calculatedAmount = 214000 + (amount - 50000000) * 0.002
//                   textResultSOU = String(format: "214000 руб. + 0.2 %% от (%.2f руб. - 50000000 руб.) = %.2f руб.", amount, calculatedAmount)
//               } else {
//                   // Для суммы свыше 100 000 000 рублей
//                   calculatedAmount = min(314000 + (amount - 100000000) * 0.0015, 900000)
//                   textResultSOU = String(format: "314000 руб. + 0.15 %% от (%.2f руб. - 100000000 руб.) = %.2f руб., но не более 900000 руб.", amount, calculatedAmount)
//               }
//
//                    
//                } else if instanceType == .two {
//                 //   апелляция
//                    if isFizik {
//                        calculatedAmount = 3000
//                        textLabel = "Фиксированная сумма за аппеляцию физического лица"
//                    } else {
//                        calculatedAmount = 15000
//                        textLabel = "Фиксированная сумма за аппеляцию юридического лица"
//                    }
//
//                    
//                } else if instanceType == .three {
//                    //   кассация
//                       if isFizik {
//                           calculatedAmount = 5000
//                           textLabel = "Фиксированная сумма за кассацию физического лица"
//                       } else {
//                           calculatedAmount = 20000
//                           textLabel = "Фиксированная сумма за кассацию юридического лица"
//                       }
//                } else if instanceType == .four {
//                    //   кассация ВС РФ
//                       if isFizik {
//                           calculatedAmount = 7000
//                           textLabel = "Фиксированная сумма за кассацию физического лица"
//                       } else {
//                           calculatedAmount = 25000
//                           textLabel = "Фиксированная сумма за кассацию юридического лица"
//                       }
//                }
//                
//            } else if courtType == .arbitrazh {
//                // все расчеты для АС
//                if instanceType == .one {
//                    // расчеты госпошлины по первой инстанции в АС
//
//                    if amount <= 100000 {
//                        calculatedAmount2 = 10000
//                        textResultAS = "Берётся 10000 руб."
//                    } else if amount <= 1000000 {
//                        calculatedAmount2 = 10000 + (amount - 100000) * 0.05
//                        textResultAS = String(format: "10000 руб. + 5 %% от (%.2f руб. - 100000 руб.) = %.2f руб.", amount, calculatedAmount2)
//                    } else if amount <= 10000000 {
//                        calculatedAmount2 = 55000 + (amount - 1000000) * 0.03
//                        textResultAS = String(format: "5000 руб. + 3 %% от (%.2f руб. - 1000000 руб.) = %.2f руб.", amount, calculatedAmount2)
//                    } else if amount <= 50000000 {
//                        calculatedAmount2 = 325000 + (amount - 10000000) * 0.01
//                        textResultAS = String(format: "325000 руб. + 1 %% от (%.2f руб. - 10000000 руб.) = %.2f руб.", amount, calculatedAmount2)
//                    } else {
//                        // Ограничение на максимальную сумму
//                        calculatedAmount2 = min(725000 + (amount - 50000000) * 0.005, 10000000)
//                        textResultAS = String(format: "725000 руб. + 0.5 %% от (%.2f руб. - 50000000 руб.) = %.2f руб., но не более 10000000 руб.", amount, calculatedAmount2)
//                    }
//
//                    
//                } else if instanceType == .two {
//                    //   апелляция
//                       if isFizik {
//                           calculatedAmount = 10000
//                           textLabel = "Фиксированная сумма за аппеляцию физического лица"
//                       } else {
//                           calculatedAmount = 30000
//                           textLabel = "Фиксированная сумма за аппеляцию юридического лица"
//                       }
//
//                       
//                   } else if instanceType == .three {
//                       //   кассация  в АС
//                          if isFizik {
//                              calculatedAmount = 20000
//                              textLabel = "Фиксированная сумма за кассацию физического лица"
//                          } else {
//                              calculatedAmount = 50000
//                              textLabel = "Фиксированная сумма за кассацию юридического лица"
//                          }
//                   } else if instanceType == .four {
//                       //   кассация ВС РФ в АС
//                          if isFizik {
//                              calculatedAmount = 30000
//                              textLabel = "Фиксированная сумма за кассацию физического лица"
//                          } else {
//                              calculatedAmount = 80000
//                              textLabel = "Фиксированная сумма за кассацию юридического лица"
//                          }
//                   }
//                
//                    
//                   
//                
//            }
//        
//      
//        
//    
//        
//        // Тип суда (СОЮ, АС). Потом еще добавим KS, TS01, TS02 и т.д.
//        // Инстанция: 1, 2, 3, 4
//        // Судебный приказ (true/false)
//        // Защита прав потребителей (true/false)
//        // Тип плательщика - ФЛ, ЮЛ
//        
//        
//        // AS.1.PR0.ZPP0.UL
//        // AS.1.PR0.ZPP-.-L основной расчет, первая инстанция АС, приказ - нет, ЗПП - не бывает в АС, лицо без разницы какое
//           
//        // Варианты:
//        // СОЮ, 1, false, false, (ФЛ/ЮЛ)
//        
//        // SOU.1.PR0.ZPP0.-L основной расчет, первая инстанция СОЮ, приказ - нет, ЗПП - нет, лицо без разницы какое, поэтому "-" (так?)
//        // SOU.1.PR1(max500000).ZPP0.-L  - основной расчет, первая инстация, выбран судебный приказ (при этом 500000 - это указание на максимальную цену иска, на которую может быть подан приказ (по ГПК РФ)),
// 
//        
//        // СОЮ, 1, true, (false), (ФЛ/ЮЛ) СУДЕБНЫЙ ПРИКАЗ = 50% от 1 инстанции
//        // АС, 1, true, (false), (ФЛ/ЮЛ) СУДЕБНЫЙ ПРИКАЗ = 50% от 1 инстанции, но не менее 8000 руб.
//        
//        // AS.1.PR1(max750000).ZPP-.-L(=min8000)   750000 - это указание на максимальную цену иска, на которую может быть подан приказ (АПК) - вариант 1, при этом минимальная сумма - 8000 рублей
//        // AS.1.PR1(max100000).ZPP-.-L(=min8000)   100000 - это указание на максимальную цену иска, на которую может быть подан приказ (АПК) - вариант 2, при этом минимальная сумма - 8000 рублей
//    
//        
//        // СОЮ, 1, (false - приказ не может быть если есть ЗПП), true, ФЛ (юрлицо не может быть) ЗАЩИТА ПРАВ ПОТРЕБИТЕЛЕЙ
//        // SOU.1.PR0.ZPP1.FL
//        
//        
//        // СОЮ, 2, (true), (false), ФЛ - 3000
//        // СОЮ, 2, (true), (false), ЮЛ - 15000
//        
//        // SOU.2.PR0.ZPP0.FL = 3000
//        // SOU.2.PR0.ZPP0.UL = 15000
//        
//        // СОЮ, 3, (true), (false), ФЛ - 5000
//        // СОЮ, 3, (true), (false), ЮЛ - 20000
//        
//        // SOU.3.PR0.ZPP0.FL = 5000
//        // SOU.3.PR0.ZPP0.UL = 20000
//        
//        // СОЮ, 4, (true), (false), ФЛ - 7000
//        // СОЮ, 4, (true), (false), ЮЛ - 25000
//        
//        // SOU.4.PR0.ZPP0.FL = 7000
//        // SOU.4.PR0.ZPP0.UL = 25000
//        
//        // АС, 2, (true), (false), ФЛ - 10000
//        // АС, 2, (true), (false), ЮЛ - 30000
//        
//        // AS.2.PR0.ZPP0.FL = 10000
//        // AS.2.PR0.ZPP0.UL = 30000
//        
//        
//        // АС, 3, (true), (false), ФЛ - 20000
//        // АС, 3, (true), (false), ЮЛ - 50000
//        
//        // AS.3.PR0.ZPP0.FL = 20000
//        // AS.3.PR0.ZPP0.UL = 50000
//        
//        // АС, 4, (true), (false), ФЛ - 30000
//        // АС, 4, (true), (false), ЮЛ - 80000
//        
//        // AS.4.PR0.ZPP0.FL = 30000
//        // AS.4.PR0.ZPP0.UL = 80000
//        
//        // В зависимости от типа суда
//        // возвращаем результат - сумму и описание
//        switch courtType {
//        case .commonUrisdiction:
//            calculatedAmount = round(calculatedAmount)
//            textLabel = textResultSOU
//            
//        case .arbitrazh:
//            calculatedAmount = round(calculatedAmount2)
//            textLabel = textResultAS
//        }
//        
//        // SOU.2.PR0.ZPP0.FL = 3000
//        // SOU.2.PR0.ZPP0.UL = 15000
//        
//        return (calculatedAmount, textLabel)
//    }
//    
//    // Метод расчета с 01.01.2005 до 08.09.2024 года (новая функция)
//    public func courtFee(_ amount: Double, courtType: CourtType, instanceType: InstanceType, isPrikaz: Bool, isPravaPotrebirel: Bool, isFizik: Bool) -> (Double, String) {
//        // суд общей юрисдикции
//        if amount <= 20000 {
//            calculatedAmount = max(400, amount * 0.04)
//            textResultSOU = String(format: "4 %% от %.2f руб. = ", amount, calculatedAmount) + String(amount * 4 / 100) + " руб."
//            if calculatedAmount == 400 {
//                textResultSOU += " Берётся 400 руб."
//            }
//        } else if amount <= 100000 {
//            calculatedAmount = 800 + (amount - 20000) * 0.03
//            textResultSOU = String(format: "800 руб. + 3 %% от (%.2f руб. - 20000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", amount, calculatedAmount, calculatedAmount)
//        } else if amount <= 200000 {
//            calculatedAmount = 3200 + (amount - 100000) * 0.02
//            textResultSOU = String(format: "3200 руб. + 2 %% от (%.2f руб. - 100000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", amount, calculatedAmount, calculatedAmount)
//        } else if amount <= 1000000 {
//            calculatedAmount = 5200 + (amount - 200000) * 0.01
//            textResultSOU = String(format: "5200 руб. + 1 %% от (%.2f руб. - 200000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", amount, calculatedAmount, calculatedAmount)
//        } else {
//            calculatedAmount = min(60000, 13200 + (amount - 1000000) * 0.005)
//            textResultSOU = String(format: "13200 руб. + 0.5 %% от (%.2f руб. - 1000000 руб.) = " + String(13200 + (amount - 1000000) * 0.005) + " руб. Берётся %.2f руб.", amount, calculatedAmount, calculatedAmount)
//        }
//        // арбитраж
//        if amount <= 100000 {
//            calculatedAmount2 = max(2000, amount * 0.04)
//            textResultAS = String(format: "4 %% от %.2f руб. = ", amount, calculatedAmount) + String(amount * 4 / 100) + " руб."
//            if calculatedAmount2 == 2000 {
//                textResultAS += " Берётся 2000 руб."
//            }
//        } else if amount <= 200000 {
//            calculatedAmount2 = round(4000 + (amount - 100000) * 0.03)
//            textResultAS += String(format: "4000 руб. + 3 %% от (%.2f руб. - 100000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", amount, calculatedAmount2, calculatedAmount2)
//        } else if amount <= 1000000 {
//            calculatedAmount2 = 7000 + (amount - 200000) * 0.02
//            textResultAS += String(format: "7000 руб. + 2 %% от (%.2f руб. - 200000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", amount, calculatedAmount2, calculatedAmount2)
//            
//        } else if amount <= 2000000 {
//            calculatedAmount2 = 23000 + (amount - 1000000) * 0.01
//            textResultAS += String(format: "23000 руб. + 1 %% от (%.2f руб. - 1000000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", amount, calculatedAmount2, calculatedAmount2)
//            
//        } else {
//            calculatedAmount2 = min(33000 + (amount - 2000000) * 0.005, 200000)
//            textResultAS += String(format: "33000 руб. + 0.5 %% от (%.2f руб. - 2000000 руб.) = " + String(33000 + (amount - 2000000) * 0.005) + " руб. Берётся %.2f руб.", amount, calculatedAmount2, calculatedAmount2)
//        }
//        
//        // В зависимости от типа суда
//        // возвращаем результат - сумму и описание
//        switch courtType {
//        case .commonUrisdiction:
//            calculatedAmount = round(calculatedAmount)
//            textLabel = textResultSOU
//            
//        case .arbitrazh:
//            calculatedAmount = round(calculatedAmount2)
//            textLabel = textResultAS
//        }
//        
//        return (calculatedAmount, textLabel)
//    }
//
//    // Метод расчета госпошлины с 31.12.1995 по 31.12.2004 года (новая функция)
//    public func courtFeeBefore2005(_ amount: Double, courtType: CourtType) -> (Double, String) {
//        
//        // Суд общей юрисдикции
//        if amount <= 1000000 / 1000 {
//            calculatedAmount = amount * 0.005
//            textResultSOU = String(format: "5 %% от %.2f руб. = %.2f руб.", amount, calculatedAmount)
//        } else if amount <= 10000000 / 1000 {
//            calculatedAmount = 50000 / 1000 + (amount - 1000000 / 1000) * 0.04
//            textResultSOU = String(format: "50 тыс. руб. + 4 %% от (%.2f руб. - 1 млн. руб.) = %.2f руб.", amount, calculatedAmount)
//        } else if amount <= 50000000 / 1000 {
//            calculatedAmount = 410000 / 1000 + (amount - 10000000 / 1000) * 0.03
//            textResultSOU = String(format: "410 тыс. руб. + 3 %% от (%.2f руб. - 10 млн. руб.) = %.2f руб.", amount, calculatedAmount)
//        } else if amount <= 100000000 / 1000 {
//            calculatedAmount = 1610000 / 1000 + (amount - 50000000 / 1000) * 0.02
//            textResultSOU = String(format: "1 млн. 610 тыс. руб. + 2 %% от (%.2f руб. - 50 млн. руб.) = %.2f руб.", amount, calculatedAmount)
//        } else if amount <= 500000000 / 1000 {
//            calculatedAmount = 2610000 / 1000 + (amount - 100000000 / 1000) * 0.01
//            textResultSOU = String(format: "2 млн. 610 тыс. руб. + 1 %% от (%.2f руб. - 100 млн. руб.) = %.2f руб.", amount, calculatedAmount)
//        } else {
//            calculatedAmount = amount * 0.015
//            textResultSOU = String(format: "1.5 %% от %.2f руб. = %.2f руб.", amount, calculatedAmount)
//        }
//        
//        // Арбитраж
//        if amount <= 10000000 / 1000 {
//            calculatedAmount2 = max(amount * 0.05, 1)
//            textResultAS = String(format: "5 %% от %.2f руб., но не менее 1 руб. = %.2f руб.", amount, calculatedAmount2)
//        } else if amount <= 50000000 / 1000 {
//            calculatedAmount2 = 500000 / 1000 + (amount - 10000000 / 1000) * 0.04
//            textResultAS = String(format: "500 тыс. руб. + 4 %% от (%.2f руб. - 10 млн. руб.) = %.2f руб.", amount, calculatedAmount2)
//        } else if amount <= 100000000 / 1000 {
//            calculatedAmount2 = 2100000 / 1000 + (amount - 50000000 / 1000) * 0.03
//            textResultAS = String(format: "2 млн. 100 тыс. руб. + 3 %% от (%.2f руб. - 50 млн. руб.) = %.2f руб.", amount, calculatedAmount2)
//        } else if amount <= 500000000 / 1000 {
//            calculatedAmount2 = 3600000 / 1000 + (amount - 100000000 / 1000) * 0.02
//            textResultAS = String(format: "3 млн. 600 тыс. руб. + 2 %% от (%.2f руб. - 100 млн. руб.) = %.2f руб.", amount, calculatedAmount2)
//        } else if amount <= 1000000000 / 1000 {
//            calculatedAmount2 = 11600000 / 1000 + (amount - 500000000 / 1000) * 0.01
//            textResultAS = String(format: "11 млн. 600 тыс. руб. + 1 %% от (%.2f руб. - 500 млн. руб.) = %.2f руб.", amount, calculatedAmount2)
//        } else {
//            calculatedAmount2 = 16600000 / 1000 + (amount - 1000000000 / 1000) * 0.005
//            textResultAS = String(format: "16 млн. 600 тыс. руб. + 0.5 %% от (%.2f руб. - 1 млрд. руб.) = %.2f руб.", amount, calculatedAmount2)
//        }
//        
//        // В зависимости от типа суда
//        // возвращаем результат - сумму и описание
//        switch courtType {
//        case .commonUrisdiction:
//            calculatedAmount = round(calculatedAmount)
//            textLabel = textResultSOU
//            
//        case .arbitrazh:
//            calculatedAmount = round(calculatedAmount2)
//            textLabel = textResultAS
//        }
//        
//        return (calculatedAmount, textLabel)
//    }
//
//    // Метод расчета госпошлины (старая функция)
//    public func calculateCourtFee(_ claimAmount: String, courtTypeFee: String, instanceFee: String, isPrikaz: Bool, isPravaPotrebirel: Bool, typeIstec: String) -> (Double, Double, String, String) {
//        guard let claimAmount = Double(claimAmount) else { return (0, 0, "", "") }
//        // суд общей юрисдикции
//        if claimAmount <= 20000 {
//            calculatedAmount = max(400, claimAmount * 0.04)
//            textResultSOU = String(format: "4 %% от %.2f руб. = ", claimAmount, calculatedAmount) + String(claimAmount * 4 / 100) + " руб."
//            if calculatedAmount == 400 {
//                textResultSOU += " Берётся 400 руб."
//            }
//        } else if claimAmount <= 100000 {
//            calculatedAmount = 800 + (claimAmount - 20000) * 0.03
//            textResultSOU = String(format: "800 руб. + 3 %% от (%.2f руб. - 20000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", claimAmount, calculatedAmount, calculatedAmount)
//        } else if claimAmount <= 200000 {
//            calculatedAmount = 3200 + (claimAmount - 100000) * 0.02
//            textResultSOU = String(format: "3200 руб. + 2 %% от (%.2f руб. - 100000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", claimAmount, calculatedAmount, calculatedAmount)
//        } else if claimAmount <= 1000000 {
//            calculatedAmount = 5200 + (claimAmount - 200000) * 0.01
//            textResultSOU = String(format: "5200 руб. + 1 %% от (%.2f руб. - 200000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", claimAmount, calculatedAmount, calculatedAmount)
//        } else {
//            calculatedAmount = min(60000, 13200 + (claimAmount - 1000000) * 0.005)
//            textResultSOU = String(format: "13200 руб. + 0.5 %% от (%.2f руб. - 1000000 руб.) = " + String(13200 + (claimAmount - 1000000) * 0.005) + " руб. Берётся %.2f руб.", claimAmount, calculatedAmount, calculatedAmount)
//        }
//        // арбитраж
//        if claimAmount <= 100000 {
//            calculatedAmount2 = max(2000, claimAmount * 0.04)
//            textResultAS = String(format: "4 %% от %.2f руб. = ", claimAmount, calculatedAmount) + String(claimAmount * 4 / 100) + " руб."
//            if calculatedAmount2 == 2000 {
//                textResultAS += " Берётся 2000 руб."
//            }
//        } else if claimAmount <= 200000 {
//            calculatedAmount2 = round(4000 + (claimAmount - 100000) * 0.03)
//            textResultAS += String(format: "4000 руб. + 3 %% от (%.2f руб. - 100000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", claimAmount, calculatedAmount2, calculatedAmount2)
//        } else if claimAmount <= 1000000 {
//            calculatedAmount2 = 7000 + (claimAmount - 200000) * 0.02
//            textResultAS += String(format: "7000 руб. + 2 %% от (%.2f руб. - 200000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", claimAmount, calculatedAmount2, calculatedAmount2)
//            
//        } else if claimAmount <= 2000000 {
//            calculatedAmount2 = 23000 + (claimAmount - 1000000) * 0.01
//            textResultAS += String(format: "23000 руб. + 1 %% от (%.2f руб. - 1000000 руб.) = %.2f руб. Берётся %.2f руб., округляется до целого числа.", claimAmount, calculatedAmount2, calculatedAmount2)
//            
//        } else {
//            calculatedAmount2 = min(33000 + (claimAmount - 2000000) * 0.005, 200000)
//            textResultAS += String(format: "33000 руб. + 0.5 %% от (%.2f руб. - 2000000 руб.) = " + String(33000 + (claimAmount - 2000000) * 0.005) + " руб. Берётся %.2f руб.", claimAmount, calculatedAmount2, calculatedAmount2)
//        }
//        calculatedAmount = round(calculatedAmount)
//        calculatedAmount2 = round(calculatedAmount2)
//        return (calculatedAmount, calculatedAmount2, textResultSOU, textResultAS)
//    }
//    
//    // Новая функция расчета с 09.09.2024 года (старая функция)
//    public func calculateCourtFee2024(_ claimAmount: String, courtTypeFee: String, instanceFee: String) -> (Double, Double, String, String) {
//        guard let claimAmount = Double(claimAmount) else { return (0, 0, "", "") }
//        
//        // суд общей юрисдикции
//        if claimAmount <= 100000 {
//            calculatedAmount = 4000
//            textResultSOU = "Берётся 4000 руб."
//        } else if claimAmount <= 500000 {
//            calculatedAmount = 4000 + (claimAmount - 100000) * 0.04
//            textResultSOU = String(format: "4000 руб. + 4 %% от (%.2f руб. - 100000 руб.) = %.2f руб.", claimAmount, calculatedAmount)
//        } else if claimAmount <= 1000000 {
//            calculatedAmount = 20000 + (claimAmount - 500000) * 0.02
//            textResultSOU = String(format: "20000 руб. + 2 %% от (%.2f руб. - 500000 руб.) = %.2f руб.", claimAmount, calculatedAmount)
//        } else if claimAmount <= 10000000 {
//            calculatedAmount = 30000 + (claimAmount - 1000000) * 0.01
//            textResultSOU = String(format: "30000 руб. + 1 %% от (%.2f руб. - 1000000 руб.) = %.2f руб.", claimAmount, calculatedAmount)
//        } else if claimAmount <= 50000000 {
//            calculatedAmount = 120000 + (claimAmount - 10000000) * 0.005
//            textResultSOU = String(format: "120000 руб. + 0.5 %% от (%.2f руб. - 10000000 руб.) = %.2f руб.", claimAmount, calculatedAmount)
//        } else {
//            calculatedAmount = 320000 + (claimAmount - 50000000) * 0.002
//            textResultSOU = String(format: "320000 руб. + 0.2 %% от (%.2f руб. - 50000000 руб.) = %.2f руб.", claimAmount, calculatedAmount)
//        }
//        
//        // арбитраж
//        if claimAmount <= 100000 {
//            calculatedAmount2 = 10000
//            textResultAS = "Берётся 10000 руб."
//        } else if claimAmount <= 1000000 {
//            calculatedAmount2 = 10000 + (claimAmount - 100000) * 0.05
//            textResultAS = String(format: "10000 руб. + 5 %% от (%.2f руб. - 100000 руб.) = %.2f руб.", claimAmount, calculatedAmount2)
//        } else if claimAmount <= 10000000 {
//            calculatedAmount2 = 55000 + (claimAmount - 1000000) * 0.03
//            textResultAS = String(format: "55000 руб. + 3 %% от (%.2f руб. - 1000000 руб.) = %.2f руб.", claimAmount, calculatedAmount2)
//        } else if claimAmount <= 50000000 {
//            calculatedAmount2 = 325000 + (claimAmount - 10000000) * 0.01
//            textResultAS = String(format: "325000 руб. + 1 %% от (%.2f руб. - 10000000 руб.) = %.2f руб.", claimAmount, calculatedAmount2)
//        } else {
//            calculatedAmount2 = 725000 + (claimAmount - 50000000) * 0.005
//            textResultAS = String(format: "725000 руб. + 0.5 %% от (%.2f руб. - 50000000 руб.) = %.2f руб.", claimAmount, calculatedAmount2)
//        }
//        
//        calculatedAmount = round(calculatedAmount)
//        calculatedAmount2 = round(calculatedAmount2)
//        
//        return (calculatedAmount, calculatedAmount2, textResultSOU, textResultAS)
//    }
//    
//    // Функция расчета госпошлины до 2005 года (старая функция)
//       public func calculateCourtFeeBefore2005(_ claimAmount: String, courtTypeFee: String) -> (Double, Double, String, String) {
//           guard let claimAmount = Double(claimAmount) else { return (0, 0, "", "") }
//           
//           // Суд общей юрисдикции
//           if claimAmount <= 1000000 / 1000 {
//               calculatedAmount = claimAmount * 0.005
//               textResultSOU = String(format: "5 %% от %.2f руб. = %.2f руб.", claimAmount, calculatedAmount)
//           } else if claimAmount <= 10000000 / 1000 {
//               calculatedAmount = 50000 / 1000 + (claimAmount - 1000000 / 1000) * 0.04
//               textResultSOU = String(format: "50 тыс. руб. + 4 %% от (%.2f руб. - 1 млн. руб.) = %.2f руб.", claimAmount, calculatedAmount)
//           } else if claimAmount <= 50000000 / 1000 {
//               calculatedAmount = 410000 / 1000 + (claimAmount - 10000000 / 1000) * 0.03
//               textResultSOU = String(format: "410 тыс. руб. + 3 %% от (%.2f руб. - 10 млн. руб.) = %.2f руб.", claimAmount, calculatedAmount)
//           } else if claimAmount <= 100000000 / 1000 {
//               calculatedAmount = 1610000 / 1000 + (claimAmount - 50000000 / 1000) * 0.02
//               textResultSOU = String(format: "1 млн. 610 тыс. руб. + 2 %% от (%.2f руб. - 50 млн. руб.) = %.2f руб.", claimAmount, calculatedAmount)
//           } else if claimAmount <= 500000000 / 1000 {
//               calculatedAmount = 2610000 / 1000 + (claimAmount - 100000000 / 1000) * 0.01
//               textResultSOU = String(format: "2 млн. 610 тыс. руб. + 1 %% от (%.2f руб. - 100 млн. руб.) = %.2f руб.", claimAmount, calculatedAmount)
//           } else {
//               calculatedAmount = claimAmount * 0.015
//               textResultSOU = String(format: "1.5 %% от %.2f руб. = %.2f руб.", claimAmount, calculatedAmount)
//           }
//           
//           // Арбитраж
//           if claimAmount <= 10000000 / 1000 {
//               calculatedAmount2 = max(claimAmount * 0.05, 1)
//               textResultAS = String(format: "5 %% от %.2f руб., но не менее 1 руб. = %.2f руб.", claimAmount, calculatedAmount2)
//           } else if claimAmount <= 50000000 / 1000 {
//               calculatedAmount2 = 500000 / 1000 + (claimAmount - 10000000 / 1000) * 0.04
//               textResultAS = String(format: "500 тыс. руб. + 4 %% от (%.2f руб. - 10 млн. руб.) = %.2f руб.", claimAmount, calculatedAmount2)
//           } else if claimAmount <= 100000000 / 1000 {
//               calculatedAmount2 = 2100000 / 1000 + (claimAmount - 50000000 / 1000) * 0.03
//               textResultAS = String(format: "2 млн. 100 тыс. руб. + 3 %% от (%.2f руб. - 50 млн. руб.) = %.2f руб.", claimAmount, calculatedAmount2)
//           } else if claimAmount <= 500000000 / 1000 {
//               calculatedAmount2 = 3600000 / 1000 + (claimAmount - 100000000 / 1000) * 0.02
//               textResultAS = String(format: "3 млн. 600 тыс. руб. + 2 %% от (%.2f руб. - 100 млн. руб.) = %.2f руб.", claimAmount, calculatedAmount2)
//           } else if claimAmount <= 1000000000 / 1000 {
//               calculatedAmount2 = 11600000 / 1000 + (claimAmount - 500000000 / 1000) * 0.01
//               textResultAS = String(format: "11 млн. 600 тыс. руб. + 1 %% от (%.2f руб. - 500 млн. руб.) = %.2f руб.", claimAmount, calculatedAmount2)
//           } else {
//               calculatedAmount2 = 16600000 / 1000 + (claimAmount - 1000000000 / 1000) * 0.005
//               textResultAS = String(format: "16 млн. 600 тыс. руб. + 0.5 %% от (%.2f руб. - 1 млрд. руб.) = %.2f руб.", claimAmount, calculatedAmount2)
//           }
//           
//           calculatedAmount = round(calculatedAmount)
//           calculatedAmount2 = round(calculatedAmount2)
//           
//           return (calculatedAmount, calculatedAmount2, textResultSOU, textResultAS)
//       }
}
