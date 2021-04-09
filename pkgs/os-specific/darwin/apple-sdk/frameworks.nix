# Current as of 10.9
# Epic weird knot-tying happening here.
# TODO: clean up the process for generating this and include it

{ frameworks, libs, libobjc, }:

with frameworks; with libs; {
  AGL                     = { inherit Carbon OpenGL; };
  AVFoundation            = { inherit ApplicationServices CoreGraphics CoreMedia MediaToolbox; };
  AVKit                   = { inherit AppKit; };
  Accounts                = { inherit Foundation; };
  AddressBook             = { inherit Carbon Cocoa ContactsPersistence libobjc; };
  AppKit                  = { inherit ApplicationServices AudioToolbox AudioUnit Foundation QuartzCore UIFoundation; };
  AppKitScripting         = { inherit AppKit Scripting; };
  AppleScriptKit          = { inherit Cocoa; };
  AppleScriptObjC         = { inherit Foundation; };
  AudioToolbox            = { inherit Carbon CoreAudio CoreMIDI Foundation; };
  AudioUnit               = { inherit AudioToolbox Carbon CoreAudio; };
  AudioVideoBridging      = { inherit Foundation; };
  Automator               = { inherit Foundation OSAKit; };
  CFNetwork               = { inherit libobjc; };
  CalendarStore           = { inherit Foundation; };
  CloudKit                = { inherit Contacts CoreLocation Foundation; };
  Cocoa                   = { inherit AppKit CoreData; };
  Collaboration           = { inherit AppKit Foundation; };
  Contacts                = { inherit Foundation; };
  ContactsUI              = { inherit AppKit; };
  CoreAudio               = { inherit IOKit; };
  CoreAudioKit            = { inherit AudioUnit Cocoa; };
  CoreData                = {};
  # Impure version of CoreFoundation, this should not be used unless another
  # framework includes headers that are not available in the pure version.
  CoreFoundation          = { inherit libobjc; };
  CoreGraphics            = { inherit Accelerate IOKit IOSurface SystemConfiguration; };
  CoreImage               = { inherit CoreVideo Foundation; };
  CoreLocation            = { inherit Foundation; };
  CoreMIDI                = { inherit libobjc; };
  CoreMIDIServer          = { inherit CoreMIDI; };
  CoreMedia               = { inherit ApplicationServices AudioToolbox AudioUnit CoreAudio CoreGraphics CoreVideo; };
  CoreMediaIO             = { inherit CoreMedia; };
  CoreText                = { inherit CoreGraphics; };
  CoreVideo               = { inherit ApplicationServices CoreGraphics IOSurface Metal OpenGL; };
  CoreWLAN                = { inherit SecurityFoundation; };
  CryptoTokenKit          = { inherit Foundation Security; };
  DVDPlayback             = { inherit ApplicationServices; };
  DirectoryService        = { inherit libobjc; };
  DiscRecording           = { inherit CoreServices Foundation IOKit libobjc; };
  DiscRecordingUI         = { inherit Carbon Cocoa DiscRecording; };
  DiskArbitration         = { inherit IOKit; };
  EventKit                = { inherit AddressBook AppKit CoreLocation Foundation; };
  ExceptionHandling       = { inherit Foundation; };
  FWAUserLib              = { inherit Foundation; };
  FinderSync              = { inherit AppKit Foundation; };
  ForceFeedback           = { inherit IOKit; };
  GLKit                   = { inherit AppKit Foundation ModelIO OpenGL; };
  GLUT                    = { inherit OpenGL; };
  GSS                     = { inherit libobjc; };
  GameCenter              = {};
  GameController          = { inherit AppKit Foundation; };
  GameKit                 = { inherit Cocoa Foundation GameCenter GameController GameplayKit Metal MetalKit ModelIO SceneKit SpriteKit; };
  GameplayKit             = { inherit Foundation SpriteKit simd; };
  Hypervisor              = {};
  ICADevices              = { inherit Carbon IOBluetooth libobjc; };
  IMServicePlugIn         = { inherit Foundation; };
  IOBluetoothUI           = { inherit Cocoa Foundation IOBluetooth; };
  IOKit                   = { inherit libobjc; };
  IOSurface               = { inherit IOKit xpc; };
  ImageCaptureCore        = { inherit Foundation; };
  ImageIO                 = { inherit CoreGraphics; };
  InputMethodKit          = { inherit Carbon Cocoa; };
  InstallerPlugins        = { inherit Cocoa Foundation; };
  InstantMessage          = { inherit CoreVideo Foundation; };
  Intents                 = { inherit CoreLocation Foundation; };
  JavaFrameEmbedding      = { inherit Cocoa Foundation JavaVM; };
  JavaNativeFoundation    = { inherit Foundation JavaVM; };
  JavaRuntimeSupport      = { inherit Cocoa Foundation JavaVM; };
  JavaScriptCore          = { inherit Foundation libobjc; };
  Kerberos                = {};
  Kernel                  = { inherit IOKit; };
  LDAP                    = {};
  LatentSemanticMapping   = { inherit Carbon; };
  LocalAuthentication     = { inherit Foundation; };
  MapKit                  = { inherit AppKit CoreLocation Foundation; };
  MediaAccessibility      = { inherit CoreGraphics CoreText QuartzCore; };
  MediaLibrary            = { inherit Foundation; };
  MediaPlayer             = { inherit AVFoundation Foundation; };
  MediaToolbox            = { inherit AudioToolbox AudioUnit CoreMedia; };
  Metal                   = { inherit Foundation; };
  MetalKit                = { inherit AppKit Metal ModelIO simd; };
  ModelIO                 = { inherit Foundation simd; };
  MultipeerConnectivity   = { inherit Cocoa Foundation; };
  NetFS                   = { inherit libobjc; };
  NetworkExtension        = { inherit Foundation Network Security; };
  NotificationCenter      = { inherit AppKit; };
  OSAKit                  = { inherit Carbon Cocoa; };
  OpenAL                  = {};
  OpenCL                  = { inherit IOSurface OpenGL; };
  OpenGL                  = {};
  PCSC                    = { inherit CoreData; };
  Photos                  = { inherit AVFoundation CoreGraphics CoreImage CoreLocation CoreMedia Foundation ImageIO; };
  PhotosUI                = { inherit AppKit Foundation MapKit Photos; };
  PreferencePanes         = { inherit Cocoa; };
  PubSub                  = { inherit Foundation; };
  QTKit                   = { inherit CoreMedia CoreMediaIO MediaToolbox QuickTime VideoToolbox; };
  QuickLook               = { inherit ApplicationServices; };
  SafariServices          = { inherit AppKit Foundation; };
  SceneKit                = { inherit GLKit QuartzCore; };
  ScreenSaver             = { inherit AppKit Foundation; };
  Scripting               = { inherit Foundation; };
  ScriptingBridge         = { inherit Foundation; };
  Security                = { inherit IOKit; };
  SecurityFoundation      = {};
  SecurityInterface       = { inherit AppKit Cocoa Security SecurityFoundation; };
  ServiceManagement       = { inherit Security xpc; };
  Social                  = { inherit AppKit; };
  SpriteKit               = { inherit AppKit Cocoa CoreGraphics Foundation simd; };
  StoreKit                = { inherit Foundation; };
  SyncServices            = { inherit Foundation; };
  SystemConfiguration     = { inherit Security; };
  TWAIN                   = { inherit Carbon; };
  Tcl                     = {};
  VideoDecodeAcceleration = { inherit CoreVideo; };
  VideoToolbox            = { inherit CoreMedia CoreVideo; };
  WebKit                  = { inherit AppKit ApplicationServices Carbon JavaScriptCore OpenGL libobjc; };

  # Umbrellas
  Accelerate          = { inherit CoreWLAN IOBluetooth; };
  ApplicationServices = { inherit CoreGraphics CoreServices CoreText ImageIO; };
  Carbon              = { inherit ApplicationServices CoreServices Foundation IOKit QuartzCore Security libobjc; };
  CoreBluetooth       = {};
  # TODO: figure out which part of the umbrella depends on CoreFoundation and move it there.
  CoreServices        = { inherit CFNetwork CoreAudio CoreData CoreFoundation DiskArbitration NetFS OpenDirectory Security ServiceManagement; };
  Foundation          = { inherit ApplicationServices CoreFoundation CoreGraphics Security libobjc; };
  IOBluetooth         = { inherit CoreBluetooth IOKit; };
  JavaVM              = { inherit AppKit Foundation; };
  OpenDirectory       = {};
  Quartz              = { inherit AppKit Cocoa ImageCaptureCore QTKit QuartzCore QuickLook; };
  QuartzCore          = { inherit ApplicationServices CoreImage CoreVideo Metal OpenCL libobjc; };
  QuickTime           = { inherit ApplicationServices AudioUnit Carbon CoreAudio CoreServices OpenGL QuartzCore; };

  vmnet = { inherit libobjc xpc; };
}
