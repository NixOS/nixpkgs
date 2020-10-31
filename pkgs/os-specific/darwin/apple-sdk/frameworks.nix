# Current as of 10.9
# Epic weird knot-tying happening here.
# TODO: clean up the process for generating this and include it

{ frameworks, libs, libobjc, }:

with frameworks; with libs; {
  AGL                     = [ Carbon OpenGL ];
  AVFoundation            = [ ApplicationServices CoreGraphics CoreMedia MediaToolbox ];
  AVKit                   = [ AppKit ];
  Accounts                = [];
  AddressBook             = [ Carbon ];
  AppKit                  = [ AudioToolbox AudioUnit Foundation QuartzCore ];
  AppKitScripting         = [];
  AppleScriptKit          = [];
  AppleScriptObjC         = [];
  AudioToolbox            = [ CoreAudio CoreMIDI ];
  AudioUnit               = [ AudioToolbox Carbon CoreAudio ];
  AudioVideoBridging      = [ Foundation ];
  # Available with SDK 10.15
  AuthenticationServices  = [];
  Automator               = [];
  CFNetwork               = [];
  CalendarStore           = [];
  Cocoa                   = [ AppKit ];
  Collaboration           = [];
  Contacts                = [];
  ContactsUI              = [ AppKit ];
  # Impure version of CoreFoundation, this should not be used unless another
  # framework includes headers that are not available in the pure version.
  CoreFoundation          = [];
  CoreAudio               = [ IOKit ];
  CoreAudioKit            = [ AudioUnit Cocoa ];
  CoreData                = [];
  CoreGraphics            = [ Accelerate IOKit IOSurface SystemConfiguration ];
  CoreImage               = [];
  CoreLocation            = [];
  CoreMIDI                = [];
  CoreMIDIServer          = [];
  CoreMedia               = [ ApplicationServices AudioToolbox AudioUnit CoreAudio CoreGraphics CoreVideo ];
  CoreMediaIO             = [ CoreMedia ];
  CoreText                = [ CoreGraphics ];
  CoreVideo               = [ ApplicationServices CoreGraphics IOSurface Metal OpenGL ];
  CoreWLAN                = [ SecurityFoundation ];
  CryptoTokenKit          = [];
  DVDPlayback             = [];
  DirectoryService        = [];
  DiscRecording           = [ CoreServices IOKit ];
  DiscRecordingUI         = [];
  DiskArbitration         = [ IOKit ];
  EventKit                = [];
  ExceptionHandling       = [];
  # Available with SDK 10.13
  ExternalAccessory       = [];
  FWAUserLib              = [];
  ForceFeedback           = [ IOKit ];
  Foundation              = [ libobjc CoreFoundation Security ApplicationServices SystemConfiguration ];
  GLKit                   = [];
  GLUT                    = [ OpenGL ];
  GSS                     = [];
  GameController          = [];
  GameKit                 = [ Cocoa Foundation GameController GameplayKit MetalKit SceneKit SpriteKit ];
  GameplayKit             = [ SpriteKit ];
  Hypervisor              = [];
  ICADevices              = [ Carbon IOBluetooth ];
  IMServicePlugIn         = [];
  IOBluetoothUI           = [ IOBluetooth ];
  IOKit                   = [];
  IOSurface               = [ IOKit xpc ];
  ImageCaptureCore        = [];
  ImageIO                 = [ CoreGraphics ];
  InputMethodKit          = [ Carbon ];
  Intents                 = [ CoreLocation ];
  InstallerPlugins        = [];
  InstantMessage          = [];
  JavaFrameEmbedding      = [];
  JavaNativeFoundation    = [];
  JavaRuntimeSupport      = [];
  JavaScriptCore          = [];
  Kerberos                = [];
  Kernel                  = [ IOKit ];
  LDAP                    = [];
  LatentSemanticMapping   = [ Carbon ];
  LocalAuthentication     = [];
  MapKit                  = [ AppKit CoreLocation ];
  MediaAccessibility      = [ CoreGraphics CoreText QuartzCore ];
  MediaPlayer             = [];
  MediaToolbox            = [ AudioToolbox AudioUnit CoreMedia ];
  Metal                   = [];
  MetalKit                = [ AppKit ModelIO Metal ];
  ModelIO                 = [ ];
  NetFS                   = [];
  # Available with SDK 10.14
  Network                 = [];
  NetworkExtension        = [];
  NotificationCenter      = [ AppKit ];
  OSAKit                  = [ Carbon ];
  OpenAL                  = [];
  OpenCL                  = [ IOSurface OpenGL ];
  OpenGL                  = [];
  PCSC                    = [ CoreData ];
  Photos                  = [ CoreImage CoreMedia CoreVideo ];
  PhotosUI                = [ AppKit Photos ];
  PreferencePanes         = [];
  PubSub                  = [];
  # Available with SDK 10.15
  PushKit                 = [];
  QTKit                   = [ CoreMediaIO CoreMedia MediaToolbox QuickTime VideoToolbox ];
  QuickLook               = [ ApplicationServices ];
  SafariServices          = [ AppKit ];
  SceneKit                = [ GLKit QuartzCore ];
  ScreenSaver             = [ AppKit ];
  Scripting               = [];
  ScriptingBridge         = [];
  Security                = [ IOKit ];
  SecurityFoundation      = [];
  SecurityInterface       = [ Cocoa Security ];
  ServiceManagement       = [ Security ];
  Social                  = [];
  # Available with SDK 10.15
  Speech                  = [];
  SpriteKit               = [ AppKit Cocoa ];
  StoreKit                = [];
  SyncServices            = [];
  # Available with SDK 10.15
  SystemExtensions        = [];
  SystemConfiguration     = [ Security ];
  TWAIN                   = [ Carbon ];
  Tcl                     = [];
  # Available with SDK 10.14
  UserNotifications       = [];
  VideoDecodeAcceleration = [ CoreVideo ];
  VideoToolbox            = [ CoreMedia CoreVideo ];
  WebKit                  = [ AppKit ApplicationServices Carbon JavaScriptCore OpenGL ];

  # Umbrellas
  Accelerate          = [ CoreWLAN IOBluetooth ];
  ApplicationServices = [ CoreServices CoreText ImageIO ];
  Carbon              = [ ApplicationServices CoreServices Foundation IOKit Security QuartzCore ];
  CoreBluetooth       = [];
  CoreServices        = [ CFNetwork CoreAudio CoreData DiskArbitration Security NetFS OpenDirectory ServiceManagement ];
  IOBluetooth         = [ IOKit ];
  JavaVM              = [];
  OpenDirectory       = [];
  Quartz              = [ AppKit Cocoa ImageCaptureCore QuickLook QTKit ];
  QuartzCore          = [ ApplicationServices CoreVideo OpenCL CoreImage Metal ];
  QuickTime           = [ ApplicationServices AudioUnit Carbon CoreAudio CoreServices OpenGL QuartzCore ];

  vmnet = [];
}
