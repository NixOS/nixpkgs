{ lib, stdenvNoCC, buildPackages, fetchurl, xar, cpio, pkgs, python3, pbzx, MacOSX-SDK }:

# TODO: reorganize to make this just frameworks, and move libs to default.nix

let
  stdenv = stdenvNoCC;

  standardFrameworkPath = name: private:
    "/System/Library/${lib.optionalString private "Private"}Frameworks/${name}.framework";

  mkDepsRewrites = deps:
  let
    mergeRewrites = x: y: {
      prefix = lib.mergeAttrs (x.prefix or {}) (y.prefix or {});
      const = lib.mergeAttrs (x.const or {}) (y.const or {});
    };

    rewriteArgs = { prefix ? {}, const ? {} }: lib.concatLists (
      (lib.mapAttrsToList (from: to: [ "-p" "${from}:${to}" ]) prefix) ++
      (lib.mapAttrsToList (from: to: [ "-c" "${from}:${to}" ]) const)
    );

    rewrites = depList: lib.fold mergeRewrites {}
      (map (dep: dep.tbdRewrites)
        (lib.filter (dep: dep ? tbdRewrites) depList));
  in
    lib.escapeShellArgs (rewriteArgs (rewrites (builtins.attrValues deps)));

  mkFramework = { name, deps, private ? false }:
    let self = stdenv.mkDerivation {
      pname = "apple-${lib.optionalString private "private-"}framework-${name}";
      version = MacOSX-SDK.version;

      dontUnpack = true;

      # because we copy files from the system
      preferLocalBuild = true;

      disallowedRequisites = [ MacOSX-SDK ];

      nativeBuildInputs = [ buildPackages.darwin.rewrite-tbd ];

      installPhase = ''
        mkdir -p $out/Library/Frameworks

        cp -r ${MacOSX-SDK}${standardFrameworkPath name private} $out/Library/Frameworks

        if [[ -d ${MacOSX-SDK}/usr/lib/swift/${name}.swiftmodule ]]; then
          mkdir -p $out/lib/swift
          cp -r -t $out/lib/swift \
            ${MacOSX-SDK}/usr/lib/swift/${name}.swiftmodule \
            ${MacOSX-SDK}/usr/lib/swift/libswift${name}.tbd
        fi

        # Fix and check tbd re-export references
        chmod u+w -R $out
        find $out -name '*.tbd' -type f | while read tbd; do
          echo "Fixing re-exports in $tbd"
          rewrite-tbd \
            -p ${standardFrameworkPath name private}/:$out/Library/Frameworks/${name}.framework/ \
            -p /usr/lib/swift/:$out/lib/swift/ \
            ${mkDepsRewrites deps} \
            -r ${builtins.storeDir} \
            "$tbd"
        done
      '';

      propagatedBuildInputs = builtins.attrValues deps;

      passthru = {
        tbdRewrites = {
          prefix."${standardFrameworkPath name private}/" = "${self}/Library/Frameworks/${name}.framework/";
        };
      };

      meta = with lib; {
        description = "Apple SDK framework ${name}";
        maintainers = with maintainers; [ copumpkin ];
        platforms   = platforms.darwin;
      };
    };
  in self;

  framework = name: deps: mkFramework { inherit name deps; private = false; };
  privateFramework = name: deps: mkFramework { inherit name deps; private = true; };
