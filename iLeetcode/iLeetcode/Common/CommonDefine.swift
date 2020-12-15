//
//  CommonDefine.swift
//  iTalker
//
//  Created by HTC on 2017/4/9.
//  Copyright © 2017年 ihtc.cc @iHTCboy. All rights reserved.
//

import UIKit


// 常量
let kAppName = "iCoder"
let kAppAppleId = "1458259471"
let kAppDownloadURl = "https://itunes.apple.com/cn/app/iLeetCoder/id1458259471?l=zh&ls=1&mt=8"
let kReviewAction = "&action=write-review"
let kGithubURL = "https://github.com/iHTCboy/iLeetcode-iOS"
let kLicenseURL = "https://raw.githubusercontent.com/iHTCboy/iLeetcode-iOS/master/LICENSE"
let kiHTCboyURL = "https://ihtcboy.com"
let kEmail = "iHTCTeam@gmail.com"
let kAppShare = "Hello, \(kAppName)! 这是一款为IT工程师们提供算法知识充电的应用，IT算法和数据结构知识，求职面试必备的好工具哦！" + "iOS下载链接：" + kAppDownloadURl
let kAppAbout = "About App"
let kShareTitle = "长按识别二维码下载"
let kShareSubTitle = "1000+题库，满足你对算法求知欲望！"



let kStatusBarH: CGFloat = 20 //(UIApplication.shared.statusBarFrame.size.height)
let kNavBarH: CGFloat = (DeviceType.IS_IPHONE_X_S ? 68 : 40)
let kHomeIndcator: CGFloat = (DeviceType.IS_IPHONE_X_S ? 34 : 0) //49 Tab bars
let kLargeTitle: CGFloat = 52.0 //52 Large Title
let kTitleViewH : CGFloat = 40
let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height

let kMarginLine = "—————————————————————"

// Color
let kColorAppBlue = UIColor(red:1.000, green:0.154, blue:0.000, alpha:1.000)
let KColorAppRed = UIColor(red:0.784, green:0.212, blue:0.153, alpha:1.000)
let kColorAppOrange =  UIColor.orange
let kColorAppGreen = UIColor(red:0.302, green:0.751, blue:0.337, alpha:1.000)
let kColorAppGray = UIColor(red:0.512, green:0.572, blue:0.630, alpha:1.000)


// 系统
let KAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String


extension UIViewController {

    /// The app's key window taking into consideration apps that support multiple scenes.
    class func keyWindowHTC() -> UIWindow? {
        var foundWindow: UIWindow? = nil
        for window in UIApplication.shared.windows {
            if (window.isKeyWindow) {
                foundWindow = window
                break
            }
        }
        
        #if !targetEnvironment(macCatalyst)
        if  foundWindow == nil {
            foundWindow = UIApplication.shared.keyWindow
        }
        #endif
        
        if  foundWindow == nil {
            foundWindow = UIApplication.shared.windows.first
        }
        
        #if !targetEnvironment(macCatalyst)
        // 先兼容iPhone设备
        if UIDevice.current.userInterfaceIdiom == .phone {
            foundWindow = UIApplication.shared.keyWindow
        }
        #endif
        
        return foundWindow
    }

}

enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P_7P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X_S         = UIDevice.current.userInterfaceIdiom == .phone && (Version.GREATER_iOS11 ? ((UIViewController.keyWindowHTC()?.value(forKey: "safeAreaInsets") as! UIEdgeInsets).bottom != 0.0) : false)
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}

struct Version{
    static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS7 = (Version.SYS_VERSION_FLOAT < 8.0 && Version.SYS_VERSION_FLOAT >= 7.0)
    static let iOS8 = (Version.SYS_VERSION_FLOAT >= 8.0 && Version.SYS_VERSION_FLOAT < 9.0)
    static let iOS9 = (Version.SYS_VERSION_FLOAT >= 9.0 && Version.SYS_VERSION_FLOAT < 10.0)
    static let iOS10 = (Version.SYS_VERSION_FLOAT >= 10.0 && Version.SYS_VERSION_FLOAT < 11.0)
    static let GREATER_iOS11 = (Version.SYS_VERSION_FLOAT >= 11.0)
}

public extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPod9,1":                                 return "7th Gen iPod"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,1", "iPhone11,2":                return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone11,8", "iPhone11,9":                return "iPhone XR"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12,5":                              return "iPhone 11 Pro Max"
        case "iPhone12,8":                              return "iPhone SE 2nd Gen"
        case "iPhone13,1":                              return "iPhone 12 Mini"
        case "iPhone13,2":                              return "iPhone 12"
        case "iPhone13,3":                              return "iPhone 12 Pro"
        case "iPhone13,4":                              return "iPhone 12 Pro Max"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9"
        case "iPad6,11", "iPad6,12":                    return "iPad (5th Gen)"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 (2nd Gen)"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5"
        case "iPad7,5":                                 return "iPad 6th Gen (WiFi)"
        case "iPad7,6":                                 return "iPad 6th Gen (WiFi+Cellular)"
        case "iPad7,11":                                return "iPad 7th Gen 10.2-inch (WiFi)"
        case "iPad7,12":                                return "iPad 7th Gen 10.2-inch (WiFi+Cellular)"
        case "iPad8,1":                                 return "iPad Pro 3rd Gen (11 inch, WiFi)"
        case "iPad8,2":                                 return "iPad Pro 3rd Gen (11 inch, 1TB, WiFi)"
        case "iPad8,3":                                 return "iPad Pro 3rd Gen (11 inch, WiFi+Cellular)"
        case "iPad8,4":                                 return "iPad Pro 3rd Gen (11 inch, 1TB, WiFi+Cellular)"
        case "iPad8,5":                                 return "iPad Pro 3rd Gen (12.9 inch, WiFi)"
        case "iPad8,6":                                 return "iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi)"
        case "iPad8,7":                                 return "iPad Pro 3rd Gen (12.9 inch, WiFi+Cellular)"
        case "iPad8,8":                                 return "iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi+Cellular)"
        case "iPad8,9":                                 return "iPad Pro 4th Gen (11 inch, WiFi)"
        case "iPad8,10":                                return "iPad Pro 4th Gen (11 inch, WiFi+Cellular)"
        case "iPad8,11":                                return "iPad Pro 4th Gen (12.9 inch, WiFi)"
        case "iPad8,12":                                return "iPad Pro 4th Gen (12.9 inch, WiFi+Cellular)"
        case "iPad11,1":                                return "iPad mini 5th Gen (WiFi)"
        case "iPad11,2":                                return "iPad mini 5th Gen"
        case "iPad11,3":                                return "iPad Air 3rd Gen (WiFi)"
        case "iPad11,4":                                return "iPad Air 3rd Gen"
        case "iPad11,6":                                return "iPad 8th Gen (WiFi)"
        case "iPad11,7":                                return "iPad 8th Gen (WiFi+Cellular)"
        case "iPad13,1":                                return "iPad Air 4th Gen (WiFi)"
        case "iPad13,2":                                return "iPad Air 4th Gen (WiFi+Celular)"
        case "AppleTV2,1":                              return "Apple TV 2G"
        case "AppleTV3,1":                              return "Apple TV 3"
        case "AppleTV3,2":                              return "Apple TV 3 (2013)"
        case "AppleTV5,3":                              return "Apple TV 4"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}
