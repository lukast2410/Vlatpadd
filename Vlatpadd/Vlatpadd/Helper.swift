//
//  Helper.swift
//  Vlatpadd
//
//  Created by Lukas Tanto on 12/01/22.
//  Copyright © 2022 Lukas Tanto. All rights reserved.
//

import Foundation

class Helper{
    static func haveDigit (str:String)-> Bool{
        for c in str {
            if c >= "0" && c <= "9"{
                return true
            }
        }
        return false
    }
    
    static func haveAlphabet (str:String)-> Bool{
        for c in str {
            if c >= "a" && c <= "z" || c >= "A" && c <= "Z"{
                return true
            }
        }
        return false
    }
    
    static func isNumeric (str:String)-> Bool{
        for c in str {
            if c < "0" || c > "9"{
                return false
            }
        }
        return true
    }
    
    static func validEmail(str: String)-> Bool{
        print("Index: \(str.lastIndex(of: ".").hashValue)")
        if str.firstIndex(of: "@") == nil {
            return false
        }else if str.firstIndex(of: "@") != str.lastIndex(of: "@") {
            print("Index: \(str.firstIndex(of: "@").hashValue)")
            return false
        }else if str.lastIndex(of: ".") == nil {
            return false
        }else if str.hasSuffix(".") || str.hasSuffix("@") {
            return false
        }else if str.contains("@.") {
            return false
        }
        return true
    }
    
    static func formatNumber(number: Int)->String{
        if number < 1000 {
            return "\(number)"
        }
        
        let m = number / 1000000
        let t = number / 1000
        
        if m > 0 {
            if m > 9 {
                return "\(m)M"
            }else {
                let temp = number % 1000000
                let res = temp / 100000
                if res > 0 {
                    return "\(m).\(res)M"
                }else {
                    return "\(m)M"
                }
            }
        }else if t > 0 {
            if t > 9 {
                return "\(t)K"
            }else {
                let temp = number % 1000
                let res = temp / 100
                if res > 0 {
                    return "\(t).\(res)K"
                }else {
                    return "\(t)K"
                }
            }
        }
        
        return "0"
    }
}
