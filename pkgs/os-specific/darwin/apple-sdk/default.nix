{ stdenv, buildPackages, fetchurl, xar, cpio, pkgs, python3, pbzx, lib, darwin-stubs }:

let
  # sadly needs to be exported because security_tool needs it
  sdk = stdenv.mkDerivation rec {
    pname = "MacOS_SDK";
    version = "10.12";

    # This URL comes from https://swscan.apple.com/content/catalogs/others/index-10.12.merged-1.sucatalog, which we found by:
    #  1. Google: site:swscan.apple.com and look for a name that seems appropriate for your version
    #  2. In the resulting file, search for a file called DevSDK ending in .pkg
    #  3. ???
    #  4. Profit
    src = fetchurl {
      url    = "http://swcdn.apple.com/content/downloads/33/36/041-90419-A_7JJ4H9ZHO2/xs88ob5wjz6riz7g6764twblnvksusg4ps/DevSDK_OSX1012.pkg";
      sha256 = "13xq34sb7383b37hwy076gnhf96prpk1b4087p87xnwswxbrisih";
    };

    nativeBuildInputs = [ xar cpio python3 pbzx ];

    outputs = [ "out" "dev" "man" ];

    unpackPhase = ''
      xar -x -f $src
    '';

    installPhase = ''
      start="$(pwd)"
      mkdir -p $out
      cd $out
      pbzx -n $start/Payload | cpio -idm

      mv usr/* .
      rmdir usr

      mv System/* .
      rmdir System

      pushd lib
      cp ${darwin-stubs}/usr/lib/libcups*.tbd .
      popd
    '';

    meta = with lib; {
      description = "Apple SDK ${version}";
      maintainers = with maintainers; [ copumpkin ];
      platforms   = platforms.darwin;
    };
  };

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

  framework = name: deps: stdenv.mkDerivation (finalAttrs: {
    name = "apple-framework-${name}";

    dontUnpack = true;

    # because we copy files from the system
    preferLocalBuild = true;

    disallowedRequisites = [ sdk ];

    nativeBuildInputs = [ buildPackages.darwin.rewrite-tbd ];

    extraTBDFiles = [];

    installPhase = ''
      linkFramework() {
        local path="$1"
        local nested_path="$1"
        if [ "$path" == "JavaNativeFoundation.framework" ]; then
          local nested_path="JavaVM.framework/Versions/A/Frameworks/JavaNativeFoundation.framework"
        fi
        if [ "$path" == "JavaRuntimeSupport.framework" ]; then
          local nested_path="JavaVM.framework/Versions/A/Frameworks/JavaRuntimeSupport.framework"
        fi
        local name="$(basename "$path" .framework)"
        local current="$(readlink "/System/Library/Frameworks/$nested_path/Versions/Current")"
        if [ -z "$current" ]; then
          current=A
        fi

        local dest="$out/Library/Frameworks/$path"

        mkdir -p "$dest/Versions/$current"
        pushd "$dest/Versions/$current" >/dev/null

        if [ -d "${sdk.out}/Library/Frameworks/$nested_path/Versions/$current/Headers" ]; then
          cp -R "${sdk.out}/Library/Frameworks/$nested_path/Versions/$current/Headers" .
        elif [ -d "${sdk.out}/Library/Frameworks/$name.framework/Versions/$current/Headers" ]; then
          current="$(readlink "/System/Library/Frameworks/$name.framework/Versions/Current")"
          cp -R "${sdk.out}/Library/Frameworks/$name.framework/Versions/$current/Headers" .
        fi

        local tbd_source=${darwin-stubs}/System/Library/Frameworks/$nested_path/Versions/$current
        if [ "${name}" != "Kernel" ]; then
          # The Kernel.framework has headers but no actual library component.
          cp -v $tbd_source/*.tbd .
        fi

        if [ -d "$tbd_source/Libraries" ]; then
          mkdir Libraries
          cp -v $tbd_source/Libraries/*.tbd Libraries/
        fi

        ln -s -L "/System/Library/Frameworks/$nested_path/Versions/$current/Resources"

        if [ -f "/System/Library/Frameworks/$nested_path/module.map" ]; then
          ln -s "/System/Library/Frameworks/$nested_path/module.map"
        fi

        pushd "${sdk.out}/Library/Frameworks/$nested_path/Versions/$current" >/dev/null
        local children=$(echo Frameworks/*.framework)
        popd >/dev/null

        for child in $children; do
          childpath="$path/Versions/$current/$child"
          linkFramework "$childpath"
        done

        pushd ../.. >/dev/null
        ln -s "$current" Versions/Current
        ln -s Versions/Current/* .
        popd >/dev/null

        popd >/dev/null
      }

      linkFramework "${name}.framework"

      # linkFramework is recursive, the rest of the processing is not.

      local tbd_source=${darwin-stubs}/System/Library/Frameworks/${name}.framework
      for tbd in $extraTBDFiles; do
        local tbd_dest_dir=$out/Library/Frameworks/${name}.framework/$(dirname "$tbd")
        mkdir -p "$tbd_dest_dir"
        cp -v "$tbd_source/$tbd" "$tbd_dest_dir"
      done

      # Fix and check tbd re-export references
      chmod u+w -R $out
      while IFS= read -r -d $'\0' tbd; do
        echo "Fixing re-exports in $tbd"
        rewrite-tbd \
          -p ${standardFrameworkPath name false}/:$out/Library/Frameworks/${name}.framework/ \
          ${mkDepsRewrites deps} \
          -r ${builtins.storeDir} \
          "$tbd"
      done < <(find "$out" -type f -name '*.tbd' -print0)
    '';

    propagatedBuildInputs = builtins.attrValues deps;

    # don't use pure CF for dylibs that depend on frameworks
    setupHook = ./framework-setup-hook.sh;

    # Not going to be more specific than this for now
    __propagatedImpureHostDeps = lib.optionals (name != "Kernel") [
      # The setup-hook ensures that everyone uses the impure CoreFoundation who uses these SDK frameworks, so let's expose it
      "/System/Library/Frameworks/CoreFoundation.framework"
      "/System/Library/Frameworks/${name}.framework"
      "/System/Library/Frameworks/${name}.framework/${name}"
    ];

    passthru = {
      tbdRewrites = {
        prefix."${standardFrameworkPath name false}/" = "${finalAttrs.finalPackage}/Library/Frameworks/${name}.framework/";
      };
    };

    meta = with lib; {
      description = "Apple SDK framework ${name}";
      maintainers = with maintainers; [ copumpkin ];
      platforms   = platforms.darwin;
    };
  });

  tbdOnlyFramework = name: { private ? true }: stdenv.mkDerivation (finalAttrs: {
    name = "apple-framework-${name}";
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/Library/Frameworks/
      cp -r ${darwin-stubs}/System/Library/${lib.optionalString private "Private"}Frameworks/${name}.framework \
        $out/Library/Frameworks

      cd $out/Library/Frameworks/${name}.framework

      versions=(./Versions/*)
      if [ "''${#versions[@]}" != 1 ]; then
        echo "Unable to determine current version of framework ${name}"
        exit 1
      fi
      current=$(basename ''${versions[0]})

      chmod u+w -R .
      ln -s "$current" Versions/Current
      ln -s Versions/Current/* .

      # NOTE there's no re-export checking here, this is probably wrong
    '';

    passthru = {
      tbdRewrites = {
        prefix."${standardFrameworkPath name private}/" = "${finalAttrs.finalPackage}/Library/Frameworks/${name}.framework/";
      };
    };
  });
in rec {
  libs = {
    xpc = stdenv.mkDerivation {
      name   = "apple-lib-xpc";
      dontUnpack = true;

      installPhase = ''
        mkdir -p $out/include
        pushd $out/include >/dev/null
        cp -r "${lib.getDev sdk}/include/xpc" $out/include/xpc
        cp "${lib.getDev sdk}/include/launch.h" $out/include/launch.h
        popd >/dev/null
      '';
    };

    Xplugin = stdenv.mkDerivation {
      name   = "apple-lib-Xplugin";
      dontUnpack = true;

      # Not enough
      __propagatedImpureHostDeps = [ "/usr/lib/libXplugin.1.dylib" ];

      propagatedBuildInputs = with frameworks; [
        OpenGL ApplicationServices Carbon IOKit CoreGraphics CoreServices CoreText
      ];

      installPhase = ''
        mkdir -p $out/include $out/lib
        ln -s "${lib.getDev sdk}/include/Xplugin.h" $out/include/Xplugin.h
        cp ${darwin-stubs}/usr/lib/libXplugin.1.tbd $out/lib
        ln -s libXplugin.1.tbd $out/lib/libXplugin.tbd
      '';
    };

    utmp = stdenv.mkDerivation {
      name   = "apple-lib-utmp";
      dontUnpack = true;

      installPhase = ''
        mkdir -p $out/include
        pushd $out/include >/dev/null
        ln -s "${lib.getDev sdk}/include/utmp.h"
        ln -s "${lib.getDev sdk}/include/utmpx.h"
        popd >/dev/null
      '';
    };

    sandbox = stdenv.mkDerivation {
      name = "apple-lib-sandbox";
      dontUnpack = true;

      installPhase = ''
        mkdir -p $out/include $out/lib
        ln -s "${lib.getDev sdk}/include/sandbox.h" $out/include/sandbox.h
        cp "${darwin-stubs}/usr/lib/libsandbox.1.tbd" $out/lib
        ln -s libsandbox.1.tbd $out/lib/libsandbox.tbd
      '';
    };
  };

  overrides = super: {
    AppKit = super.AppKit.overrideAttrs (drv: {
      __propagatedImpureHostDeps = drv.__propagatedImpureHostDeps or [] ++ [
        "/System/Library/PrivateFrameworks/"
      ];
    });

    Carbon = super.Carbon.overrideAttrs (drv: {
      extraTBDFiles = [ "Versions/A/Frameworks/HTMLRendering.framework/Versions/A/HTMLRendering.tbd" ];
    });

    CoreFoundation = super.CoreFoundation.overrideAttrs (drv: {
      setupHook = ./cf-setup-hook.sh;
    });

    CoreMedia = super.CoreMedia.overrideAttrs (drv: {
      __propagatedImpureHostDeps = drv.__propagatedImpureHostDeps or [] ++ [
        "/System/Library/Frameworks/CoreImage.framework"
      ];
    });

    CoreMIDI = super.CoreMIDI.overrideAttrs (drv: {
      __propagatedImpureHostDeps = drv.__propagatedImpureHostDeps or [] ++ [
        "/System/Library/PrivateFrameworks/"
      ];
      setupHook = ./private-frameworks-setup-hook.sh;
    });

    IMServicePlugIn = super.IMServicePlugIn.overrideAttrs (drv: {
      extraTBDFiles = [ "Versions/A/Frameworks/IMServicePlugInSupport.framework/Versions/A/IMServicePlugInSupport.tbd" ];
    });

    Security = super.Security.overrideAttrs (drv: {
      setupHook = ./security-setup-hook.sh;
    });

    QuartzCore = super.QuartzCore.overrideAttrs (drv: {
      installPhase = drv.installPhase + ''
        f="$out/Library/Frameworks/QuartzCore.framework/Headers/CoreImage.h"
        substituteInPlace "$f" \
          --replace "QuartzCore/../Frameworks/CoreImage.framework/Headers" "CoreImage"
      '';
    });

    MetalKit = super.MetalKit.overrideAttrs (drv: {
      installPhase = drv.installPhase + ''
        mkdir -p $out/include/simd
        cp ${lib.getDev sdk}/include/simd/*.h $out/include/simd/
      '';
    });

    WebKit = super.WebKit.overrideAttrs (drv: {
      extraTBDFiles = [
        "Versions/A/Frameworks/WebCore.framework/Versions/A/WebCore.tbd"
        "Versions/A/Frameworks/WebKitLegacy.framework/Versions/A/WebKitLegacy.tbd"
      ];
    });
  } // lib.genAttrs [
    "ContactsPersistence"
    "CoreSymbolication"
    "DebugSymbols"
    "DisplayServices"
    "GameCenter"
    "MultitouchSupport"
    "SkyLight"
    "UIFoundation"
  ]
    (x: tbdOnlyFramework x {});

  bareFrameworks = lib.mapAttrs framework (import ./frameworks.nix {
    inherit frameworks libs;
    inherit (pkgs.darwin) libobjc;
  });

  frameworks = bareFrameworks // overrides bareFrameworks;

  inherit sdk;
}
