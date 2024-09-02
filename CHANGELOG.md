# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Logging of the API response to the log file.
- New function for automatic unit conversion.

### Changed
- Updated `update_pwsweather.sh` to improve handling of missing values.
- Enhanced error handling for HTTP requests.

### Fixed
- Fixed a bug that occasionally led to incorrect wind speed calculations.

## [1.0.3] - 2024-09-02
### Added
- Changed the selector for hourly rain from _0xOD_ (rainevent) to _0x0E_ (rainrate). The value of _rainrate_ represents the rainfall of the past 10 minutes multiplied by 6 (so we have got the rain the past hour here).

## [1.0.2] - 2024-09-02
### Added
- Changed the selector for current wind speed from `0x19` to `0x0B` because `0x19` represents the daily maximum wind speed and not the current wind speed.
- Added CHANGELOG.md

## [1.0.1] - 2024-08-18
### Added
- Initial release of the `update_pwsweather.sh` script.
- Implemented core functionality for sending data to PWSweather.com.

## [1.0.0] - 2024-08-17
### Added
- Initial project setup.
