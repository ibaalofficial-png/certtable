# CertLedger

Private iOS sales ledger built with SwiftUI + SwiftData for iOS 26+.

## Fields
- Tanggal
- UDID
- Merek / Model HP
- Modal
- Harga Jual
- Keuntungan (otomatis)
- Status

## Build
Open `CertLedger.xcodeproj` in Xcode 26+.

GitHub Actions uses a macOS 26 runner to compile an unsigned iOS build. Add your own legitimate Apple signing setup if you need a signed IPA for a device.

## Notes
The app stores its data locally with SwiftData. No server or external database is required.