in rec {
  libs = {
    xpc = stdenv.mkDerivation {
      name   = "apple-lib-xpc";
      dontUnpack = true;

      installPhase = ''
        mkdir -p $out/include
        pushd $out/include >/dev/null
        cp -r "${MacOSX-SDK}/usr/include/xpc" $out/include/xpc
        cp "${MacOSX-SDK}/usr/include/launch.h" $out/include/launch.h
        popd >/dev/null
      '';
    };

    Xplugin = stdenv.mkDerivation {
      name   = "apple-lib-Xplugin";
      dontUnpack = true;

      propagatedBuildInputs = with frameworks; [
        OpenGL ApplicationServices Carbon IOKit CoreGraphics CoreServices CoreText
      ];

      installPhase = ''
        mkdir -p $out/include $out/lib
        ln -s "${MacOSX-SDK}/include/Xplugin.h" $out/include/Xplugin.h
        cp ${MacOSX-SDK}/usr/lib/libXplugin.1.tbd $out/lib
        ln -s libXplugin.1.tbd $out/lib/libXplugin.tbd
      '';
    };

    utmp = stdenv.mkDerivation {
      name   = "apple-lib-utmp";
      dontUnpack = true;

      installPhase = ''
        mkdir -p $out/include
        pushd $out/include >/dev/null
        ln -s "${MacOSX-SDK}/include/utmp.h"
        ln -s "${MacOSX-SDK}/include/utmpx.h"
        popd >/dev/null
      '';
    };

    sandbox = stdenv.mkDerivation {
      name = "apple-lib-sandbox";

      dontUnpack = true;
      dontBuild = true;

      installPhase = ''
        mkdir -p $out/include $out/lib
        ln -s "${MacOSX-SDK}/usr/include/sandbox.h" $out/include/sandbox.h
        cp "${MacOSX-SDK}/usr/lib/libsandbox.1.tbd" $out/lib
        ln -s libsandbox.1.tbd $out/lib/libsandbox.tbd
      '';
    };

    libDER = stdenv.mkDerivation {
      name = "apple-lib-libDER";
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/include
        cp -r ${MacOSX-SDK}/usr/include/libDER $out/include
      '';
    };

    simd = stdenv.mkDerivation {
      name = "apple-lib-simd";
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/include
        cp -r ${MacOSX-SDK}/usr/include/simd $out/include
      '';
    };
  };

  frameworks = let
    # Dependency map created by gen-frameworks.py.
    generatedDeps = import ./frameworks.nix {
      inherit frameworks libs;
    };

    # Additional dependencies that are not picked up by gen-frameworks.py.
    # Some of these are simply private frameworks the generator does not see.
    extraDeps = with libs; with frameworks; let
      inherit (pkgs.darwin.apple_sdk_11_0) libnetwork;
      libobjc = pkgs.darwin.apple_sdk_11_0.objc4;
    in {
      # Below this comment are entries migrated from before the generator was
      # added. If, for a given framework, you are able to reverify the extra
      # deps are really necessary on top of the generator deps, move it above
      # this comment (and maybe document your findings).
      AVFoundation            = { inherit ApplicationServices AVFCapture AVFCore; };
      Accelerate              = { inherit CoreWLAN IOBluetooth; };
      AddressBook             = { inherit AddressBookCore ContactsPersistence libobjc; };
      AppKit                  = { inherit AudioToolbox AudioUnit UIFoundation; };
      AudioToolbox            = { inherit AudioToolboxCore; };
      AudioUnit               = { inherit Carbon CoreAudio; };
      Carbon                  = { inherit IOKit QuartzCore libobjc; };
      CoreAudio               = { inherit IOKit; };
      CoreFoundation          = { inherit libobjc; };
      CoreGraphics            = { inherit SystemConfiguration; };
      CoreMIDIServer          = { inherit CoreMIDI; };
      CoreMedia               = { inherit ApplicationServices AudioToolbox AudioUnit; };
      CoreServices            = { inherit CoreAudio NetFS ServiceManagement; };
      CoreWLAN                = { inherit SecurityFoundation; };
      DiscRecording           = { inherit IOKit libobjc; };
      Foundation              = { inherit SystemConfiguration libobjc; };
      GameKit                 = { inherit GameCenterFoundation GameCenterUI GameCenterUICore ReplayKit; };
      ICADevices              = { inherit Carbon libobjc; };
      IOBluetooth             = { inherit CoreBluetooth; };
      JavaScriptCore          = { inherit libobjc; };
      Kernel                  = { inherit IOKit; };
      LinkPresentation        = { inherit URLFormatting; };
      MediaToolbox            = { inherit AudioUnit; };
      MetricKit               = { inherit SignpostMetrics; };
      Network                 = { inherit libnetwork; };
      PCSC                    = { inherit CoreData; };
      PassKit                 = { inherit PassKitCore; };
      QTKit                   = { inherit CoreMedia CoreMediaIO MediaToolbox VideoToolbox; };
      Quartz                  = { inherit QTKit; };
      QuartzCore              = { inherit ApplicationServices CoreImage CoreVideo Metal OpenCL libobjc; };
      Security                = { inherit IOKit libDER; };
      TWAIN                   = { inherit Carbon; };
      VideoDecodeAcceleration = { inherit CoreVideo; };
      WebKit                  = { inherit ApplicationServices Carbon libobjc; };
    };

    # Overrides for framework derivations.
    overrides = super: {
      CoreFoundation = lib.overrideDerivation super.CoreFoundation (drv: {
        setupHooks = [
          ../../../build-support/setup-hooks/role.bash
          ./cf-setup-hook.sh
        ];
      });

      # This framework doesn't exist in newer SDKs (somewhere around 10.13), but
      # there are references to it in nixpkgs.
      QuickTime = throw "QuickTime framework not available";

      # Seems to be appropriate given https://developer.apple.com/forums/thread/666686
      JavaVM = super.JavaNativeFoundation;

      CoreVideo = lib.overrideDerivation super.CoreVideo (drv: {
        installPhase = drv.installPhase + ''
          # When used as a module, complains about a missing import for
          # Darwin.C.stdint. Apparently fixed in later SDKs.
          sed -e "/CFBase.h/ i #include <stdint.h>" \
            -i $out/Library/Frameworks/CoreVideo.framework/Headers/CVBase.h
        '';
      });

      System = lib.overrideDerivation super.System (drv: {
        installPhase = drv.installPhase + ''
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

    # Merge extraDeps into generatedDeps.
    deps = generatedDeps // (
      lib.mapAttrs
        (name: deps: generatedDeps.${name} // deps)
        extraDeps
    );

    # Create derivations, and add private frameworks.
    bareFrameworks = (lib.mapAttrs framework deps) // (
      lib.mapAttrs privateFramework (import ./private-frameworks.nix {
        inherit frameworks;
        libobjc = pkgs.darwin.apple_sdk_11_0.objc4;
      })
    );
  in
    # Apply derivation overrides.
    bareFrameworks // overrides bareFrameworks;
}
