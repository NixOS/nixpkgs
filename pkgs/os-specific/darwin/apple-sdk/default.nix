{ stdenv, fetchurl, xar, gzip, cpio, pkgs }:

let
  # sadly needs to be exported because security_tool needs it
  sdk = stdenv.mkDerivation rec {
    version = "10.9";
    name    = "MacOS_SDK-${version}";

    src = fetchurl {
      url    = "http://swcdn.apple.com/content/downloads/27/02/031-06182/xxog8vxu8i6af781ivf4uhy6yt1lslex34/DevSDK_OSX109.pkg";
      sha256 = "16b7aplha5573yl1d44nl2yxzp0w2hafihbyh7930wrcvba69iy4";
    };

    buildInputs = [ xar gzip cpio ];

    phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

    unpackPhase = ''
      xar -x -f $src
    '';

    installPhase = ''
      start="$(pwd)"
      mkdir -p $out
      cd $out
      cat $start/Payload | gzip -d | cpio -idm

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

        if [ -d "${sdk}/Library/Frameworks/$path/Versions/$current/Headers" ]; then
          isChild=1
          cp -R "${sdk}/Library/Frameworks/$path/Versions/$current/Headers" .
        else
          isChild=0
          current="$(readlink "/System/Library/Frameworks/$name.framework/Versions/Current")"
          cp -R "${sdk}/Library/Frameworks/$name.framework/Versions/$current/Headers" .
        fi
        ln -s -L "/System/Library/Frameworks/$path/Versions/$current/$name"
        ln -s -L "/System/Library/Frameworks/$path/Versions/$current/Resources"

        if [ -f "/System/Library/Frameworks/$path/module.map" ]; then
          ln -s "/System/Library/Frameworks/$path/module.map"
        fi

        if [ $isChild -eq 1 ]; then
          pushd "${sdk}/Library/Frameworks/$path/Versions/$current" >/dev/null
        else
          pushd "${sdk}/Library/Frameworks/$name.framework/Versions/$current" >/dev/null
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

    # allows building the symlink tree
    __impureHostDeps = [ "/System/Library/Frameworks/${name}.framework" ];

    __propagatedImpureHostDeps = stdenv.lib.optional (name != "Kernel") "/System/Library/Frameworks/${name}.framework/${name}";

    meta = with stdenv.lib; {
      description = "Apple SDK framework ${name}";
      maintainers = with maintainers; [ copumpkin ];
      platforms   = platforms.darwin;
    };
  };
in rec {
  libs = {
    xpc = stdenv.mkDerivation {
      name   = "apple-lib-xpc";
      phases = [ "installPhase" "fixupPhase" ];

      installPhase = ''
        mkdir -p $out/include
        pushd $out/include >/dev/null
        ln -s "${sdk}/include/xpc"
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
        ln -s "${sdk}/include/Xplugin.h" $out/include/Xplugin.h
        ln -s "/usr/lib/libXplugin.1.dylib" $out/lib/libXplugin.dylib
      '';
    };

    utmp = stdenv.mkDerivation {
      name   = "apple-lib-utmp";
      phases = [ "installPhase" "fixupPhase" ];

      installPhase = ''
        mkdir -p $out/include
        pushd $out/include >/dev/null
        ln -s "${sdk}/include/utmp.h"
        ln -s "${sdk}/include/utmpx.h"
        popd >/dev/null
      '';
    };
  };

  overrides = super: {
    QuartzCore = stdenv.lib.overrideDerivation super.QuartzCore (drv: {
      installPhase = drv.installPhase + ''
        f="$out/Library/Frameworks/QuartzCore.framework/Headers/CoreImage.h"
        substituteInPlace "$f" \
          --replace "QuartzCore/../Frameworks/CoreImage.framework/Headers" "CoreImage"
      '';
    });

    CoreServices = stdenv.lib.overrideDerivation super.CoreServices (drv: {
      __propagatedSandboxProfile = drv.__propagatedSandboxProfile ++ [''
        (allow mach-lookup (global-name "com.apple.CoreServices.coreservicesd"))
      ''];
    });

    Security = stdenv.lib.overrideDerivation super.Security (drv: {
      setupHook = ./security-setup-hook.sh;
    });
  };

  bareFrameworks = stdenv.lib.mapAttrs framework (import ./frameworks.nix {
    inherit frameworks libs;
    inherit (pkgs.darwin) CF cf-private libobjc;
  });

  frameworks = bareFrameworks // overrides bareFrameworks;

  inherit sdk;
}
