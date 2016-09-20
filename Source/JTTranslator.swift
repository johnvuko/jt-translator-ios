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
    private static var currentLocale = NSLocale.current.identifier
    
    // en, app launch with this
    private static var currentUsableLocale : String {
        return Bundle.main.preferredLocalizations.first ?? "en"
    }
    
    public static func start(apiKey: String) {
        self.apiKey = apiKey
        
        loadTranslationsFromFile()
        update()
    }
    
    public static func update () {
        print("[JTTranslator] Updating")
        
        // Params q avoid NSURLCache
        guard let url = NSURL(string: self.TranslationUrl + "?q=\(NSDate().timeIntervalSince1970)") else {
            print("[JTTranslator] invalid API TranslationUrl")
            return
        }
        
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Token token=" + apiKey, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if let error = error {
                print("[JTTranslator] Failed to get new translations: \(error.localizedDescription)")
            }
            else if let data = data {
                do {
                    let object = try JSONSerialization.jsonObject(with: data, options: [])
                    if let translations = object as? [String : AnyObject] {
                        if  translations["status"] as? String == "ok" {
                            self.translations = translations
                            self.saveTranslationsToFile(result: data as NSData)
                            
                            print("[JTTranslator] Updated")
                        }
                        else {
                            print("[JTTranslator] API error \((translations["display_message"] as? String) ?? "")")
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
    
    public static func tr (key: String) -> String? {
        if let localeTranslations = self.translations["translations"]?[self.currentUsableLocale] as? [String: AnyObject] {
            if let text = localeTranslations[key] as? String {
                return text
            }
        }
        
        return nil
    }
    
    private static var path: String? {
        get {
            if let dir : NSString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first as NSString? {
                return dir.appendingPathComponent("translations.json")
            }
            return nil
        }
    }
    
    private static func loadTranslationsFromFile () {
        if let path = self.path {
            if let data = NSData(contentsOfFile: path) {
                do {
                    let object = try JSONSerialization.jsonObject(with: data as Data, options: [])
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
                try result.write(toFile: path, options: NSData.WritingOptions(rawValue: 0))
            }
            catch {
                print("[JTTranslator] Failed to save translations")
            }
        }
    }
    
}
