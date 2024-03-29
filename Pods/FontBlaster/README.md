# FontBlaster

### Programmatically load custom fonts into your iOS app.

---
### About

Say goodbye to importing custom fonts via property lists as **FontBlaster** automatically imports and loads all fonts in your app's NSBundles with one line of code.

### Changelog
#### 2.0.0
- Updated for Swift 2.0
- Added iOS 9 Support
- Removed iOS 7 Support

### Features
- [x] CocoaPods Support
- [x] Automatically imports fonts from `NSBundle.mainbundle()`
- [x] Automatically imports fonts from bundles inside your `mainBundle`
- [x] Able to import fonts from remote bundles
- [x] Sample Project

### Installation Instructions

#### CocoaPods Installation (iOS 8+)
```ruby
pod 'FontBlaster'
```
- Add `import FontBlaster` to any `.Swift` file that references FontBlaster via a CocoaPods installation.

<<<<<<< HEAD
#### Carthage Installation
```ruby
github "ArtSabintsev/FontBlaster"
```

#### Manual Installation
=======
#### Manual Installation (iOS 7+)
>>>>>>> master

1. [Download FontBlaster](//github.com/ArtSabintsev/FontBlaster/archive/master.zip).
2. Copy the `FontBlaster.swift` into your project.

### Setup Instructions

Typically, all fonts are automatically found in `NSBundle.mainBundle()`. Even if you have a custom bundle, it's usually lodged inside of the `mainBundle.` Therefore, to load all the fonts in your application, irrespective of the bundle it's in, simply call:

```Swift
FontBlaster.blast() // Defaults to NSBundle.mainBundle() if no arguments are passed
```

If you are loading from a bundle that isn't found inside your app's `mainBundle`, simply pass a reference to your `NSBundle` in the `blast(_:)` method:

```Swift
FontBlaster.blast(_:) // Takes one argument of type NSBundle, or as mentioned above, defaults to NSBundle.mainBundle() if no arguments are passed
```

To turn on console debug statements, simply set `debugEnabled() = true` **before** calling either `blast()` method:

```Swift
FontBlaster.debugEnabled = true
FontBlaster.blast()
```

### Sample Project
A Sample iOS project is included in the repo. When you launch the app, all fonts are configured to load custom fonts, but don't actually display them *until* you push the button. After pushing the button, **FontBlaster** imports your fonts and redraws the view.

### Inspiration
This project builds upon an old solution that [Marco Arment](http://twitter.com/marcoarment) proposed and wrote about on his [blog](http://www.marco.org/2012/12/21/ios-dynamic-font-loading).

### Created and maintained by
[Arthur Ariel Sabintsev](http://www.sabintsev.com/)
