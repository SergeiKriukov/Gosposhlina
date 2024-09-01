# Gosposhlina 

Библиотека на swiftui для расчета госпошлины при обращении в суд по имущественным требованиям.

## Features

Расчет государственной пошлины при обращении в суд по имущественным требованиям.

Доступные алгоритрмы по периодам действия:
 - Россия: действующий алгоритм c 09.09.2024 года
 - Россия: действующий с 01.01.2005 по 08.09.2024 года
 - Россия: действующий с 31.12.1995 по 31.12.2004 года
 - Россия: действующий с 09.12.1991 по 31.12.1995 года (в планах)
 - Казахстан (в планах)
 - Болгария (в планах)
 - Белоруссия (в планах)
 и другие страны.
   
***
Тип суда (СОЮ, АС). Потом еще добавим KS, TS01, TS02 и т.д. 
Инстанция: 1, 2, 3, 4 
Судебный приказ (true/false)
***
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

## Usage

```swift
import Gosposhlina

```

## Installation

### Swift Package Manager

The [Swift Package Manager][] is a tool for managing the distribution of
Swift code.


1. Add the following to your `Package.swift` file:

  ```swift
  dependencies: [
      .package(url: "https://github.com/SergeiKriukov/Gosposhlina.git", from: "0.15.3")
  ]
  ```

2. Build your project:

  ```sh
  $ swift build
  ```

### Manual

To install Gosposhlina.swift as an Xcode sub-project.

## Communication


## Original author


## License

Gosposhlina.swift is available under the MIT license. See [the LICENSE
file](./LICENSE.txt) for more information.

## Alternatives

Ищите альтернативы? Мы пока таких не знаем.

## Пример использования

Приложение ЮристГоспошлина
https://apps.apple.com/ru/app/юристгоспошлина/id6451142832
   
