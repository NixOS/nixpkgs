{ frameworks, libs, objc }:

with frameworks; with libs;
{
AE = {
  pname                 = "AE";
  frameworkPath         = "System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/AE.framework";
  Current               = "A";
  propagatedBuildInputs = [ CarbonCore CoreFoundation ];
};
AGL = {
  pname                 = "AGL";
  frameworkPath         = "System/Library/Frameworks/AGL.framework";
  Current               = "A";
  propagatedBuildInputs = [ Carbon OpenGL ];
};
APFS = {
  pname                 = "APFS";
  frameworkPath         = "System/Library/PrivateFrameworks/APFS.framework";
  Current               = "A";
};
ATS = {
  pname                 = "ATS";
  frameworkPath         = "System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ATS.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation CoreGraphics CoreServices CoreText ];
};
AVFAudio = {
  pname                 = "AVFAudio";
  frameworkPath         = "System/Library/Frameworks/AVFoundation.framework/Versions/A/Frameworks/AVFAudio.framework";
  Current               = "A";
  propagatedBuildInputs = [ AVFoundation AudioToolbox AudioUnit CoreAudio CoreMIDI CoreMedia Foundation ];
};
AVFoundation = {
  pname                 = "AVFoundation";
  frameworkPath         = "System/Library/Frameworks/AVFoundation.framework";
  Current               = "A";
  propagatedBuildInputs = [ AVFAudio CoreFoundation CoreGraphics CoreMedia CoreVideo Foundation MediaToolbox QuartzCore ];
};
AVKit = {
  pname                 = "AVKit";
  frameworkPath         = "System/Library/Frameworks/AVKit.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit ];
};
Accelerate = {
  pname                 = "Accelerate";
  frameworkPath         = "System/Library/Frameworks/Accelerate.framework";
  Current               = "A";
  propagatedBuildInputs = [ vImage vecLib ];
};
AccessibilitySharedSupport = {
  pname                 = "AccessibilitySharedSupport";
  frameworkPath         = "System/Library/PrivateFrameworks/AccessibilitySharedSupport.framework";
  Current               = "A";
};
Accounts = {
  pname                 = "Accounts";
  frameworkPath         = "System/Library/Frameworks/Accounts.framework";
  Current               = "A";
  propagatedBuildInputs = [ Foundation ];
};
AccountsDaemon = {
  pname                 = "AccountsDaemon";
  frameworkPath         = "System/Library/PrivateFrameworks/AccountsDaemon.framework";
  Current               = "A";
};
AddressBook = {
  pname                 = "AddressBook";
  frameworkPath         = "System/Library/Frameworks/AddressBook.framework";
  Current               = "A";
  propagatedBuildInputs = [ Carbon Cocoa CoreFoundation Foundation ];
};
AnnotationKit = {
  pname                 = "AnnotationKit";
  frameworkPath         = "System/Library/PrivateFrameworks/AnnotationKit.framework";
  Current               = "A";
};
AppKit = {
  pname                 = "AppKit";
  frameworkPath         = "System/Library/Frameworks/AppKit.framework";
  Current               = "C";
  propagatedBuildInputs = [ ApplicationServices CoreData CoreFoundation CoreGraphics Foundation OpenGL QuartzCore ];
};
AppKitScripting = {
  pname                 = "AppKitScripting";
  frameworkPath         = "System/Library/Frameworks/AppKitScripting.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit Scripting ];
};
AppSupportUI = {
  pname                 = "AppSupportUI";
  frameworkPath         = "System/Library/PrivateFrameworks/AppSupportUI.framework";
  Current               = "A";
};
AppleLDAP = {
  pname                 = "AppleLDAP";
  frameworkPath         = "System/Library/PrivateFrameworks/AppleLDAP.framework";
  Current               = "A";
};
AppleScriptKit = {
  pname                 = "AppleScriptKit";
  frameworkPath         = "System/Library/Frameworks/AppleScriptKit.framework";
  Current               = "A";
  propagatedBuildInputs = [ Cocoa ];
};
AppleScriptObjC = {
  pname                 = "AppleScriptObjC";
  frameworkPath         = "System/Library/Frameworks/AppleScriptObjC.framework";
  Current               = "A";
  propagatedBuildInputs = [ Foundation ];
};
ApplicationServices = {
  pname                 = "ApplicationServices";
  frameworkPath         = "System/Library/Frameworks/ApplicationServices.framework";
  Current               = "A";
  propagatedBuildInputs = [ ATS ColorSync CoreGraphics CoreServices CoreText HIServices ImageIO LangAnalysis PrintCore QD SpeechSynthesis ];
};
AudioToolbox = {
  pname                 = "AudioToolbox";
  frameworkPath         = "System/Library/Frameworks/AudioToolbox.framework";
  Current               = "A";
  propagatedBuildInputs = [ Carbon Cocoa CoreAudio CoreFoundation CoreMIDI Foundation ];
};
AudioUnit = {
  pname                 = "AudioUnit";
  frameworkPath         = "System/Library/Frameworks/AudioUnit.framework";
  Current               = "A";
  propagatedBuildInputs = [ AudioToolbox ];
};
AudioVideoBridging = {
  pname                 = "AudioVideoBridging";
  frameworkPath         = "System/Library/Frameworks/AudioVideoBridging.framework";
  Current               = "A";
  propagatedBuildInputs = [ Foundation IOKit ];
};
AuthKit = {
  pname                 = "AuthKit";
  frameworkPath         = "System/Library/PrivateFrameworks/AuthKit.framework";
  Current               = "A";
};
AuthKitUI = {
  pname                 = "AuthKitUI";
  frameworkPath         = "System/Library/PrivateFrameworks/AuthKitUI.framework";
  Current               = "A";
};
Automator = {
  pname                 = "Automator";
  frameworkPath         = "System/Library/Frameworks/Automator.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit Foundation OSAKit ];
};
BioKitAggD = {
  pname                 = "BioKitAggD";
  frameworkPath         = "System/Library/PrivateFrameworks/BioKitAggD.framework";
  Current               = "A";
};
BluetoothAudio = {
  pname                 = "BluetoothAudio";
  frameworkPath         = "System/Library/PrivateFrameworks/BluetoothAudio.framework";
  Current               = "A";
};
BridgeXPC = {
  pname                 = "BridgeXPC";
  frameworkPath         = "System/Library/PrivateFrameworks/BridgeXPC.framework";
  Current               = "A";
};
CFNetwork = {
  pname                 = "CFNetwork";
  frameworkPath         = "System/Library/Frameworks/CFNetwork.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation ];
};
CFOpenDirectory = {
  pname                 = "CFOpenDirectory";
  frameworkPath         = "System/Library/Frameworks/OpenDirectory.framework/Versions/A/Frameworks/CFOpenDirectory.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation Foundation ];
};
CalendarStore = {
  pname                 = "CalendarStore";
  frameworkPath         = "System/Library/Frameworks/CalendarStore.framework";
  Current               = "A";
  propagatedBuildInputs = [ Foundation ];
};
CallKit = {
  pname                 = "CallKit";
  frameworkPath         = "System/Library/PrivateFrameworks/CallKit.framework";
  Current               = "A";
};
Carbon = {
  pname                 = "Carbon";
  frameworkPath         = "System/Library/Frameworks/Carbon.framework";
  Current               = "A";
  propagatedBuildInputs = [ ApplicationServices CarbonSound CommonPanels CoreServices HIToolbox Help ImageCapture Ink NavigationServices OpenScripting Print SecurityHI SpeechRecognition ];
};
CarbonCore = {
  pname                 = "CarbonCore";
  frameworkPath         = "System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/CarbonCore.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation DiskArbitration hfs ];
};
CarbonSound = {
  pname                 = "CarbonSound";
  frameworkPath         = "System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/CarbonSound.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreServices HIToolbox ];
};
Catalyst = {
  pname                 = "Catalyst";
  frameworkPath         = "System/Library/PrivateFrameworks/Catalyst.framework";
  Current               = "A";
};
CloudKit = {
  pname                 = "CloudKit";
  frameworkPath         = "System/Library/Frameworks/CloudKit.framework";
  Current               = "A";
  propagatedBuildInputs = [ Contacts CoreLocation Foundation ];
};
CloudKitDaemon = {
  pname                 = "CloudKitDaemon";
  frameworkPath         = "System/Library/PrivateFrameworks/CloudKitDaemon.framework";
  Current               = "A";
};
CloudServices = {
  pname                 = "CloudServices";
  frameworkPath         = "System/Library/PrivateFrameworks/CloudServices.framework";
  Current               = "A";
};
Cocoa = {
  pname                 = "Cocoa";
  frameworkPath         = "System/Library/Frameworks/Cocoa.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit CoreData Foundation ];
};
Collaboration = {
  pname                 = "Collaboration";
  frameworkPath         = "System/Library/Frameworks/Collaboration.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit CoreServices Foundation ];
};
ColorSync = {
  pname                 = "ColorSync";
  frameworkPath         = "System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ColorSync.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation ];
};
CommonPanels = {
  pname                 = "CommonPanels";
  frameworkPath         = "System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/CommonPanels.framework";
  Current               = "A";
  propagatedBuildInputs = [ ApplicationServices Carbon CoreServices HIToolbox ];
};
Contacts = {
  pname                 = "Contacts";
  frameworkPath         = "System/Library/Frameworks/Contacts.framework";
  Current               = "A";
  propagatedBuildInputs = [ Foundation ];
};
ContactsUI = {
  pname                 = "ContactsUI";
  frameworkPath         = "System/Library/Frameworks/ContactsUI.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit ];
};
ContactsUICore = {
  pname                 = "ContactsUICore";
  frameworkPath         = "System/Library/PrivateFrameworks/ContactsUICore.framework";
  Current               = "A";
};
CoreAudio = {
  pname                 = "CoreAudio";
  frameworkPath         = "System/Library/Frameworks/CoreAudio.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation IOKit ];
};
CoreAudioKit = {
  pname                 = "CoreAudioKit";
  frameworkPath         = "System/Library/Frameworks/CoreAudioKit.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit AudioUnit Cocoa Foundation UIKit ];
};
CoreBluetooth = {
  pname                 = "CoreBluetooth";
  frameworkPath         = "System/Library/Frameworks/CoreBluetooth.framework";
  Current               = "A";
  propagatedBuildInputs = [ Foundation ];
};
CoreBrightness = {
  pname                 = "CoreBrightness";
  frameworkPath         = "System/Library/PrivateFrameworks/CoreBrightness.framework";
  Current               = "A";
};
CoreData = {
  pname                 = "CoreData";
  frameworkPath         = "System/Library/Frameworks/CoreData.framework";
  Current               = "A";
  propagatedBuildInputs = [ Foundation ];
};
CoreDisplay = {
  pname                 = "CoreDisplay";
  frameworkPath         = "System/Library/Frameworks/CoreDisplay.framework";
  Current               = "A";
};
CoreEmoji = {
  pname                 = "CoreEmoji";
  frameworkPath         = "System/Library/PrivateFrameworks/CoreEmoji.framework";
  Current               = "A";
};
CoreFoundation = {
  pname                 = "CoreFoundation";
  frameworkPath         = "System/Library/Frameworks/CoreFoundation.framework";
  Current               = "A";
};
CoreGraphics = {
  pname                 = "CoreGraphics";
  frameworkPath         = "System/Library/Frameworks/CoreGraphics.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation IOKit ];
};
CoreImage = {
  pname                 = "CoreImage";
  frameworkPath         = "System/Library/Frameworks/CoreImage.framework";
  Current               = "A";
  propagatedBuildInputs = [ ApplicationServices CoreGraphics CoreVideo Foundation IOSurface OpenGL OpenGLES ];
};
CoreLocation = {
  pname                 = "CoreLocation";
  frameworkPath         = "System/Library/Frameworks/CoreLocation.framework";
  Current               = "A";
  propagatedBuildInputs = [ Foundation ];
};
CoreMIDI = {
  pname                 = "CoreMIDI";
  frameworkPath         = "System/Library/Frameworks/CoreMIDI.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation ];
};
CoreMIDIServer = {
  pname                 = "CoreMIDIServer";
  frameworkPath         = "System/Library/Frameworks/CoreMIDIServer.framework";
  Current               = "A";
};
CoreMedia = {
  pname                 = "CoreMedia";
  frameworkPath         = "System/Library/Frameworks/CoreMedia.framework";
  Current               = "A";
  propagatedBuildInputs = [ AudioToolbox CoreAudio CoreFoundation CoreGraphics CoreVideo ];
};
CoreMediaIO = {
  pname                 = "CoreMediaIO";
  frameworkPath         = "System/Library/Frameworks/CoreMediaIO.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation CoreMedia ];
};
CoreNameParser = {
  pname                 = "CoreNameParser";
  frameworkPath         = "System/Library/PrivateFrameworks/CoreNameParser.framework";
  Current               = "A";
};
CoreParsec = {
  pname                 = "CoreParsec";
  frameworkPath         = "System/Library/PrivateFrameworks/CoreParsec.framework";
  Current               = "A";
};
CoreServices = {
  pname                 = "CoreServices";
  frameworkPath         = "System/Library/Frameworks/CoreServices.framework";
  Current               = "A";
  propagatedBuildInputs = [ AE CFNetwork CarbonCore CoreFoundation DictionaryServices FSEvents LaunchServices Metadata OSServices SearchKit SharedFileList ];
};
CoreTelephony = {
  pname                 = "CoreTelephony";
  frameworkPath         = "System/Library/Frameworks/CoreTelephony.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation Foundation ];
};
CoreText = {
  pname                 = "CoreText";
  frameworkPath         = "System/Library/Frameworks/CoreText.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation CoreGraphics ];
};
CoreUtils = {
  pname                 = "CoreUtils";
  frameworkPath         = "System/Library/PrivateFrameworks/CoreUtils.framework";
  Current               = "A";
};
CoreVideo = {
  pname                 = "CoreVideo";
  frameworkPath         = "System/Library/Frameworks/CoreVideo.framework";
  Current               = "A";
  propagatedBuildInputs = [ ApplicationServices CoreFoundation CoreGraphics IOSurface Metal OpenGL ];
};
CoreWLAN = {
  pname                 = "CoreWLAN";
  frameworkPath         = "System/Library/Frameworks/CoreWLAN.framework";
  Current               = "A";
  propagatedBuildInputs = [ Foundation ];
};
CryptoTokenKit = {
  pname                 = "CryptoTokenKit";
  frameworkPath         = "System/Library/Frameworks/CryptoTokenKit.framework";
  Current               = "A";
  propagatedBuildInputs = [ Foundation Security ];
};
DFRBrightness = {
  pname                 = "DFRBrightness";
  frameworkPath         = "System/Library/PrivateFrameworks/DFRBrightness.framework";
  Current               = "A";
};
DSExternalDisplay = {
  pname                 = "DSExternalDisplay";
  frameworkPath         = "System/Library/PrivateFrameworks/DSExternalDisplay.framework";
  Current               = "A";
};
DVDPlayback = {
  pname                 = "DVDPlayback";
  frameworkPath         = "System/Library/Frameworks/DVDPlayback.framework";
  Current               = "A";
};
DictionaryServices = {
  pname                 = "DictionaryServices";
  frameworkPath         = "System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/DictionaryServices.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation ];
};
DirectoryService = {
  pname                 = "DirectoryService";
  frameworkPath         = "System/Library/Frameworks/DirectoryService.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation ];
};
DiscRecording = {
  pname                 = "DiscRecording";
  frameworkPath         = "System/Library/Frameworks/DiscRecording.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation CoreServices Foundation IOKit ];
};
DiscRecordingUI = {
  pname                 = "DiscRecordingUI";
  frameworkPath         = "System/Library/Frameworks/DiscRecordingUI.framework";
  Current               = "A";
  propagatedBuildInputs = [ Carbon Cocoa DiscRecording ];
};
DiskArbitration = {
  pname                 = "DiskArbitration";
  frameworkPath         = "System/Library/Frameworks/DiskArbitration.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation IOKit ];
};
DistributedEvaluation = {
  pname                 = "DistributedEvaluation";
  frameworkPath         = "System/Library/PrivateFrameworks/DistributedEvaluation.framework";
  Current               = "A";
};
DrawingKit = {
  pname                 = "DrawingKit";
  frameworkPath         = "System/Library/PrivateFrameworks/DrawingKit.framework";
  Current               = "A";
};
EasyConfig = {
  pname                 = "EasyConfig";
  frameworkPath         = "System/Library/PrivateFrameworks/EasyConfig.framework";
  Current               = "A";
};
EmailAddressing = {
  pname                 = "EmailAddressing";
  frameworkPath         = "System/Library/PrivateFrameworks/EmailAddressing.framework";
  Current               = "A";
};
EmailCore = {
  pname                 = "EmailCore";
  frameworkPath         = "System/Library/PrivateFrameworks/EmailCore.framework";
  Current               = "A";
};
EmbeddedAcousticRecognition = {
  pname                 = "EmbeddedAcousticRecognition";
  frameworkPath         = "System/Library/PrivateFrameworks/EmbeddedAcousticRecognition.framework";
  Current               = "A";
};
EmbeddedOSSupportHost = {
  pname                 = "EmbeddedOSSupportHost";
  frameworkPath         = "System/Library/PrivateFrameworks/EmbeddedOSSupportHost.framework";
  Current               = "A";
};
EmojiFoundation = {
  pname                 = "EmojiFoundation";
  frameworkPath         = "System/Library/PrivateFrameworks/EmojiFoundation.framework";
  Current               = "A";
};
EventKit = {
  pname                 = "EventKit";
  frameworkPath         = "System/Library/Frameworks/EventKit.framework";
  Current               = "A";
  propagatedBuildInputs = [ AddressBook CoreGraphics CoreLocation Foundation ];
};
ExceptionHandling = {
  pname                 = "ExceptionHandling";
  frameworkPath         = "System/Library/Frameworks/ExceptionHandling.framework";
  Current               = "A";
  propagatedBuildInputs = [ Foundation ];
};
FMCore = {
  pname                 = "FMCore";
  frameworkPath         = "System/Library/PrivateFrameworks/FMCore.framework";
  Current               = "A";
};
FMCoreLite = {
  pname                 = "FMCoreLite";
  frameworkPath         = "System/Library/PrivateFrameworks/FMCoreLite.framework";
  Current               = "A";
};
FMCoreUI = {
  pname                 = "FMCoreUI";
  frameworkPath         = "System/Library/PrivateFrameworks/FMCoreUI.framework";
  Current               = "A";
};
FMF = {
  pname                 = "FMF";
  frameworkPath         = "System/Library/PrivateFrameworks/FMF.framework";
  Current               = "A";
};
FMFUI = {
  pname                 = "FMFUI";
  frameworkPath         = "System/Library/PrivateFrameworks/FMFUI.framework";
  Current               = "A";
};
FSEvents = {
  pname                 = "FSEvents";
  frameworkPath         = "System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/FSEvents.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation ];
};
FWAUserLib = {
  pname                 = "FWAUserLib";
  frameworkPath         = "System/Library/Frameworks/FWAUserLib.framework";
  Current               = "A";
};
FindMyDevice = {
  pname                 = "FindMyDevice";
  frameworkPath         = "System/Library/PrivateFrameworks/FindMyDevice.framework";
  Current               = "A";
};
FinderSync = {
  pname                 = "FinderSync";
  frameworkPath         = "System/Library/Frameworks/FinderSync.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit Foundation ];
};
ForceFeedback = {
  pname                 = "ForceFeedback";
  frameworkPath         = "System/Library/Frameworks/ForceFeedback.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation IOKit ];
};
Foundation = {
  pname                 = "Foundation";
  frameworkPath         = "System/Library/Frameworks/Foundation.framework";
  Current               = "C";
  propagatedBuildInputs = [ ApplicationServices CFNetwork CoreFoundation CoreGraphics CoreServices Security objc ];
};
GLKit = {
  pname                 = "GLKit";
  frameworkPath         = "System/Library/Frameworks/GLKit.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit CoreFoundation CoreGraphics Foundation ModelIO OpenGL OpenGLES ];
};
GLUT = {
  pname                 = "GLUT";
  frameworkPath         = "System/Library/Frameworks/GLUT.framework";
  Current               = "A";
  propagatedBuildInputs = [ GL OpenGL gl ];
};
GSS = {
  pname                 = "GSS";
  frameworkPath         = "System/Library/Frameworks/GSS.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation ];
};
GameController = {
  pname                 = "GameController";
  frameworkPath         = "System/Library/Frameworks/GameController.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit Foundation UIKit ];
};
GameKit = {
  pname                 = "GameKit";
  frameworkPath         = "System/Library/Frameworks/GameKit.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit Cocoa Foundation GameController GameplayKit Metal MetalKit ModelIO SceneKit SpriteKit UIKit simd ];
};
GameplayKit = {
  pname                 = "GameplayKit";
  frameworkPath         = "System/Library/Frameworks/GameplayKit.framework";
  Current               = "A";
  propagatedBuildInputs = [ Foundation SpriteKit simd ];
};
HIServices = {
  pname                 = "HIServices";
  frameworkPath         = "System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/HIServices.framework";
  Current               = "A";
  propagatedBuildInputs = [ AE ApplicationServices CoreFoundation CoreGraphics CoreServices QD ];
};
HIToolbox = {
  pname                 = "HIToolbox";
  frameworkPath         = "System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/HIToolbox.framework";
  Current               = "A";
  propagatedBuildInputs = [ ApplicationServices CoreFoundation CoreServices Foundation ];
};
HTTPServer = {
  pname                 = "HTTPServer";
  frameworkPath         = "System/Library/PrivateFrameworks/HTTPServer.framework";
  Current               = "A";
};
Help = {
  pname                 = "Help";
  frameworkPath         = "System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/Help.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreServices ];
};
Hypervisor = {
  pname                 = "Hypervisor";
  frameworkPath         = "System/Library/Frameworks/Hypervisor.framework";
  Current               = "A";
};
ICADevices = {
  pname                 = "ICADevices";
  frameworkPath         = "System/Library/Frameworks/ICADevices.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation CoreGraphics CoreServices IOBluetooth IOKit ];
};
IMServicePlugIn = {
  pname                 = "IMServicePlugIn";
  frameworkPath         = "System/Library/Frameworks/IMServicePlugIn.framework";
  Current               = "A";
  propagatedBuildInputs = [ Foundation ];
};
IMSharedUI = {
  pname                 = "IMSharedUI";
  frameworkPath         = "System/Library/PrivateFrameworks/IMSharedUI.framework";
  Current               = "A";
};
IOBluetooth = {
  pname                 = "IOBluetooth";
  frameworkPath         = "System/Library/Frameworks/IOBluetooth.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreServices IOKit ];
};
IOBluetoothUI = {
  pname                 = "IOBluetoothUI";
  frameworkPath         = "System/Library/Frameworks/IOBluetoothUI.framework";
  Current               = "A";
  propagatedBuildInputs = [ IOBluetooth ];
};
IOKit = {
  pname                 = "IOKit";
  frameworkPath         = "System/Library/Frameworks/IOKit.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation device ];
};
IOSurface = {
  pname                 = "IOSurface";
  frameworkPath         = "System/Library/Frameworks/IOSurface.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation Foundation IOKit xpc ];
};
ImageCapture = {
  pname                 = "ImageCapture";
  frameworkPath         = "System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/ImageCapture.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreServices IOKit ];
};
ImageCaptureCore = {
  pname                 = "ImageCaptureCore";
  frameworkPath         = "System/Library/Frameworks/ImageCaptureCore.framework";
  Current               = "A";
  propagatedBuildInputs = [ Foundation ];
};
ImageIO = {
  pname                 = "ImageIO";
  frameworkPath         = "System/Library/Frameworks/ImageIO.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation CoreGraphics ];
};
ImageKit = {
  pname                 = "ImageKit";
  frameworkPath         = "System/Library/Frameworks/Quartz.framework/Versions/A/Frameworks/ImageKit.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit ApplicationServices Cocoa Foundation ImageCaptureCore QuartzCore ];
};
Ink = {
  pname                 = "Ink";
  frameworkPath         = "System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/Ink.framework";
  Current               = "A";
  propagatedBuildInputs = [ ApplicationServices HIToolbox ];
};
InputMethodKit = {
  pname                 = "InputMethodKit";
  frameworkPath         = "System/Library/Frameworks/InputMethodKit.framework";
  Current               = "A";
  propagatedBuildInputs = [ Carbon Cocoa Foundation ];
};
InstallerDiagnostics = {
  pname                 = "InstallerDiagnostics";
  frameworkPath         = "System/Library/PrivateFrameworks/InstallerDiagnostics.framework";
  Current               = "A";
};
InstallerPlugins = {
  pname                 = "InstallerPlugins";
  frameworkPath         = "System/Library/Frameworks/InstallerPlugins.framework";
  Current               = "A";
  propagatedBuildInputs = [ Cocoa Foundation ];
};
InstantMessage = {
  pname                 = "InstantMessage";
  frameworkPath         = "System/Library/Frameworks/InstantMessage.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreVideo Foundation ];
};
Intents = {
  pname                 = "Intents";
  frameworkPath         = "System/Library/Frameworks/Intents.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreLocation Foundation ];
};
IntentsCore = {
  pname                 = "IntentsCore";
  frameworkPath         = "System/Library/PrivateFrameworks/IntentsCore.framework";
  Current               = "A";
};
IntentsFoundation = {
  pname                 = "IntentsFoundation";
  frameworkPath         = "System/Library/PrivateFrameworks/IntentsFoundation.framework";
  Current               = "A";
};
JavaFrameEmbedding = {
  pname                 = "JavaFrameEmbedding";
  frameworkPath         = "System/Library/Frameworks/JavaFrameEmbedding.framework";
  Current               = "A";
  propagatedBuildInputs = [ Cocoa JavaVM ];
};
JavaNativeFoundation = {
  pname                 = "JavaNativeFoundation";
  frameworkPath         = "System/Library/Frameworks/JavaVM.framework/Versions/A/Frameworks/JavaNativeFoundation.framework";
  Current               = "A";
  propagatedBuildInputs = [ Foundation JavaVM ];
};
JavaRuntimeSupport = {
  pname                 = "JavaRuntimeSupport";
  frameworkPath         = "System/Library/Frameworks/JavaVM.framework/Versions/A/Frameworks/JavaRuntimeSupport.framework";
  Current               = "A";
  propagatedBuildInputs = [ ApplicationServices Cocoa Foundation JavaVM QuartzCore ];
};
JavaScriptCore = {
  pname                 = "JavaScriptCore";
  frameworkPath         = "System/Library/Frameworks/JavaScriptCore.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation CoreGraphics Foundation ];
};
JavaVM = {
  pname                 = "JavaVM";
  frameworkPath         = "System/Library/Frameworks/JavaVM.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit Foundation QuartzCore ];
};
Kerberos = {
  pname                 = "Kerberos";
  frameworkPath         = "System/Library/Frameworks/Kerberos.framework";
  Current               = "A";
};
Kernel = {
  pname                 = "Kernel";
  frameworkPath         = "System/Library/Frameworks/Kernel.framework";
  Current               = "A";
  propagatedBuildInputs = [ machine ];
};
KeyboardServices = {
  pname                 = "KeyboardServices";
  frameworkPath         = "System/Library/PrivateFrameworks/KeyboardServices.framework";
  Current               = "A";
};
KeychainCircle = {
  pname                 = "KeychainCircle";
  frameworkPath         = "System/Library/PrivateFrameworks/KeychainCircle.framework";
  Current               = "A";
};
KnowledgeGraphKit = {
  pname                 = "KnowledgeGraphKit";
  frameworkPath         = "System/Library/PrivateFrameworks/PhotoAnalysis.framework/Versions/A/Frameworks/PhotosGraph.framework/Versions/A/Frameworks/KnowledgeGraphKit.framework";
  Current               = "A";
};
LDAP = {
  pname                 = "LDAP";
  frameworkPath         = "System/Library/Frameworks/LDAP.framework";
  Current               = "A";
};
LangAnalysis = {
  pname                 = "LangAnalysis";
  frameworkPath         = "System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/LangAnalysis.framework";
  Current               = "A";
  propagatedBuildInputs = [ AE CoreServices ];
};
LatentSemanticMapping = {
  pname                 = "LatentSemanticMapping";
  frameworkPath         = "System/Library/Frameworks/LatentSemanticMapping.framework";
  Current               = "A";
  propagatedBuildInputs = [ Carbon CoreFoundation ];
};
LaunchServices = {
  pname                 = "LaunchServices";
  frameworkPath         = "System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework";
  Current               = "A";
  propagatedBuildInputs = [ AE CarbonCore CoreFoundation OSServices ];
};
LinkPresentation = {
  pname                 = "LinkPresentation";
  frameworkPath         = "System/Library/PrivateFrameworks/LinkPresentation.framework";
  Current               = "A";
};
LocalAuthentication = {
  pname                 = "LocalAuthentication";
  frameworkPath         = "System/Library/Frameworks/LocalAuthentication.framework";
  Current               = "A";
  propagatedBuildInputs = [ Foundation ];
};
MailSupport = {
  pname                 = "MailSupport";
  frameworkPath         = "System/Library/PrivateFrameworks/MailSupport.framework";
  Current               = "A";
};
MapKit = {
  pname                 = "MapKit";
  frameworkPath         = "System/Library/Frameworks/MapKit.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit CoreGraphics CoreLocation Foundation UIKit ];
};
MarkupUI = {
  pname                 = "MarkupUI";
  frameworkPath         = "System/Library/PrivateFrameworks/MarkupUI.framework";
  Current               = "A";
};
MediaAccessibility = {
  pname                 = "MediaAccessibility";
  frameworkPath         = "System/Library/Frameworks/MediaAccessibility.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation CoreGraphics CoreText QuartzCore ];
};
MediaLibrary = {
  pname                 = "MediaLibrary";
  frameworkPath         = "System/Library/Frameworks/MediaLibrary.framework";
  Current               = "A";
  propagatedBuildInputs = [ Foundation ];
};
MediaMiningKit = {
  pname                 = "MediaMiningKit";
  frameworkPath         = "System/Library/PrivateFrameworks/PhotoAnalysis.framework/Versions/A/Frameworks/PhotosGraph.framework/Versions/A/Frameworks/MediaMiningKit.framework";
  Current               = "A";
};
MediaPlayer = {
  pname                 = "MediaPlayer";
  frameworkPath         = "System/Library/Frameworks/MediaPlayer.framework";
  Current               = "A";
  propagatedBuildInputs = [ AVFoundation CoreGraphics Foundation ];
};
MediaToolbox = {
  pname                 = "MediaToolbox";
  frameworkPath         = "System/Library/Frameworks/MediaToolbox.framework";
  Current               = "A";
  propagatedBuildInputs = [ AudioToolbox CoreFoundation CoreMedia ];
};
Metadata = {
  pname                 = "Metadata";
  frameworkPath         = "System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/Metadata.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation ];
};
Metal = {
  pname                 = "Metal";
  frameworkPath         = "System/Library/Frameworks/Metal.framework";
  Current               = "A";
  propagatedBuildInputs = [ Foundation IOSurface ];
};
MetalKit = {
  pname                 = "MetalKit";
  frameworkPath         = "System/Library/Frameworks/MetalKit.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit CoreGraphics Foundation Metal ModelIO QuartzCore simd ];
};
MobileKeyBag = {
  pname                 = "MobileKeyBag";
  frameworkPath         = "System/Library/PrivateFrameworks/MobileKeyBag.framework";
  Current               = "A";
};
ModelIO = {
  pname                 = "ModelIO";
  frameworkPath         = "System/Library/Frameworks/ModelIO.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreGraphics Foundation simd ];
};
MultipeerConnectivity = {
  pname                 = "MultipeerConnectivity";
  frameworkPath         = "System/Library/Frameworks/MultipeerConnectivity.framework";
  Current               = "A";
  propagatedBuildInputs = [ Cocoa Foundation ];
};
NavigationServices = {
  pname                 = "NavigationServices";
  frameworkPath         = "System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/NavigationServices.framework";
  Current               = "A";
  propagatedBuildInputs = [ ApplicationServices HIToolbox ];
};
NetFS = {
  pname                 = "NetFS";
  frameworkPath         = "System/Library/Frameworks/NetFS.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation ];
};
NetworkExtension = {
  pname                 = "NetworkExtension";
  frameworkPath         = "System/Library/Frameworks/NetworkExtension.framework";
  Current               = "A";
  propagatedBuildInputs = [ Foundation Security netinet ];
};
NotificationCenter = {
  pname                 = "NotificationCenter";
  frameworkPath         = "System/Library/Frameworks/NotificationCenter.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit Foundation ];
};
OSAKit = {
  pname                 = "OSAKit";
  frameworkPath         = "System/Library/Frameworks/OSAKit.framework";
  Current               = "A";
  propagatedBuildInputs = [ Carbon Cocoa ];
};
OSServices = {
  pname                 = "OSServices";
  frameworkPath         = "System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/OSServices.framework";
  Current               = "A";
  propagatedBuildInputs = [ CarbonCore CoreFoundation MobileCoreServices Security ];
};
OpenAL = {
  pname                 = "OpenAL";
  frameworkPath         = "System/Library/Frameworks/OpenAL.framework";
  Current               = "A";
};
OpenCL = {
  pname                 = "OpenCL";
  frameworkPath         = "System/Library/Frameworks/OpenCL.framework";
  Current               = "A";
  propagatedBuildInputs = [ CL IOSurface OpenGL ];
};
OpenDirectory = {
  pname                 = "OpenDirectory";
  frameworkPath         = "System/Library/Frameworks/OpenDirectory.framework";
  Current               = "A";
  propagatedBuildInputs = [ CFOpenDirectory Foundation ];
};
OpenGL = {
  pname                 = "OpenGL";
  frameworkPath         = "System/Library/Frameworks/OpenGL.framework";
  Current               = "A";
};
OpenScripting = {
  pname                 = "OpenScripting";
  frameworkPath         = "System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/OpenScripting.framework";
  Current               = "A";
  propagatedBuildInputs = [ ApplicationServices CoreServices HIToolbox ];
};
PCSC = {
  pname                 = "PCSC";
  frameworkPath         = "System/Library/Frameworks/PCSC.framework";
  Current               = "A";
};
PDFKit = {
  pname                 = "PDFKit";
  frameworkPath         = "System/Library/Frameworks/Quartz.framework/Versions/A/Frameworks/PDFKit.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit Cocoa ];
};
ParsecSubscriptionServiceSupport = {
  pname                 = "ParsecSubscriptionServiceSupport";
  frameworkPath         = "System/Library/PrivateFrameworks/ParsecSubscriptionServiceSupport.framework";
  Current               = "A";
};
PersonaKit = {
  pname                 = "PersonaKit";
  frameworkPath         = "System/Library/PrivateFrameworks/PersonaKit.framework";
  Current               = "A";
};
PersonaUI = {
  pname                 = "PersonaUI";
  frameworkPath         = "System/Library/PrivateFrameworks/PersonaUI.framework";
  Current               = "A";
};
PhotoAnalysis = {
  pname                 = "PhotoAnalysis";
  frameworkPath         = "System/Library/PrivateFrameworks/PhotoAnalysis.framework";
  Current               = "A";
};
PhotoVision = {
  pname                 = "PhotoVision";
  frameworkPath         = "System/Library/PrivateFrameworks/PhotoAnalysis.framework/Versions/A/Frameworks/PhotoVision.framework";
  Current               = "A";
};
Photos = {
  pname                 = "Photos";
  frameworkPath         = "System/Library/Frameworks/Photos.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreImage CoreMedia Foundation ];
};
PhotosGraph = {
  pname                 = "PhotosGraph";
  frameworkPath         = "System/Library/PrivateFrameworks/PhotoAnalysis.framework/Versions/A/Frameworks/PhotosGraph.framework";
  Current               = "A";
  reexports             = [ /System/Library/PrivateFrameworks/PhotoAnalysis.framework/Versions/A/Frameworks/PhotosGraph.framework/Versions/A/Frameworks/KnowledgeGraphKit.framework/Versions/A/KnowledgeGraphKit /System/Library/PrivateFrameworks/PhotoAnalysis.framework/Versions/A/Frameworks/PhotosGraph.framework/Versions/A/Frameworks/MediaMiningKit.framework/Versions/A/MediaMiningKit /System/Library/PrivateFrameworks/PhotoAnalysis.framework/Versions/A/Frameworks/PhotosGraph.framework/Versions/A/Frameworks/PipelineKit.framework/Versions/A/PipelineKit ];
};
PhotosUI = {
  pname                 = "PhotosUI";
  frameworkPath         = "System/Library/Frameworks/PhotosUI.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit Foundation Photos ];
};
PhotosUICore = {
  pname                 = "PhotosUICore";
  frameworkPath         = "System/Library/PrivateFrameworks/PhotosUICore.framework";
  Current               = "A";
};
PipelineKit = {
  pname                 = "PipelineKit";
  frameworkPath         = "System/Library/PrivateFrameworks/PhotoAnalysis.framework/Versions/A/Frameworks/PhotosGraph.framework/Versions/A/Frameworks/PipelineKit.framework";
  Current               = "A";
};
PlacesKit = {
  pname                 = "PlacesKit";
  frameworkPath         = "System/Library/PrivateFrameworks/PlacesKit.framework";
  Current               = "A";
};
PreferencePanes = {
  pname                 = "PreferencePanes";
  frameworkPath         = "System/Library/Frameworks/PreferencePanes.framework";
  Current               = "A";
  propagatedBuildInputs = [ Cocoa ];
};
Print = {
  pname                 = "Print";
  frameworkPath         = "System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/Print.framework";
  Current               = "A";
  propagatedBuildInputs = [ ApplicationServices HIToolbox ];
};
PrintCore = {
  pname                 = "PrintCore";
  frameworkPath         = "System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/PrintCore.framework";
  Current               = "A";
  propagatedBuildInputs = [ ColorSync CoreFoundation CoreGraphics CoreServices cups ];
};
ProactiveEventTracker = {
  pname                 = "ProactiveEventTracker";
  frameworkPath         = "System/Library/PrivateFrameworks/ProactiveEventTracker.framework";
  Current               = "A";
};
ProactiveML = {
  pname                 = "ProactiveML";
  frameworkPath         = "System/Library/PrivateFrameworks/ProactiveML.framework";
  Current               = "A";
};
ProactiveSupport = {
  pname                 = "ProactiveSupport";
  frameworkPath         = "System/Library/PrivateFrameworks/ProactiveSupport.framework";
  Current               = "A";
};
ProactiveSupportStubs = {
  pname                 = "ProactiveSupportStubs";
  frameworkPath         = "System/Library/PrivateFrameworks/ProactiveSupportStubs.framework";
  Current               = "A";
};
PubSub = {
  pname                 = "PubSub";
  frameworkPath         = "System/Library/Frameworks/PubSub.framework";
  Current               = "A";
  propagatedBuildInputs = [ Foundation ];
};
Python = {
  pname                 = "Python";
  frameworkPath         = "System/Library/Frameworks/Python.framework";
};
QD = {
  pname                 = "QD";
  frameworkPath         = "System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/QD.framework";
  Current               = "A";
  propagatedBuildInputs = [ AE ATS CarbonCore CoreGraphics CoreServices ];
};
QTKit = {
  pname                 = "QTKit";
  frameworkPath         = "System/Library/Frameworks/QTKit.framework";
  Current               = "A";
  propagatedBuildInputs = [ Foundation ];
};
Quartz = {
  pname                 = "Quartz";
  frameworkPath         = "System/Library/Frameworks/Quartz.framework";
  Current               = "A";
  propagatedBuildInputs = [ ImageKit PDFKit QuartzComposer QuartzCore QuartzFilters QuickLookUI ];
};
QuartzComposer = {
  pname                 = "QuartzComposer";
  frameworkPath         = "System/Library/Frameworks/Quartz.framework/Versions/A/Frameworks/QuartzComposer.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit ApplicationServices Foundation OpenGL QuartzCore ];
};
QuartzCore = {
  pname                 = "QuartzCore";
  frameworkPath         = "System/Library/Frameworks/QuartzCore.framework";
  Current               = "A";
  propagatedBuildInputs = [ ApplicationServices CoreFoundation CoreImage CoreVideo Foundation Metal OpenGL objc ];
  reexports             = [ /System/Library/Frameworks/CoreImage.framework/Versions/A/CoreImage /System/Library/Frameworks/CoreVideo.framework/Versions/A/CoreVideo /usr/lib/libobjc.A.dylib ];
};
QuartzFilters = {
  pname                 = "QuartzFilters";
  frameworkPath         = "System/Library/Frameworks/Quartz.framework/Versions/A/Frameworks/QuartzFilters.framework";
  Current               = "A";
  propagatedBuildInputs = [ Cocoa ];
};
QuickLook = {
  pname                 = "QuickLook";
  frameworkPath         = "System/Library/Frameworks/QuickLook.framework";
  Current               = "A";
  propagatedBuildInputs = [ ApplicationServices CoreFoundation ];
};
QuickLookUI = {
  pname                 = "QuickLookUI";
  frameworkPath         = "System/Library/Frameworks/Quartz.framework/Versions/A/Frameworks/QuickLookUI.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit Foundation QuickLook ];
};
QuickTime = {
  pname                 = "QuickTime";
  frameworkPath         = "System/Library/Frameworks/QuickTime.framework";
  Current               = "A";
};
Rapport = {
  pname                 = "Rapport";
  frameworkPath         = "System/Library/PrivateFrameworks/Rapport.framework";
  Current               = "A";
};
RapportUI = {
  pname                 = "RapportUI";
  frameworkPath         = "System/Library/PrivateFrameworks/RapportUI.framework";
  Current               = "A";
};
Ruby = {
  pname                 = "Ruby";
  frameworkPath         = "System/Library/Frameworks/Ruby.framework";
  Current               = "2.0";
};
SafariServices = {
  pname                 = "SafariServices";
  frameworkPath         = "System/Library/Frameworks/SafariServices.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit Foundation ];
};
SceneKit = {
  pname                 = "SceneKit";
  frameworkPath         = "System/Library/Frameworks/SceneKit.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit CoreGraphics Foundation GLKit Metal ModelIO QuartzCore simd ];
};
ScreenSaver = {
  pname                 = "ScreenSaver";
  frameworkPath         = "System/Library/Frameworks/ScreenSaver.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit Foundation ];
};
Scripting = {
  pname                 = "Scripting";
  frameworkPath         = "System/Library/Frameworks/Scripting.framework";
  Current               = "A";
  propagatedBuildInputs = [ Foundation ];
};
ScriptingBridge = {
  pname                 = "ScriptingBridge";
  frameworkPath         = "System/Library/Frameworks/ScriptingBridge.framework";
  Current               = "A";
  propagatedBuildInputs = [ ApplicationServices CoreServices Foundation ];
};
SearchFoundation = {
  pname                 = "SearchFoundation";
  frameworkPath         = "System/Library/PrivateFrameworks/SearchFoundation.framework";
  Current               = "A";
};
SearchKit = {
  pname                 = "SearchKit";
  frameworkPath         = "System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/SearchKit.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation ];
};
Security = {
  pname                 = "Security";
  frameworkPath         = "System/Library/Frameworks/Security.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation libDER ];
};
SecurityFoundation = {
  pname                 = "SecurityFoundation";
  frameworkPath         = "System/Library/Frameworks/SecurityFoundation.framework";
  Current               = "A";
  propagatedBuildInputs = [ Foundation Security ];
};
SecurityHI = {
  pname                 = "SecurityHI";
  frameworkPath         = "System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/SecurityHI.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreServices HIToolbox Security ];
};
SecurityInterface = {
  pname                 = "SecurityInterface";
  frameworkPath         = "System/Library/Frameworks/SecurityInterface.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit Cocoa Security SecurityFoundation ];
};
Seeding = {
  pname                 = "Seeding";
  frameworkPath         = "System/Library/PrivateFrameworks/Seeding.framework";
  Current               = "A";
};
ServiceManagement = {
  pname                 = "ServiceManagement";
  frameworkPath         = "System/Library/Frameworks/ServiceManagement.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation Security xpc ];
};
SharedFileList = {
  pname                 = "SharedFileList";
  frameworkPath         = "System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/SharedFileList.framework";
  Current               = "A";
  propagatedBuildInputs = [ CarbonCore CoreFoundation LaunchServices Security ];
};
Social = {
  pname                 = "Social";
  frameworkPath         = "System/Library/Frameworks/Social.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit Foundation UIKit ];
};
Speech = {
  pname                 = "Speech";
  frameworkPath         = "System/Library/PrivateFrameworks/Speech.framework";
  Current               = "A";
};
SpeechRecognition = {
  pname                 = "SpeechRecognition";
  frameworkPath         = "System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/SpeechRecognition.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreServices ];
};
SpeechSynthesis = {
  pname                 = "SpeechSynthesis";
  frameworkPath         = "System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/SpeechSynthesis.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation CoreServices ];
};
SpriteKit = {
  pname                 = "SpriteKit";
  frameworkPath         = "System/Library/Frameworks/SpriteKit.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit Cocoa CoreGraphics Foundation GLKit UIKit simd ];
};
StoreKit = {
  pname                 = "StoreKit";
  frameworkPath         = "System/Library/Frameworks/StoreKit.framework";
  Current               = "A";
  propagatedBuildInputs = [ Foundation ];
};
SyncServices = {
  pname                 = "SyncServices";
  frameworkPath         = "System/Library/Frameworks/SyncServices.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreData Foundation ];
};
SystemConfiguration = {
  pname                 = "SystemConfiguration";
  frameworkPath         = "System/Library/Frameworks/SystemConfiguration.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation Security ];
};
TWAIN = {
  pname                 = "TWAIN";
  frameworkPath         = "System/Library/Frameworks/TWAIN.framework";
  Current               = "A";
};
Tcl = {
  pname                 = "Tcl";
  frameworkPath         = "System/Library/Frameworks/Tcl.framework";
  Current               = "8.5";
  propagatedBuildInputs = [ arpa netinet ];
};
TextInput = {
  pname                 = "TextInput";
  frameworkPath         = "System/Library/PrivateFrameworks/TextInput.framework";
  Current               = "A";
};
TextureIO = {
  pname                 = "TextureIO";
  frameworkPath         = "System/Library/PrivateFrameworks/TextureIO.framework";
  Current               = "A";
};
TimeSync = {
  pname                 = "TimeSync";
  frameworkPath         = "System/Library/PrivateFrameworks/TimeSync.framework";
  Current               = "A";
};
Tk = {
  pname                 = "Tk";
  frameworkPath         = "System/Library/Frameworks/Tk.framework";
  Current               = "8.5";
  propagatedBuildInputs = [ X11 ];
};
VideoDecodeAcceleration = {
  pname                 = "VideoDecodeAcceleration";
  frameworkPath         = "System/Library/Frameworks/VideoDecodeAcceleration.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation CoreVideo ];
};
VideoSubscriberAccount = {
  pname                 = "VideoSubscriberAccount";
  frameworkPath         = "System/Library/PrivateFrameworks/VideoSubscriberAccount.framework";
  Current               = "A";
};
VideoToolbox = {
  pname                 = "VideoToolbox";
  frameworkPath         = "System/Library/Frameworks/VideoToolbox.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation CoreGraphics CoreMedia CoreVideo ];
};
WebKit = {
  pname                 = "WebKit";
  frameworkPath         = "System/Library/Frameworks/WebKit.framework";
  Current               = "A";
  propagatedBuildInputs = [ AppKit ApplicationServices Carbon CoreGraphics Foundation JavaScriptCore OpenGL UIKit X11 ];
};
XcodeExtension = {
  pname                 = "XcodeExtension";
  frameworkPath         = "System/Library/PrivateFrameworks/XcodeExtension.framework";
  Current               = "A";
};
vImage = {
  pname                 = "vImage";
  frameworkPath         = "System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vImage.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreGraphics CoreVideo ];
};
vecLib = {
  pname                 = "vecLib";
  frameworkPath         = "System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework";
  Current               = "A";
  propagatedBuildInputs = [ CoreFoundation ];
};
vecLib = {
  pname                 = "vecLib";
  frameworkPath         = "System/Library/Frameworks/vecLib.framework";
  Current               = "A";
};
vmnet = {
  pname                 = "vmnet";
  frameworkPath         = "System/Library/Frameworks/vmnet.framework";
  Current               = "A";
  propagatedBuildInputs = [ xpc ];
};
}
