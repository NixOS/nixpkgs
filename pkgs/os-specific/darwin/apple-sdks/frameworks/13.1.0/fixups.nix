# TODO(@connorbaker): Copied from 13.3 -- should be regenerated.
{
  cups,
  lib,
  # macOS things
  frameworks,
  libs,
  MacOSX-SDK,
  objc4,
}: {
  # Used to add dependencies which are not picked up by gen-frameworks.py.
  # Some of these are simply private frameworks the generator does not see.
  # Trial and error, building things and adding dependencies when they fail.
  addToFrameworks = let
    libobjc = objc4;
  in
    with frameworks; {
      AppKit = {inherit CollectionViewCore UIFoundation;};
      ApplicationServices = {inherit cups;};
      AudioToolbox = {inherit AudioToolboxCore;};
      CoreFoundation = {inherit libobjc;};
      Foundation = {inherit libobjc;};
      QuartzCore = {inherit CoreImage libobjc;};
      Security = {inherit (libs) libDER;};
    };

  # Used to remove dependencies which are picked up by gen-frameworks.py -- used mainly to break
  # cyclic dependencies.
  removeFromFrameworks = with frameworks; {
    ServiceManagement = {inherit Foundation;};
  };

  # Overrides for framework derivations.
  overrideFrameworks = super: {
    CoreFoundation = lib.overrideDerivation super.CoreFoundation (drv: {
      setupHook = ../scripts/forceLinkCoreFoundationFramework.sh;
    });

    # This framework doesn't exist in newer SDKs (somewhere around 10.13), but
    # there are references to it in nixpkgs.
    QuickTime = throw "QuickTime framework not available";

    # Seems to be appropriate given https://developer.apple.com/forums/thread/666686
    JavaVM = super.JavaNativeFoundation;

    CoreVideo = lib.overrideDerivation super.CoreVideo (drv: {
      installPhase =
        drv.installPhase
        + ''
          # When used as a module, complains about a missing import for
          # Darwin.C.stdint. Apparently fixed in later SDKs.
          awk -i inplace '/CFBase.h/ { print "#include <stdint.h>" } { print }' \
            $out/Library/Frameworks/CoreVideo.framework/Headers/CVBase.h
        '';
    });

    System = lib.overrideDerivation super.System (drv: {
      installPhase =
        drv.installPhase
        + ''
          # Contrarily to the other frameworks, System framework's TBD file
          # is a symlink pointing to ${MacOSX-SDK}/usr/lib/libSystem.B.tbd.
          # This produces an error when installing the framework as:
          #   1. The original file is not copied into the output directory
          #   2. Even if it was copied, the relative path wouldn't match
          # Thus, it is easier to replace the file than to fix the symlink.
          cp --remove-destination ${MacOSX-SDK}/usr/lib/libSystem.B.tbd \
            $out/Library/Frameworks/System.framework/Versions/B/System.tbd
        '';
    });
  };
}
