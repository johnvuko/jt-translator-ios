# JTTranslator

![Version](https://img.shields.io/cocoapods/v/JTTranslator.svg)
![License](https://img.shields.io/cocoapods/l/JTTranslator.svg)
![Platform](https://img.shields.io/cocoapods/p/JTTranslator.svg)

JTTranslator is an easy to way to manage your translations on iOS without building a new version of your app, which allow you to update your translations after having release on the AppStore.

It's work with [Translator](https://translator.eivo.fr), a platform for manage your translations on iOS and Android.

## Installation

With [CocoaPods](http://cocoapods.org), add this line to your Podfile.

    pod 'JTTranslator', '~> 1.0'


## Usage

You have to initialize `JTTranslator` with your API KEY to download your translations.
The `start` method will automatically load the last downloaded versions of your translations and try to update them.

In your AppDelegate, just add:

```swift
import JTTranslator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
	    JTTranslator.start("YOUR_API_KEY")
	}
	
}
```


The easiest way is to replace every call to `NSLocalizedString` by a global method which I call `tr`. This method try to get the translations from `JTTranslator` and the translation if is not found, it will fallback on `NSLocalizedString`.

If you want to do like me, you have to create this global method:

```swift
func tr (key: String) -> String {
    return JTTranslator.tr(key) ?? NSLocalizedString(key, comment: "")
}
```

For example, in this case if you want to manage the translations for a `UILabel`, you will have to do something like:

```swift
let label = UILabel()
label.text = tr("the_translation_key_you_choose")
```

You can also force to update the translations by calling `JTTranslator.update()`.

## Author

- [Jonathan Tribouharet](https://github.com/jonathantribouharet) ([@johntribouharet](https://twitter.com/johntribouharet))

## License

JTTranslator is released under the MIT license. See the LICENSE file for more info.
