# Gosposhlina 

Библиотека на swiftui для расчета госпошлины при обращении в суд по имущественным требованиям.

## Features

Расчет государственной пошлины при обращении в суд по имущественным требованиям.

Доступные алгоритрмы по периодам действия:
 - Россия: действующий алгоритм c 09.09.2024 года
 - Россия: действующий с 01.01.2005 по 08.09.2024 года
 - Россия: действующий с 31.12.1995 по 31.12.2004 года (в планах)
 - Россия: действующий с 09.12.1991 по 31.12.1995 года (в планах)
 - Казахстан (в планах)
 - Болгария (в планах)
 - Белоруссия (в планах)
 и другие страны.
   

**Тип суда (СОЮ, АС)** 

Сейчас доступны расчеты для СОЮ и АС.

В планах: Конституционный суд РФ, третейские суды и т.д. 

**Инстанции**

1, 2, 3, 4 

Судебный приказ (true/false)

Защита прав потребителей (true/false)
       
Тип плательщика - ФЛ, ЮЛ

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
   
