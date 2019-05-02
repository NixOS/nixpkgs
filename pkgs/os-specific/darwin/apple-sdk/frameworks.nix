# Current as of 10.9
# Epic weird knot-tying happening here.
# TODO: clean up the process for generating this and include it

{ frameworks, libs, CF, libobjc, cf-private }:

with frameworks; with libs; {
  AGL                     = [ Carbon OpenGL ];
  AVFoundation            = [ ApplicationServices CoreGraphics ];
  AVKit                   = [];
  Accounts                = [];
  AddressBook             = [ Carbon CF ];
  AppKit                  = [ AudioToolbox AudioUnit Foundation QuartzCore ];
  AppKitScripting         = [];
  AppleScriptKit          = [];
  AppleScriptObjC         = [];
  AudioToolbox            = [ CoreAudio CF CoreMIDI ];
  AudioUnit               = [ AudioToolbox Carbon CoreAudio CF ];
  AudioVideoBridging      = [ Foundation ];
  Automator               = [];
  CFNetwork               = [ CF ];
  CalendarStore           = [];
  Cocoa                   = [ AppKit ];
  Collaboration           = [];
  # Impure version of CoreFoundation, this should not be used unless another
  # framework includes headers that are not available in the pure version.
  CoreFoundation          = [];
  CoreAudio               = [ CF IOKit ];
  CoreAudioKit            = [ AudioUnit ];
  CoreData                = [];
  CoreGraphics            = [ Accelerate CF IOKit IOSurface SystemConfiguration ];
  CoreImage               = [ ];
  CoreLocation            = [];
  CoreMIDI                = [ CF ];
  CoreMIDIServer          = [];
  CoreMedia               = [ ApplicationServices AudioToolbox AudioUnit CoreAudio CF CoreGraphics CoreVideo ];
  CoreMediaIO             = [ CF CoreMedia ];
  CoreText                = [ CF CoreGraphics ];
  CoreVideo               = [ ApplicationServices CF CoreGraphics IOSurface OpenGL ];
  CoreWLAN                = [ SecurityFoundation ];
  DVDPlayback             = [];
  DirectoryService        = [ CF ];
  DiscRecording           = [ CF CoreServices IOKit ];
  DiscRecordingUI         = [];
  DiskArbitration         = [ CF IOKit ];
  EventKit                = [];
  ExceptionHandling       = [];
  FWAUserLib              = [];
  ForceFeedback           = [ CF IOKit ];
  Foundation              = [ cf-private libobjc Security ApplicationServices SystemConfiguration ];
  GLKit                   = [ CF ];
  GLUT                    = [ OpenGL ];
  GSS                     = [];
  GameController          = [];
  GameKit                 = [ Foundation ];
  Hypervisor              = [];
  ICADevices              = [ Carbon CF IOBluetooth ];
  IMServicePlugIn         = [];
  IOBluetoothUI           = [ IOBluetooth ];
  IOKit                   = [ CF ];
  IOSurface               = [ CF IOKit xpc ];
  ImageCaptureCore        = [];
  ImageIO                 = [ CF CoreGraphics ];
  InputMethodKit          = [ Carbon ];
  InstallerPlugins        = [];
  InstantMessage          = [];
  JavaFrameEmbedding      = [];
  JavaScriptCore          = [ CF ];
  Kerberos                = [];
  Kernel                  = [ CF IOKit ];
  LDAP                    = [];
  LatentSemanticMapping   = [ Carbon CF ];
  MapKit                  = [];
  MediaAccessibility      = [ CF CoreGraphics CoreText QuartzCore ];
  MediaToolbox            = [ AudioToolbox AudioUnit CF CoreMedia ];
  Metal                   = [];
  NetFS                   = [ CF ];
  OSAKit                  = [ Carbon ];
  OpenAL                  = [];
  OpenCL                  = [ IOSurface OpenGL ];
  OpenGL                  = [];
  PCSC                    = [ CoreData ];
  PreferencePanes         = [];
  PubSub                  = [];
  QTKit                   = [ CoreMediaIO CoreMedia MediaToolbox QuickTime VideoToolbox ];
  QuickLook               = [ ApplicationServices CF ];
  SceneKit                = [];
  ScreenSaver             = [];
  Scripting               = [];
  ScriptingBridge         = [];
  Security                = [ CF IOKit ];
  SecurityFoundation      = [];
  SecurityInterface       = [ Security ];
  ServiceManagement       = [ CF Security ];
  Social                  = [];
  SpriteKit               = [];
  StoreKit                = [];
  SyncServices            = [];
  SystemConfiguration     = [ CF Security ];
  TWAIN                   = [ Carbon ];
  Tcl                     = [];
  VideoDecodeAcceleration = [ CF CoreVideo ];
  VideoToolbox            = [ CF CoreMedia CoreVideo ];
  WebKit                  = [ ApplicationServices Carbon JavaScriptCore OpenGL ];

  # Umbrellas
  Accelerate          = [ CoreWLAN IOBluetooth ];
  ApplicationServices = [ CF CoreServices CoreText ImageIO ];
  Carbon              = [ ApplicationServices CF CoreServices Foundation IOKit Security QuartzCore ];
  CoreBluetooth       = [];
  CoreServices        = [ CFNetwork CoreAudio CoreData CF DiskArbitration Security NetFS OpenDirectory ServiceManagement ];
  IOBluetooth         = [ IOKit ];
  JavaVM              = [];
  OpenDirectory       = [];
  Quartz              = [ QuickLook QTKit ];
  QuartzCore          = [ ApplicationServices CF CoreVideo OpenCL CoreImage Metal ];
  QuickTime           = [ ApplicationServices AudioUnit Carbon CoreAudio CoreServices OpenGL QuartzCore ];

  vmnet = [];
}
