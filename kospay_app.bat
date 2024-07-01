@echo off

rem Update dependencies
flutter pub get

rem Clean build artifacts
flutter clean

rem Analyze problem exist
flutter analyze

rem check error existence
if %errorlevel% neq 0 (
    echo Found code issues, fix them before building.
    exit /b 1
)

flutter build apk --release
