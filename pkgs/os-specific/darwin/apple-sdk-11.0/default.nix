# Compatibility stubs for packages that used the old SDK frameworks.
# TODO(@reckenrode) Make these stubs warn after framework usage has been cleaned up in nixpkgs.
{
  lib,
  callPackage,
  newScope,
  overrideSDK,
  pkgs,
  stdenv,
  stdenvNoCC,
}:

let
  mkStub = callPackage ../apple-sdk/mk-stub.nix { } "11.0";

  stdenvs =
    {
      stdenv = overrideSDK stdenv "11.0";
    }
    // builtins.listToAttrs (
      map
        (v: {
          name = "llvmPackages_${v}";
          value = pkgs."llvmPackages_${v}" // {
            stdenv = overrideSDK pkgs."llvmPackages_${v}".stdenv "11.0";
          };
        })
        [
          "12"
          "13"
          "14"
          "15"
          "16"
        ]
    );
in
stdenvs
// lib.genAttrs [
  "CLTools_Executables"
  "IOKit"
  "Libsystem"
  "LibsystemCross"
  "MacOSX-SDK"
  "configd"
  "darwin-stubs"
  "libcharset"
  "libcompression"
  "libnetwork"
  "libpm"
  "libunwind"
  "objc4"
  "sdkRoot"
] mkStub
// {
  frameworks = lib.genAttrs [
    "AGL"
    "AVFCapture"
    "AVFCore"
    "AVFoundation"
    "AVKit"
    "Accelerate"
    "Accessibility"
    "Accounts"
    "AdServices"
    "AdSupport"
    "AddressBook"
    "AddressBookCore"
    "AppKit"
    "AppTrackingTransparency"
    "Apple80211"
    "AppleScriptKit"
    "AppleScriptObjC"
    "ApplicationServices"
    "AudioToolbox"
    "AudioToolboxCore"
    "AudioUnit"
    "AudioVideoBridging"
    "AuthenticationServices"
    "AutomaticAssessmentConfiguration"
    "Automator"
    "BackgroundTasks"
    "BusinessChat"
    "CFNetwork"
    "CalendarStore"
    "CallKit"
    "Carbon"
    "ClassKit"
    "CloudKit"
    "Cocoa"
    "Collaboration"
    "ColorSync"
    "Combine"
    "Contacts"
    "ContactsPersistence"
    "ContactsUI"
    "CoreAudio"
    "CoreAudioKit"
    "CoreAudioTypes"
    "CoreBluetooth"
    "CoreData"
    "CoreDisplay"
    "CoreFoundation"
    "CoreGraphics"
    "CoreHaptics"
    "CoreImage"
    "CoreLocation"
    "CoreMIDI"
    "CoreMIDIServer"
    "CoreML"
    "CoreMedia"
    "CoreMediaIO"
    "CoreMotion"
    "CoreServices"
    "CoreSpotlight"
    "CoreSymbolication"
    "CoreTelephony"
    "CoreText"
    "CoreVideo"
    "CoreWLAN"
    "CryptoKit"
    "CryptoTokenKit"
    "DVDPlayback"
    "DebugSymbols"
    "DeveloperToolsSupport"
    "DeviceCheck"
    "DirectoryService"
    "DiscRecording"
    "DiscRecordingUI"
    "DiskArbitration"
    "DisplayServices"
    "DriverKit"
    "EventKit"
    "ExceptionHandling"
    "ExecutionPolicy"
    "ExternalAccessory"
    "FWAUserLib"
    "FileProvider"
    "FileProviderUI"
    "FinderSync"
    "ForceFeedback"
    "Foundation"
    "GLKit"
    "GLUT"
    "GSS"
    "GameCenterFoundation"
    "GameCenterUI"
    "GameCenterUICore"
    "GameController"
    "GameKit"
    "GameplayKit"
    "HIDDriverKit"
    "Hypervisor"
    "ICADevices"
    "IMServicePlugIn"
    "IOBluetooth"
    "IOBluetoothUI"
    "IOKit"
    "IOSurface"
    "IOUSBHost"
    "IdentityLookup"
    "ImageCaptureCore"
    "ImageIO"
    "InputMethodKit"
    "InstallerPlugins"
    "InstantMessage"
    "Intents"
    "JavaNativeFoundation"
    "JavaRuntimeSupport"
    "JavaScriptCore"
    "JavaVM"
    "Kerberos"
    "Kernel"
    "KernelManagement"
    "LDAP"
    "LatentSemanticMapping"
    "LinkPresentation"
    "LocalAuthentication"
    "MLCompute"
    "MapKit"
    "MediaAccessibility"
    "MediaLibrary"
    "MediaPlayer"
    "MediaRemote"
    "MediaToolbox"
    "Message"
    "Metal"
    "MetalKit"
    "MetalPerformanceShaders"
    "MetalPerformanceShadersGraph"
    "MetricKit"
    "ModelIO"
    "MultipeerConnectivity"
    "MultitouchSupport"
    "NaturalLanguage"
    "NearbyInteraction"
    "NetFS"
    "Network"
    "NetworkExtension"
    "NetworkingDriverKit"
    "NotificationCenter"
    "OSAKit"
    "OSLog"
    "OpenAL"
    "OpenCL"
    "OpenDirectory"
    "OpenGL"
    "PCIDriverKit"
    "PCSC"
    "PDFKit"
    "ParavirtualizedGraphics"
    "PassKit"
    "PassKitCore"
    "PencilKit"
    "Photos"
    "PhotosUI"
    "PreferencePanes"
    "PushKit"
    "Python"
    "QTKit"
    "Quartz"
    "QuartzCore"
    "QuickLook"
    "QuickLookThumbnailing"
    "QuickTime"
    "RealityKit"
    "ReplayKit"
    "Ruby"
    "SafariServices"
    "SceneKit"
    "ScreenSaver"
    "ScreenTime"
    "ScriptingBridge"
    "Security"
    "SecurityFoundation"
    "SecurityInterface"
    "SensorKit"
    "ServiceManagement"
    "SignpostMetrics"
    "SkyLight"
    "Social"
    "SoundAnalysis"
    "Speech"
    "SpriteKit"
    "StoreKit"
    "SwiftUI"
    "SyncServices"
    "System"
    "SystemConfiguration"
    "SystemExtensions"
    "TWAIN"
    "Tcl"
    "Tk"
    "UIFoundation"
    "URLFormatting"
    "USBDriverKit"
    "UniformTypeIdentifiers"
    "UserNotifications"
    "UserNotificationsUI"
    "VideoDecodeAcceleration"
    "VideoSubscriberAccount"
    "VideoToolbox"
    "Virtualization"
    "Vision"
    "WebKit"
    "WidgetKit"
    "iTunesLibrary"
    "vmnet"
  ] mkStub;

  libs = lib.genAttrs [
    "Xplugin"
    "utmp"
    "libDER"
    "xpc"
    "sandbox"
    "simd"
  ] mkStub;

  callPackage = newScope (
    lib.optionalAttrs stdenv.isDarwin stdenvs // { inherit (pkgs.darwin.apple_sdk_11_0) rustPlatform; }
  );

  rustPlatform =
    pkgs.makeRustPlatform {
      inherit (pkgs.darwin.apple_sdk_11_0) stdenv;
      inherit (pkgs) rustc cargo;
    }
    // {
      inherit
        (pkgs.callPackage ../../../build-support/rust/hooks {
          inherit (pkgs.darwin.apple_sdk_11_0) stdenv;
          inherit (pkgs) cargo rustc;
        })
        bindgenHook
        ;
    };

  stdenv = overrideSDK stdenv "11.0";

  xcodebuild = pkgs.xcodebuild;

  version = "11.0";
}
