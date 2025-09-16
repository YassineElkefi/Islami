# 🕌 Islami

[![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.7+-orange.svg)](https://swift.org/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-4.0+-green.svg)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)](#)

A comprehensive SwiftUI application providing accurate prayer times, Qibla direction, and Quran reading functionality for Muslims worldwide. Built with modern iOS development practices and designed with accessibility and performance in mind.

## ✨ Features

### 🕐 Prayer Times
- **Accurate Calculations**: Multiple calculation methods (Muslim World League, ISNA, Umm Al-Qura)
- **Smart Notifications**: Customizable prayer time alerts with beautiful Adhan sounds
- **Hijri Calendar**: Complete Islamic calendar integration
- **Location Aware**: Automatic location detection with manual override options

### 🧭 Qibla Direction
- **Precise Compass**: Real-time Qibla direction with magnetic declination compensation
- **Animated Interface**: Smooth, intuitive compass with calibration guidance
- **Works Anywhere**: Accurate calculations for any location worldwide

### 📖 Quran Reader
- **Complete Quran**: All 114 Surahs with beautiful Arabic typography
- **Multiple Translations**: Support for various languages and interpretations
- **Audio Playback**: High-quality recitations from renowned Qaris
- **Smart Features**: Bookmarking, search functionality, and reading progress tracking
- **Offline Ready**: Full functionality without internet connection

### ⚙️ Personalization
- **Themes**: Light/Dark mode with Islamic aesthetic options
- **Languages**: Multi-language support (Arabic, English, and more)
- **Custom Settings**: Personalized calculation methods, notification preferences
- **Accessibility**: Full VoiceOver support and dynamic text sizing

<!-- ## 📱 Screenshots

| Prayer Times | Qibla Compass | Quran Reader |
|:---:|:---:|:---:|
| ![Prayer Times](screenshots/prayer-times.png) | ![Qibla](screenshots/qibla.png) | ![Quran](screenshots/quran.png) | -->

## 🏗️ Architecture

Built using **MVVM (Model-View-ViewModel)** architecture pattern with SwiftUI for a clean, maintainable, and testable codebase.

### Key Technologies
- **SwiftUI**: Modern, declarative UI framework
- **Core Data**: Local data persistence and caching
- **Core Location**: Location services and GPS functionality
- **AVFoundation**: Audio playback for Adhan and Quran recitations
- **Combine**: Reactive programming for data flow

### Project Structure
```
IslamicApp/
├── 📱 App/                    # App entry point and configuration
├── 🎯 Features/               # Feature-based modules
│   ├── PrayerTimes/          # Prayer times calculation and UI
│   ├── Qibla/                # Compass and Qibla direction
│   └── Quran/                # Quran reader and audio
├── 🔗 Shared/                # Shared utilities and services
│   ├── Models/               # Data models
│   ├── Services/             # Business logic services
│   ├── Utilities/            # Extensions and helpers
│   └── UI/                   # Reusable UI components
├── 📦 Resources/             # Assets, fonts, and data files
└── 🧪 Tests/                 # Unit and UI tests
```

## 🚀 Getting Started

### Prerequisites
- **Xcode 26.0+**
- **iOS 18.0+** deployment target
- **Swift 5.7+**
<!--- Apple Developer Account (for device testing)-->

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/islamic-prayer-app.git
   cd islamic-prayer-app
   ```

2. **Install Dependencies**
   ```bash
   # Using Swift Package Manager (recommended)
   # Dependencies are automatically resolved when opening in Xcode
   ```

3. **Open in Xcode**
   ```bash
   open IslamicApp.xcodeproj
   ```

4. **Configure Signing**
   - Select your development team in Project Settings
   - Update bundle identifier if needed

5. **Build and Run**
   - Select your target device or simulator
   - Press `⌘ + R` to build and run

<!-- ### Configuration

#### Location Services
The app requires location permissions for accurate prayer times and Qibla direction:
```swift
// Add to Info.plist
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to calculate accurate prayer times and Qibla direction.</string>
```

#### Background Modes (Optional)
For prayer time notifications:
```xml
<key>UIBackgroundModes</key>
<array>
    <string>background-processing</string>
</array>
```

## 📦 Dependencies

### Essential
- **[Adhan-swift](https://github.com/batoulapps/adhan-swift)**: Prayer time calculations
- **Core Location**: Location services (built-in)
- **AVFoundation**: Audio playback (built-in)
- **Core Data**: Local storage (built-in)

### Optional
- **[Alamofire](https://github.com/Alamofire/Alamofire)**: Enhanced networking
- **[SwiftUI-Introspect](https://github.com/siteline/SwiftUI-Introspect)**: UIKit integration
- **[Lottie](https://github.com/airbnb/lottie-ios)**: Advanced animations

## 🛠️ Development

### Building Features

The app follows a modular architecture. Each feature is self-contained:

```swift
// Example: Adding a new prayer time calculation method
struct CustomCalculationMethod: CalculationMethod {
    var method: Method = .custom
    var fajrAngle: Double = 18.0
    var ishaa: IshaInterval = .angle(17.0)
    // Implementation...
}
```

### Testing

Run the test suite:
```bash
# Unit Tests
⌘ + U in Xcode

# UI Tests
⌘ + U with UI Test target selected
```
-->

### Code Style

We follow Swift's official style guidelines:
- Use meaningful variable names
- Follow MVVM pattern strictly
- Add documentation for public APIs
- Write tests for business logic

## 📋 Roadmap

### Phase 1: Core Features ✅
- [ ] Prayer times calculation
- [ ] Qibla direction
- [ ] Basic Quran reader

### Phase 2: Enhanced Features 🚧
- [ ] Audio playback
- [ ] Notifications
- [ ] Advanced search
- [ ] Reading statistics

### Phase 3: Premium Features 📋
- [ ] Tafsir integration
- [ ] Hadith collection
- [ ] Community features
- [ ] Widget support

<!--## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### How to Contribute

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Setup

```bash
# Fork and clone your fork
git clone https://github.com/yourusername/islamic-prayer-app.git

# Add upstream remote
git remote add upstream https://github.com/originalowner/islamic-prayer-app.git

# Create feature branch
git checkout -b feature/your-feature-name
```
-->
## 📄 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

- **Batoul Apps** for the excellent [Adhan-swift](https://github.com/batoulapps/adhan-swift) library
- **Quran.com** for providing accessible Quran data and translations
- **Islamic Society of North America (ISNA)** for calculation method standards
- The open-source community for inspiration and resources

## 📞 Support

- 📧 **Email**: yassine.elkefi6@gmail.com
- 🐛 **Issues**: [GitHub Issues](https://github.com/YassineElkefi/Islami/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/YassineElkefi/Islami/discussions)
- 📱 **App Store**: [Download Here](#) (Coming Soon)

## 📊 Statistics

![GitHub stars](https://img.shields.io/github/stars/YassineElkefi/Islami?style=social)
![GitHub forks](https://img.shields.io/github/forks/YassineElkefi/Islami?style=social)
![GitHub issues](https://img.shields.io/github/issues/YassineElkefi/Islami)
![GitHub pull requests](https://img.shields.io/github/issues-pr/YassineElkefi/Islami)

---

<div align="center">

**Made with ❤️ for the Muslim community**

*"And whoever relies upon Allah - then He is sufficient for him. Indeed, Allah will accomplish His purpose."* - **Quran 65:3**

[⬆ Back to Top](#🕌-islami)

</div>