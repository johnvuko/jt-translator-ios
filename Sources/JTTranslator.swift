//
//  JTTranslator.swift
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

import Foundation

public class JTTranslator {
    
    private static let TranslationUrl = "https://translator.eivo.fr/api/v1/translations/ios"
    private static var translations = [String: AnyObject]()
    
    private static var apiKey = ""
    
    // en_US
    private static var currentLocale = NSLocale.currentLocale().localeIdentifier
    
    // en, app launch with this
    private static var currentUsableLocale : String {
        return NSBundle.mainBundle().preferredLocalizations.first ?? "en"
    }
    
    static func start(apiKey: String) {
        self.apiKey = apiKey
        
        loadTranslationsFromFile()
        update()
    }
    
    static func update () {
        print("[JTTranslator] Updating")
        
        // Params q avoid NSURLCache
        guard let url = NSURL(string: self.TranslationUrl + "?q=\(NSDate().timeIntervalSince1970)") else {
            print("[JTTranslator] invalid API TranslationUrl")
            return
        }
        
        let request = NSMutableURLRequest(URL: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Token token=" + apiKey, forHTTPHeaderField: "Authorization")
        
        let session = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            if let error = error {
                print("[JTTranslator] Failed to get new translations: \(error.localizedDescription)")
            }
            else if let data = data {
                do {
                    let object = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                    if let translations = object as? [String : AnyObject] {
                        if  translations["status"] as? String == "ok" {
                            self.translations = translations
                            self.saveTranslationsToFile(data)
                            
                            print("[JTTranslator] Updated")
                        }
                        else {
                            print("[JTTranslator] API error \(translations["display_message"] ?? "")")
                        }
                    }
                    else {
                        print("[JTTranslator] API error")
                    }
                }
                catch {
                    print("[JTTranslator] Failed to parse JSON")
                }
            }
            else {
                print("[JTTranslator] unknown error")
            }
        }
        
        session.resume()
    }
    
    static func tr (key: String) -> String? {
        if let localeTranslations = self.translations["translations"]?[self.currentUsableLocale] as? [String: AnyObject] {
            if let text = localeTranslations[key] as? String {
                return text
            }
        }
        
        return nil
    }
    
    private static var path: String? {
        get {
            if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
                return dir.stringByAppendingPathComponent("translations.json")
            }
            return nil
        }
    }
    
    private static func loadTranslationsFromFile () {
        if let path = self.path {
            if let data = NSData(contentsOfFile: path) {
                do {
                    let object = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                    if let translations = object as? [String : AnyObject] {
                        self.translations = translations
                    }
                    else {
                        print("[JTTranslator] Failed to parse translations")
                    }
                }
                catch {
                    print("[JTTranslator] Failed to parse translations")
                }
            }
        }
    }
    
    private static func saveTranslationsToFile (result: NSData) {
        if let path = self.path {
            do {
                try result.writeToFile(path, options: NSDataWritingOptions(rawValue: 0))
            }
            catch {
                print("[JTTranslator] Failed to save translations")
            }
        }
    }
    
}
