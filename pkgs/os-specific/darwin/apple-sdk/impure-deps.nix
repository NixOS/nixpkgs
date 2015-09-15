rec {
  CFNetwork = [
    "/System/Library/Frameworks/CFNetwork.framework"
    "/usr/lib/libsqlite3.dylib"
    "/usr/lib/libxml2.2.dylib"
  ];
  IOKit = [
    "/System/Library/Frameworks/IOKit.framework"
    "/usr/lib/libenergytrace.dylib"
  ];
  DiskArbitration = [
    "/System/Library/Frameworks/DiskArbitration.framework"
  ];
  Security = [
    "/System/Library/Frameworks/Security.framework"
    "/usr/lib/libbsm.0.dylib"
    "/usr/lib/libbz2.1.0.dylib"
    "/usr/lib/libpam.2.dylib"
    "/usr/lib/libxar.1.dylib"
    "/usr/lib/libxml2.2.dylib"
    "/usr/lib/libsqlite3.dylib"
  ];
  GSS = [
    "/System/Library/Frameworks/GSS.framework"
  ];
  Kerberos = [
    "/System/Library/Frameworks/Kerberos.framework"
  ];
  CoreServices = [
    "/System/Library/Frameworks/CoreServices.framework"
    "/System/Library/PrivateFrameworks/DataDetectorsCore.framework/Versions/A/DataDetectorsCore"
    "/System/Library/PrivateFrameworks/TCC.framework/Versions/A/TCC"
    "/System/Library/PrivateFrameworks/LanguageModeling.framework/Versions/A/LanguageModeling"
    "/usr/lib/libChineseTokenizer.dylib"
    "/usr/lib/libmarisa.dylib"
    "/usr/lib/libmecabra.dylib"
    "/usr/lib/libcmph.dylib"
    "/usr/lib/libiconv.2.dylib"
    "/usr/lib/libxslt.1.dylib"
  ] ++ Foundation;
  IOSurface = [
    "/System/Library/Frameworks/IOSurface.framework"
  ];
  CoreGraphics = [
    "/System/Library/Frameworks/CoreGraphics.framework"
    "/System/Library/PrivateFrameworks/MultitouchSupport.framework/Versions/A/MultitouchSupport"
    "/usr/lib/libbsm.0.dylib"
    "/usr/lib/libz.1.dylib"
  ];
  CoreText = [
    "/System/Library/Frameworks/CoreText.framework"
  ];
  ImageIO = [
    "/System/Library/Frameworks/ImageIO.framework"
  ];
  ApplicationServices = [
    "/System/Library/Frameworks/ApplicationServices.framework"
    "/usr/lib/libcups.2.dylib"
    "/usr/lib/libresolv.9.dylib"
  ] ++ AudioToolbox;
  OpenGL = [
    "/System/Library/Frameworks/OpenGL.framework"
  ];
  CoreVideo = [
    "/System/Library/Frameworks/CoreVideo.framework"
  ];
  QuartzCore = [
    "/System/Library/Frameworks/QuartzCore.framework"
    "/System/Library/PrivateFrameworks/CrashReporterSupport.framework/Versions/A/CrashReporterSupport"
  ];
  PCSC = [
    "/System/Library/Frameworks/PCSC.framework"
  ];
  AppKit = [
    "/System/Library/Frameworks/AppKit.framework"
    "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Apple80211"
    "/System/Library/PrivateFrameworks/AppleJPEG.framework/Versions/A/AppleJPEG"
    "/System/Library/PrivateFrameworks/AppleVPA.framework/Versions/A/AppleVPA"
    "/System/Library/PrivateFrameworks/Backup.framework/Versions/A/Backup"
    "/System/Library/PrivateFrameworks/ChunkingLibrary.framework/Versions/A/ChunkingLibrary"
    "/System/Library/PrivateFrameworks/CommonAuth.framework/Versions/A/CommonAuth"
    "/System/Library/PrivateFrameworks/CoreSymbolication.framework/Versions/A/CoreSymbolication"
    "/System/Library/PrivateFrameworks/CoreUI.framework/Versions/A/CoreUI"
    "/System/Library/PrivateFrameworks/CoreWiFi.framework/Versions/A/CoreWiFi"
    "/System/Library/PrivateFrameworks/CrashReporterSupport.framework/Versions/A/CrashReporterSupport"
    "/System/Library/PrivateFrameworks/DataDetectorsCore.framework/Versions/A/DataDetectorsCore"
    "/System/Library/PrivateFrameworks/DebugSymbols.framework/Versions/A/DebugSymbols"
    "/System/Library/PrivateFrameworks/DesktopServicesPriv.framework/Versions/A/DesktopServicesPriv"
    "/System/Library/PrivateFrameworks/FaceCore.framework/Versions/A/FaceCore"
    "/System/Library/PrivateFrameworks/GenerationalStorage.framework/Versions/A/GenerationalStorage"
    "/System/Library/PrivateFrameworks/Heimdal.framework/Heimdal"
    "/System/Library/PrivateFrameworks/Heimdal.framework/Versions/Current"
    "/System/Library/PrivateFrameworks/Heimdal.framework/Versions/A/Heimdal"
    "/System/Library/PrivateFrameworks/IconServices.framework/Versions/A/IconServices"
    "/System/Library/PrivateFrameworks/LanguageModeling.framework/Versions/A/LanguageModeling"
    "/System/Library/PrivateFrameworks/MultitouchSupport.framework/Versions/A/MultitouchSupport"
    "/System/Library/PrivateFrameworks/NetAuth.framework/Versions/A/NetAuth"
    "/System/Library/PrivateFrameworks/PerformanceAnalysis.framework/Versions/A/PerformanceAnalysis"
    "/System/Library/PrivateFrameworks/RemoteViewServices.framework/Versions/A/RemoteViewServices"
    "/System/Library/PrivateFrameworks/Sharing.framework/Versions/A/Sharing"
    "/System/Library/PrivateFrameworks/SpeechRecognitionCore.framework/Versions/A/SpeechRecognitionCore"
    "/System/Library/PrivateFrameworks/Symbolication.framework/Versions/A/Symbolication"
    "/System/Library/PrivateFrameworks/TCC.framework/Versions/A/TCC"
    "/System/Library/PrivateFrameworks/UIFoundation.framework/Versions/A/UIFoundation"
    "/System/Library/PrivateFrameworks/Ubiquity.framework/Versions/A/Ubiquity"
    "/System/Library/PrivateFrameworks/login.framework/Versions/A/Frameworks/loginsupport.framework/Versions/A/loginsupport"
    "/usr/lib/libCRFSuite.dylib"
    "/usr/lib/libOpenScriptingUtil.dylib"
    "/usr/lib/libarchive.2.dylib"
    "/usr/lib/libbsm.0.dylib"
    "/usr/lib/libbz2.1.0.dylib"
    "/usr/lib/libc++.1.dylib"
    "/usr/lib/libc++abi.dylib"
    "/usr/lib/libcmph.dylib"
    "/usr/lib/libcups.2.dylib"
    "/usr/lib/libextension.dylib"
    "/usr/lib/libheimdal-asn1.dylib"
    "/usr/lib/libiconv.2.dylib"
    "/usr/lib/libicucore.A.dylib"
    "/usr/lib/liblangid.dylib"
    "/usr/lib/liblzma.5.dylib"
    "/usr/lib/libmecabra.dylib"
    "/usr/lib/libpam.2.dylib"
    "/usr/lib/libresolv.9.dylib"
    "/usr/lib/libsqlite3.dylib"
    "/usr/lib/libxar.1.dylib"
    "/usr/lib/libxml2.2.dylib"
    "/usr/lib/libxslt.1.dylib"
    "/usr/lib/libz.1.dylib"
  ];
  Foundation = [
    "/System/Library/Frameworks/Foundation.framework"
    "/usr/lib/libextension.dylib"
    "/usr/lib/libarchive.2.dylib"
    "/usr/lib/liblzma.5.dylib"
    "/usr/lib/liblangid.dylib"
    "/usr/lib/libCRFSuite.dylib"
  ];
  CoreData = [
    "/System/Library/Frameworks/CoreData.framework"
  ];
  Cocoa = [
    "/System/Library/Frameworks/Cocoa.framework"
    "/System/Library/PrivateFrameworks/UIFoundation.framework/Versions/A/UIFoundation"
    "/System/Library/PrivateFrameworks/UIFoundation.framework/Versions/A"
  ];
  Carbon = [
    "/System/Library/Frameworks/Carbon.framework"
    "/System/Library/PrivateFrameworks/CoreUI.framework/Versions/A/CoreUI"
    "/System/Library/PrivateFrameworks/DesktopServicesPriv.framework/Versions/A/DesktopServicesPriv"
    "/System/Library/PrivateFrameworks/IconServices.framework/Versions/A/IconServices"
    "/System/Library/PrivateFrameworks/ChunkingLibrary.framework/Versions/A/ChunkingLibrary"
    "/System/Library/PrivateFrameworks/Ubiquity.framework/Versions/A/Ubiquity"
    "/System/Library/PrivateFrameworks/Sharing.framework/Versions/A/Sharing"
    "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Apple80211"
    "/System/Library/PrivateFrameworks/GenerationalStorage.framework/Versions/A/GenerationalStorage"
  ];
  CoreAudio = [
    "/System/Library/Frameworks/CoreAudio.framework"
  ];
  AudioUnit = [
    "/System/Library/Frameworks/AudioUnit.framework"
  ];
  CoreMIDI = [
    "/System/Library/Frameworks/CoreMIDI.framework"
  ];
  AudioToolbox = [
    "/System/Library/Frameworks/AudioToolbox.framework"
  ];
  SystemConfiguration = [
    "/System/Library/Frameworks/SystemConfiguration.framework"
  ];
  NetFS = [
    "/System/Library/Frameworks/NetFS.framework"
    "/System/Library/PrivateFrameworks/NetAuth.framework/Versions/A/NetAuth"
    "/System/Library/PrivateFrameworks/login.framework/Versions/A/Frameworks/loginsupport.framework/Versions/A/loginsupport"
  ];
  Accelerate = [
    "/System/Library/Frameworks/Accelerate.framework"
  ];
  OpenDirectory = [
    "/System/Library/Frameworks/OpenDirectory.framework"
  ];
  ServiceManagement = [
    "/System/Library/Frameworks/ServiceManagement.framework"
  ];
  OpenCL = [
    "/System/Library/Frameworks/OpenCL.framework"
  ];
  CoreWLAN = [
    "/System/Library/Frameworks/CoreWLAN.framework"
  ];
  IOBluetooth = [
    "/System/Library/Frameworks/IOBluetooth.framework"
  ] ++ AudioUnit ++ CoreBluetooth;
  CoreBluetooth = [
    "/System/Library/Frameworks/CoreBluetooth.framework"
  ];
  SecurityFoundation = [
    "/System/Library/Frameworks/SecurityFoundation.framework"
  ];
}
