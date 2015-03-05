{ stdenv, fetchurl, xar, gzip, cpio }:

let
  # I'd rather not "export" this, since they're somewhat monolithic and encourage bad habits.
  # Also, the include directory inside here should be captured (almost?) entirely by our more
  # precise Apple package structure, so with any luck it's unnecessary.
  sdk = stdenv.mkDerivation rec {
    version = "10.9";
    name    = "MacOS_SDK-${version}";

    src = fetchurl {
      url    = "http://swcdn.apple.com/content/downloads/00/14/031-07556/i7hoqm3awowxdy48l34uel4qvwhdq8lgam/DevSDK_OSX109.pkg";
      sha256 = "0x6r61h78r5cxk9dbw6fnjpn6ydi4kcajvllpczx3mi52crlkm4x";
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

      cd Library/Frameworks/QuartzCore.framework/Versions/A/Headers
      for file in CI*.h; do
        rm $file
        ln -s ../Frameworks/CoreImage.framework/Versions/A/Headers/$file
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

    installPhase = ''
      linkFramework() {
        local path="$1"
        local dest="$out/Library/Frameworks/$path"
        local name="$(basename "$path" .framework)"
        local current="$(readlink "/System/Library/Frameworks/$path/Versions/Current")"

        mkdir -p "$dest"
        pushd "$dest" >/dev/null

        ln -s "${sdk}/Library/Frameworks/$path/Versions/$current/Headers"
        ln -s -L "/System/Library/Frameworks/$path/Versions/$current/$name"
        ln -s -L "/System/Library/Frameworks/$path/Versions/$current/Resources"

        if [ -f "/System/Library/Frameworks/$path/module.map" ]; then
          ln -s "/System/Library/Frameworks/$path/module.map"
        fi

        pushd "${sdk}/Library/Frameworks/$path/Versions/$current" >/dev/null
        local children=$(echo Frameworks/*.framework)
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

    # Not going to bother being more precise than this...
    __propagatedImpureHostDeps = [ "/System/Library/Frameworks/${name}.framework/Versions" ];

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
  };

  frameworks = stdenv.lib.mapAttrs framework (import ./frameworks.nix { inherit frameworks libs; });
}
