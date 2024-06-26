# Current as of 10.12
# Epic weird knot-tying happening here.
# TODO: clean up the process for generating this and include it

{
  frameworks,
  libs,
  libobjc,
}:

with frameworks;
with libs;
{
  AGL = {
    inherit Carbon OpenGL;
  };
  AVFoundation = {
    inherit
      ApplicationServices
      CoreGraphics
      CoreMedia
      MediaToolbox
      ;
  };
  AVKit = { };
  Accounts = { };
  AddressBook = {
    inherit libobjc Carbon ContactsPersistence;
  };
  AppKit = {
    inherit
      ApplicationServices
      AudioToolbox
      AudioUnit
      Foundation
      QuartzCore
      UIFoundation
      ;
  };
  AppKitScripting = { };
  AppleScriptKit = { };
  AppleScriptObjC = { };
  AudioToolbox = {
    inherit CoreAudio CoreMIDI;
  };
  AudioUnit = {
    inherit AudioToolbox Carbon CoreAudio;
  };
  AudioVideoBridging = {
    inherit Foundation;
  };
  Automator = { };
  CFNetwork = { };
  CalendarStore = { };
  Cocoa = {
    inherit AppKit CoreData;
  };
  Collaboration = { };
  # Impure version of CoreFoundation, this should not be used unless another
  # framework includes headers that are not available in the pure version.
  CoreFoundation = { };
  CoreAudio = {
    inherit IOKit;
  };
  CoreAudioKit = {
    inherit AudioUnit;
  };
  CoreData = { };
  CoreGraphics = {
    inherit
      Accelerate
      IOKit
      IOSurface
      SystemConfiguration
      ;
  };
  CoreImage = { };
  CoreLocation = { };
  CoreMIDI = { };
  CoreMIDIServer = {
    inherit CoreMIDI;
  };
  CoreMedia = {
    inherit
      ApplicationServices
      AudioToolbox
      AudioUnit
      CoreAudio
      CoreGraphics
      CoreVideo
      ;
  };
  CoreMediaIO = {
    inherit CoreMedia;
  };
  CoreText = {
    inherit CoreGraphics;
  };
  CoreVideo = {
    inherit
      ApplicationServices
      CoreGraphics
      IOSurface
      OpenGL
      ;
  };
  CoreWLAN = {
    inherit SecurityFoundation;
  };
  DVDPlayback = { };
  DirectoryService = { };
  DiscRecording = {
    inherit libobjc CoreServices IOKit;
  };
  DiscRecordingUI = { };
  DiskArbitration = {
    inherit IOKit;
  };
  EventKit = { };
  ExceptionHandling = { };
  FWAUserLib = { };
  ForceFeedback = {
    inherit IOKit;
  };
  Foundation = {
    inherit
      libobjc
      CoreFoundation
      Security
      ApplicationServices
      SystemConfiguration
      ;
  };
  GLKit = { };
  GLUT = {
    inherit OpenGL;
  };
  GSS = { };
  GameCenter = { };
  GameController = { };
  GameKit = {
    inherit
      Cocoa
      Foundation
      GameCenter
      GameController
      GameplayKit
      Metal
      MetalKit
      ModelIO
      SceneKit
      SpriteKit
      ;
  };
  GameplayKit = { };
  Hypervisor = { };
  ICADevices = {
    inherit libobjc Carbon IOBluetooth;
  };
  IMServicePlugIn = { };
  IOBluetoothUI = {
    inherit IOBluetooth;
  };
  IOKit = { };
  IOSurface = {
    inherit IOKit xpc;
  };
  ImageCaptureCore = { };
  ImageIO = {
    inherit CoreGraphics;
  };
  InputMethodKit = {
    inherit Carbon;
  };
  InstallerPlugins = { };
  InstantMessage = { };
  JavaFrameEmbedding = { };
  JavaNativeFoundation = { };
  JavaRuntimeSupport = { };
  JavaScriptCore = {
    inherit libobjc;
  };
  Kerberos = { };
  Kernel = {
    inherit IOKit;
  };
  LDAP = { };
  LatentSemanticMapping = {
    inherit Carbon;
  };
  LocalAuthentication = { };
  MapKit = { };
  MediaAccessibility = {
    inherit CoreGraphics CoreText QuartzCore;
  };
  MediaPlayer = { };
  MediaToolbox = {
    inherit AudioToolbox AudioUnit CoreMedia;
  };
  Metal = { };
  MetalKit = {
    inherit ModelIO Metal;
  };
  ModelIO = { };
  NetFS = { };
  OSAKit = {
    inherit Carbon;
  };
  OpenAL = { };
  OpenCL = {
    inherit IOSurface OpenGL;
  };
  OpenGL = { };
  PCSC = {
    inherit CoreData;
  };
  PreferencePanes = { };
  PubSub = { };
  QTKit = {
    inherit
      CoreMediaIO
      CoreMedia
      MediaToolbox
      QuickTime
      VideoToolbox
      ;
  };
  QuickLook = {
    inherit ApplicationServices;
  };
  SceneKit = { };
  ScreenSaver = { };
  Scripting = { };
  ScriptingBridge = { };
  Security = {
    inherit IOKit;
  };
  SecurityFoundation = { };
  SecurityInterface = {
    inherit Security SecurityFoundation;
  };
  ServiceManagement = {
    inherit Security;
  };
  Social = { };
  SpriteKit = { };
  StoreKit = { };
  SyncServices = { };
  System = { };
  SystemConfiguration = {
    inherit Security;
  };
  TWAIN = {
    inherit Carbon;
  };
  Tcl = { };
  VideoDecodeAcceleration = {
    inherit CoreVideo;
  };
  VideoToolbox = {
    inherit CoreMedia CoreVideo;
  };
  WebKit = {
    inherit
      libobjc
      ApplicationServices
      Carbon
      JavaScriptCore
      OpenGL
      ;
  };

  # Umbrellas
  Accelerate = {
    inherit CoreWLAN IOBluetooth;
  };
  ApplicationServices = {
    inherit
      CoreGraphics
      CoreServices
      CoreText
      ImageIO
      ;
  };
  Carbon = {
    inherit
      libobjc
      ApplicationServices
      CoreServices
      Foundation
      IOKit
      Security
      QuartzCore
      ;
  };
  CoreBluetooth = { };
  # TODO: figure out which part of the umbrella depends on CoreFoundation and move it there.
  CoreServices = {
    inherit
      CFNetwork
      CoreFoundation
      CoreAudio
      CoreData
      DiskArbitration
      Security
      NetFS
      OpenDirectory
      ServiceManagement
      ;
  };
  IOBluetooth = {
    inherit CoreBluetooth IOKit;
  };
  JavaVM = { };
  OpenDirectory = { };
  Quartz = {
    inherit QuartzCore QuickLook QTKit;
  };
  QuartzCore = {
    inherit
      libobjc
      ApplicationServices
      CoreVideo
      OpenCL
      CoreImage
      Metal
      ;
  };
  QuickTime = {
    inherit
      ApplicationServices
      AudioUnit
      Carbon
      CoreAudio
      CoreServices
      OpenGL
      QuartzCore
      ;
  };

  vmnet = { };
}
