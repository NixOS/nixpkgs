{ stdenv, fetchurl, xar, xz, cpio, pkgs, python, lib }:

let
  # TODO: make this available to other packages and generalize the unpacking a bit
  # from https://gist.github.com/pudquick/ff412bcb29c9c1fa4b8d
  unpbzx = fetchurl {
    url    = "https://gist.githubusercontent.com/pudquick/ff412bcb29c9c1fa4b8d/raw/24b25538ea8df8d0634a2a6189aa581ccc6a5b4b/parse_pbzx2.py";
    sha256 = "0jgp6qbfl36i0jlz7as5zk2w20z4ca8wlrhdw49lwsld6wi3rfhc";
  };

  # sadly needs to be exported because security_tool needs it
  sdk = stdenv.mkDerivation rec {
    version = "10.13";
    name    = "MacOS_SDK-${version}";

    # This URL comes from https://swscan.apple.com/content/catalogs/others/index-10.13.merged-1.sucatalog, which we found by:
    #  1. Google: site:swscan.apple.com and look for a name that seems appropriate for your version
    #  2. In the resulting file, search for a file called DevSDK ending in .pkg, prefer the latest one based on `PostDate`
    #  3. ???
    #  4. Profit
    src = fetchurl {
      url    = "http://swcdn.apple.com/content/downloads/17/04/091-87532/na7u7461yf0watevifclf88mz06kspm896/DevSDK_macOS1013_Public.pkg";
      sha256 = "12z2wac3fhh8rzjri6il9fq83fr3a6clk5lsz4gyh71c4jingzfq";
    };

    buildInputs = [ xar xz cpio python ];

    phases = [ "unpackPhase" "installPhase" "fixupPhase" ];
    outputs = [ "out" "dev" "man" ];

    unpackPhase = ''
      xar -x -f $src
      python ${unpbzx} Payload
    '';

    installPhase = ''
      start="$(pwd)"
      mkdir -p $out
      cd $out
      cat $start/Payload.*.xz | xz -d | cpio -idm

      mv usr/* .
      rmdir usr

      mv System/* .
      rmdir System

      pushd lib
      ln -s -L /usr/lib/libcups*.dylib .
      popd

      cd Library/Frameworks/QuartzCore.framework/Versions/A/Headers
      for file in CI*.h; do
        rm $file
        ln -s ../Frameworks/CoreImage.framework/Headers/$file
      done
    '';

    meta = with stdenv.lib; {
      description = "Apple SDK ${version}";
      maintainers = with maintainers; [ copumpkin ];
      platforms   = platforms.darwin;
    };
  };

  framework = name: deps: stdenv.mkDerivation {
    name = "apple-framework-${name}";

    phases = [ "installPhase" "fixupPhase" ];

    # because we copy files from the system
    preferLocalBuild = true;

    disallowedRequisites = [ sdk ];

    installPhase = ''
      linkFramework() {
        local path="$1"
        local dest="$out/Library/Frameworks/$path"
        local name="$(basename "$path" .framework)"
        local current="$(readlink "/System/Library/Frameworks/$path/Versions/Current")"
        if [ -z "$current" ]; then
          current=A
        fi

        mkdir -p "$dest"
        pushd "$dest" >/dev/null

        # Keep track of if this is a child or a child rescue as with
        # ApplicationServices in the 10.9 SDK
        local isChild

        if [ -d "${sdk.out}/Library/Frameworks/$path/Versions/$current/Headers" ]; then
          isChild=1
          cp -R "${sdk.out}/Library/Frameworks/$path/Versions/$current/Headers" .
        else
          isChild=0
          current="$(readlink "/System/Library/Frameworks/$name.framework/Versions/Current")"
          cp -R "${sdk.out}/Library/Frameworks/$name.framework/Versions/$current/Headers" .
        fi
        ln -s -L "/System/Library/Frameworks/$path/Versions/$current/$name"
        ln -s -L "/System/Library/Frameworks/$path/Versions/$current/Resources"

        if [ -f "/System/Library/Frameworks/$path/module.map" ]; then
          ln -s "/System/Library/Frameworks/$path/module.map"
        fi

        if [ $isChild -eq 1 ]; then
          pushd "${sdk.out}/Library/Frameworks/$path/Versions/$current" >/dev/null
        else
          pushd "${sdk.out}/Library/Frameworks/$name.framework/Versions/$current" >/dev/null
        fi
        local children=$(echo Frameworks/*.framework)
        if [ "$name" == "ApplicationServices" ]; then
          # Fixing up ApplicationServices which is missing
          # CoreGraphics in the 10.9 SDK
          children="$children Frameworks/CoreGraphics.framework"
        fi
        popd >/dev/null

        for child in $children; do
          childpath="$path/Versions/$current/$child"
          linkFramework "$childpath"
        done

        if [ -d "$dest/Versions/$current" ]; then
          mv $dest/Versions/$current/* .
        fi

        popd >/dev/null
      }


      linkFramework "${name}.framework"
    '';

    propagatedBuildInputs = deps;

    # don't use pure CF for dylibs that depend on frameworks
    setupHook = ./framework-setup-hook.sh;

    # Not going to be more specific than this for now
    __propagatedImpureHostDeps = stdenv.lib.optionals (name != "Kernel") [
      # The setup-hook ensures that everyone uses the impure CoreFoundation who uses these SDK frameworks, so let's expose it
      "/System/Library/Frameworks/CoreFoundation.framework"
      "/System/Library/Frameworks/${name}.framework"
      "/System/Library/Frameworks/${name}.framework/${name}"
    ];

    meta = with stdenv.lib; {
      description = "Apple SDK framework ${name}";
      maintainers = with maintainers; [ copumpkin ];
      platforms   = platforms.darwin;
    };
  };
in rec {
  libs = {
    availability = stdenv.mkDerivation {
      name   = "apple-lib-availability";
      phases = [ "installPhase" "fixupPhase" ];

      installPhase = ''
        mkdir -p $out/include/os
        cp "${lib.getDev sdk}/include/AvailabilityInternal.h" $out/include/AvailabilityInternal.h
        cp "${lib.getDev sdk}/include/os/availability.h" $out/include/os/availability.h
      '';
    };

    utmp = stdenv.mkDerivation {
      name   = "apple-lib-utmp";
      phases = [ "installPhase" "fixupPhase" ];

      installPhase = ''
        mkdir -p $out/include
        pushd $out/include >/dev/null
        ln -s "${lib.getDev sdk}/include/utmp.h"
        ln -s "${lib.getDev sdk}/include/utmpx.h"
        popd >/dev/null
      '';
    };

    xpc = stdenv.mkDerivation {
      name   = "apple-lib-xpc";
      phases = [ "installPhase" "fixupPhase" ];

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
      phases = [ "installPhase" "fixupPhase" ];

      # Not enough
      __propagatedImpureHostDeps = [ "/usr/lib/libXplugin.1.dylib" ];

      propagatedBuildInputs = with frameworks; [
        OpenGL ApplicationServices Carbon IOKit pkgs.darwin.CF CoreGraphics CoreServices CoreText
      ];

      installPhase = ''
        mkdir -p $out/include $out/lib
        ln -s "${lib.getDev sdk}/include/Xplugin.h" $out/include/Xplugin.h
        ln -s "/usr/lib/libXplugin.1.dylib" $out/lib/libXplugin.dylib
      '';
    };
  };

  overrides = super: {
    AppKit = stdenv.lib.overrideDerivation super.AppKit (drv: {
      __propagatedImpureHostDeps = drv.__propagatedImpureHostDeps ++ [
        "/System/Library/PrivateFrameworks/"
      ];
    });

    CoreMedia = stdenv.lib.overrideDerivation super.CoreMedia (drv: {
      __propagatedImpureHostDeps = drv.__propagatedImpureHostDeps ++ [
        "/System/Library/Frameworks/CoreImage.framework"
      ];
    });

    CoreMIDI = stdenv.lib.overrideDerivation super.CoreMIDI (drv: {
      __propagatedImpureHostDeps = drv.__propagatedImpureHostDeps ++ [
        "/System/Library/PrivateFrameworks/"
      ];
      setupHook = ./private-frameworks-setup-hook.sh;
    });

    Security = stdenv.lib.overrideDerivation super.Security (drv: {
      setupHook = ./security-setup-hook.sh;
    });

    QuartzCore = stdenv.lib.overrideDerivation super.QuartzCore (drv: {
      installPhase = drv.installPhase + ''
        f="$out/Library/Frameworks/QuartzCore.framework/Headers/CoreImage.h"
        substituteInPlace "$f" \
          --replace "QuartzCore/../Frameworks/CoreImage.framework/Headers" "CoreImage"
      '';
    });
  };

  bareFrameworks = stdenv.lib.mapAttrs framework (import ./frameworks.nix {
    inherit frameworks libs;
    inherit (pkgs.darwin) CF cf-private libobjc;
  });

  frameworks = bareFrameworks // overrides bareFrameworks;

  inherit sdk;
}
