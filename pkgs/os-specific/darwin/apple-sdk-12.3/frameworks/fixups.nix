{
  lib,
  # macOS things
  frameworks,
  libnetwork,
  libs,
  darwin-stubs,
  objc4,
}:

{
  # Used to add dependencies which are not picked up by gen-frameworks.py.
  # Some of these are simply private frameworks the generator does not see.
  # Trial and error, building things and adding dependencies when they fail.
  addToFrameworks =
    let
      inherit (libs) libDER;
      libobjc = objc4;
    in
    with frameworks;
    {
      # Below this comment are entries migrated from before the generator was
      # added. If, for a given framework, you are able to reverify the extra
      # deps are really necessary on top of the generator deps, move it above
      # this comment (and maybe document your findings).
      AVFoundation = {
        inherit ApplicationServices AVFCapture AVFCore;
      };
      Accelerate = {
        inherit CoreWLAN IOBluetooth;
      };
      AddressBook = {
        inherit AddressBookCore ContactsPersistence libobjc;
      };
      AppKit = {
        inherit AudioToolbox AudioUnit UIFoundation;
      };
      AudioToolbox = {
        inherit AudioToolboxCore;
      };
      AudioUnit = {
        inherit Carbon CoreAudio;
      };
      Carbon = {
        inherit IOKit QuartzCore libobjc;
      };
      CoreAudio = {
        inherit IOKit;
      };
      CoreData = {
        inherit CloudKit;
      };
      CoreFoundation = {
        inherit libobjc;
      };
      CoreGraphics = {
        inherit SystemConfiguration;
      };
      CoreMIDIServer = {
        inherit CoreMIDI;
      };
      CoreMedia = {
        inherit ApplicationServices AudioToolbox AudioUnit;
      };
      CoreServices = {
        inherit CoreAudio NetFS ServiceManagement;
      };
      CoreWLAN = {
        inherit SecurityFoundation;
      };
      DiscRecording = {
        inherit IOKit libobjc;
      };
      Foundation = {
        inherit SystemConfiguration libobjc;
      };
      GameKit = {
        inherit
          GameCenterFoundation
          GameCenterUI
          GameCenterUICore
          ReplayKit
          ;
      };
      ICADevices = {
        inherit Carbon libobjc;
      };
      IOBluetooth = {
        inherit CoreBluetooth;
      };
      JavaScriptCore = {
        inherit libobjc;
      };
      Kernel = {
        inherit IOKit;
      };
      LinkPresentation = {
        inherit URLFormatting;
      };
      MediaToolbox = {
        inherit AudioUnit;
      };
      MetricKit = {
        inherit SignpostMetrics;
      };
      Network = {
        inherit libnetwork;
      };
      PCSC = {
        inherit CoreData;
      };
      PassKit = {
        inherit PassKitCore;
      };
      QTKit = {
        inherit
          CoreMedia
          CoreMediaIO
          MediaToolbox
          VideoToolbox
          ;
      };
      Quartz = {
        inherit QTKit;
      };
      QuartzCore = {
        inherit
          ApplicationServices
          CoreImage
          CoreVideo
          Metal
          OpenCL
          libobjc
          ;
      };
      Security = {
        inherit IOKit libDER;
      };
      TWAIN = {
        inherit Carbon;
      };
      VideoDecodeAcceleration = {
        inherit CoreVideo;
      };
      WebKit = {
        inherit ApplicationServices Carbon libobjc;
      };
    };

  # Used to remove dependencies which are picked up by gen-frameworks.py -- used mainly to break
  # cyclic dependencies.
  removeFromFrameworks = { };

  # Overrides for framework derivations.
  overrideFrameworks = super: {
    # This framework doesn't exist in newer SDKs (somewhere around 10.13), but
    # there are references to it in nixpkgs.
    QuickTime = throw "QuickTime framework not available";

    # Seems to be appropriate given https://developer.apple.com/forums/thread/666686
    JavaVM = super.JavaNativeFoundation;
  };
}
