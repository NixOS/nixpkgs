{ stdenv, lib, fetchzip, fetchFromGitHub, writeText, haxe, neko, jdk, mono }:

let
  withCommas = lib.replaceStrings [ "." ] [ "," ];

  # simulate "haxelib dev $libname ."
  simulateHaxelibDev = libname: ''
    devrepo=$(mktemp -d)
    mkdir -p "$devrepo/${withCommas libname}"
    echo $(pwd) > "$devrepo/${withCommas libname}/.dev"
    export HAXELIB_PATH="$HAXELIB_PATH:$devrepo"
  '';

  installLibHaxe = { libname, version, files ? "*" }: ''
    mkdir -p "$out/lib/haxe/${withCommas libname}/${withCommas version}"
    echo -n "${version}" > $out/lib/haxe/${withCommas libname}/.current
    cp -dpR ${files} "$out/lib/haxe/${withCommas libname}/${withCommas version}/"
  '';

  buildHaxeLib = {
    libname,
    version,
    sha256 ? null,
    src ? null,
    linc_lib ? null,
    meta,
    ...
  } @ attrs:
    assert sha256 != null || src != null;
    stdenv.mkDerivation (attrs // {
      name = "${libname}-${version}";

      nativeBuildInputs = (attrs.nativeBuildInputs or [ ]) ++ [ haxe neko ]; # for setup-hook.sh to work
      src = attrs.src or (fetchzip rec {
        name = "${libname}-${version}";
        url = "http://lib.haxe.org/files/3.0/${withCommas name}.zip";
        inherit sha256;
        stripRoot = false;
      });

      postPatch = (attrs.postPatch or "") + ''
        ${lib.optionalString (linc_lib != null) ''
          # Workaround to permit cache to work correctly with linc
          # When there are dependancies in multiple directories, it create a random temporary folder with them merged. This usually isn’t a problem,
          # but here, -I<include_path>, a compiler arguments that’s used in the cache hash, change at every compilation
          # Also, can’t modify Linc.hx directly, as they are supposed to be identical (I think?)
          substituteInPlace linc/linc_${linc_lib}.xml \
            --replace $\{LINC_${lib.toUpper linc_lib}_PATH} $out/lib/haxe/${withCommas libname}/${withCommas version}/
        ''}
      '';

      installPhase = attrs.installPhase or ''
        ${installLibHaxe { inherit libname version; }}
      '';

      meta = {
        homepage = "http://lib.haxe.org/p/${libname}";
        license = lib.licenses.bsd2;
        platforms = lib.platforms.all;
        description = throw "please write meta.description";
      } // attrs.meta;
    });
in
{
  format = buildHaxeLib {
    libname = "format";
    version = "3.5.0";
    sha256 = "sha256-5vZ7b+P74uGx0Gb7X/+jbsx5048dO/jv5nqCDtw5y/A=";
    meta.description = "A Haxe Library for supporting different file formats";
  };

  heaps = buildHaxeLib {
    libname = "heaps";
    version = "1.9.1";
    sha256 = "sha256-i5EIKnph80eEEHvGXDXhIL4t4+RW7OcUV5zb2f3ItlI=";
    meta.description = "The GPU Game Framework";
  };

  hlopenal = buildHaxeLib {
    libname = "hlopenal";
    version = "1.5.0";
    sha256 = "sha256-mJWFGBJPPAhVwsB2HzMfk4szSyjMT4aw543YhVqIan4=";
    meta.description = "OpenAL support for Haxe/HL";
  };

  hlsdl = buildHaxeLib {
    libname = "hlsdl";
    version = "1.10.0";
    sha256 = "sha256-kmC2EMDy1mv0jFjwDj+m0CUvKal3V7uIGnMxJBRYGms=";
    meta.description = "SDL/GL support for Haxe/HL";
  };

  # Cache should work properly if used outside nix build. For development on nix, you can:
  # add ``export HXCPP_COMPILE_CACHE=/tmp/hxcpp-cache`` and ``export HXCPP_CACHE_MB=8000`` in the setupHook and
  # running sudo mkdir /tmp/hxcpp-cache
  # running sudo chmod a+xrw /tmp/hxcpp-cache/ (make sure no untrusted code is running at user-level to avoid risk)
  # call nix with the ``--option extra-sandbox-paths /tmp/hxcpp-cache`` flag

  hxcpp = buildHaxeLib rec {
    libname = "hxcpp";
    version = "4.3.2";
    src = fetchFromGitHub {
      owner = "HaxeFoundation";
      repo = "hxcpp";
      rev = "v${version}";
      sha256 = "sha256-G/qW4HnF/5L6wyCVmt7aFs5QTClvcxH7TA2eYwJ4eLM=";
    };
    buildPhase = ''
      (
        cd tools/hxcpp
        haxe compile.hxml
      )
    '';
    setupHook = writeText "setup-hook.sh" ''
      if [ "$\{enableParallelBuilding-}" ]; then
        HXCPP_COMPILE_THREADS=$NIX_BUILD_CORES
        # This may called before NIX_BUILD_CORES is initialized in pkgs/stdenv/generic/setup.sh
        if ((HXCPP_COMPILE_THREADS <= 0)); then
          guess=$(nproc 2>/dev/null || true)
          ((HXCPP_COMPILE_THREADS = guess <= 0 ? 1 : guess))
        fi
      else
        HXCPP_COMPILE_THREADS=1
      fi
      export HXCPP_COMPILE_THREADS
    '';
    meta.description = "Runtime support library for the Haxe C++ backend";
  };

  hxjava = buildHaxeLib {
    libname = "hxjava";
    version = "3.2.0";
    sha256 = "1vgd7qvsdxlscl3wmrrfi5ipldmr4xlsiwnj46jz7n6izff5261z";
    meta.description = "Support library for the Java backend of the Haxe compiler";
    propagatedBuildInputs = [ jdk ];
  };

  hxcs = buildHaxeLib {
    libname = "hxcs";
    version = "3.4.0";
    sha256 = "0f5vgp2kqnpsbbkn2wdxmjf7xkl0qhk9lgl9kb8d5wdy89nac6q6";
    meta.description = "Support library for the C# backend of the Haxe compiler";
    propagatedBuildInputs = [ mono ];
  };

  hxnodejs_4 = buildHaxeLib {
    libname = "hxnodejs";
    version = "4.0.9";
    sha256 = "0b7ck48nsxs88sy4fhhr0x1bc8h2ja732zzgdaqzxnh3nir0bajm";
    meta.description = "Extern definitions for node.js 4.x";
  };

  hxnodejs_6 =
    let
      libname = "hxnodejs";
      version = "6.9.0";
    in
    stdenv.mkDerivation {
      name = "${libname}-${version}";
      src = fetchFromGitHub {
        owner = "HaxeFoundation";
        repo = "hxnodejs";
        rev = "cf80c6a";
        sha256 = "0mdiacr5b2m8jrlgyd2d3vp1fha69lcfb67x4ix7l7zfi8g460gs";
      };
      installPhase = installLibHaxe { inherit libname version; };
      meta = {
        homepage = "http://lib.haxe.org/p/${libname}";
        license = lib.licenses.bsd2;
        platforms = lib.platforms.all;
        description = "Extern definitions for node.js 6.9";
      };
    };

  hscript = buildHaxeLib {
    libname = "hscript";
    version = "2.4.0";
    sha256 = "0qdxgqb75j1v125l9xavs1d32wwzi60rhfymngdhjqhdvq72bhxx";
    meta = with lib; {
      license = licenses.mit;
      description = "Scripting engine for a subset of the Haxe language";
    };
  };

  flixel = buildHaxeLib {
    libname = "flixel";
    version = "4.11.0";
    sha256 = "sha256-xgiBzXu+ieXbT8nxRuEqft3p4sYTOF+weQqzcYsf+o0=";
    meta = with lib; {
      license = licenses.mit;
      description = "2D game engine based on OpenFL that delivers cross-platform games";
    };
  };

  flixel-addons = buildHaxeLib {
    libname = "flixel-addons";
    version = "2.11.0";
    sha256 = "sha256-mRKpLzhlh1UXxIdg1/a0NTVzriNEW1wsSirL1UOkvAI=";
    meta = with lib; {
      license = licenses.mit;
      description = "Set of useful, but optional classes for HaxeFlixel created by the community";
    };
  };

  flixel-ui = buildHaxeLib {
    libname = "flixel-ui";
    version = "2.4.0";
    sha256 = "sha256-5oNeDQWkA8Sfrl+kEi7H2DLOc5N2DfbbcwiRw5DBSGw=";
    meta = with lib; {
      license = licenses.mit;
      description = "UI library for Flixel";
    };
  };

  discord_rpc = buildHaxeLib {
    libname = "discord_rpc";
    version = "unstable-2021-03-26";
    src = fetchFromGitHub {
      owner = "Aidan63";
      repo = "linc_discord-rpc";
      rev = "2d83fa863ef0c1eace5f1cf67c3ac315d1a3a8a5";
      fetchSubmodules = true;
      sha256 = "0w3f9772ypqil348dq8xvhh5g1z5dii5rrwlmmvcdr2gs2c28c7k";
    };
    linc_lib = "discord_rpc";
    meta = with lib; {
      license = licenses.mit;
      description = "Native bindings for discord-rpc";
    };
  };

  polymod = buildHaxeLib {
    libname = "polymod";
    version = "1.5.2";
    sha256 = "sha256-iKikj+KDg8qanuA+50cleKwXXsitNUY2sqhRCVMslAo=";
    meta = with lib; {
      license = licenses.mit;
      description = "Atomic modding framework for Haxe games/apps";
    };
  };

  newgrounds = buildHaxeLib {
    libname = "newgrounds";
    version = "1.1.5";
    sha256 = "sha256-Aqc6HYPva3YyerMLgC9tsAVO8DJrko/sWZbVFCfeAsE=";
    meta = with lib; {
      license = licenses.mit;
      description = "Newgrounds API for haxe";
    };
  };

  openfl = buildHaxeLib {
    libname = "openfl";
    version = "9.1.0";
    sha256 = "0ri9s8d7973d2jz6alhl5i4fx4ijh0kb27mvapq28kf02sp8kgim";
    meta = with lib; {
      license = licenses.mit;
      description = "Open Flash Library for fast 2D development";
    };
  };

  lime = buildHaxeLib rec {
    libname = "lime";
    version = "7.9.0";
    sha256 = "sha256-7UBSgzQEQjmMYk2MGfMZPYSj3quWbiP8LWM+vtyeWFg=";
    meta = with lib; {
      license = licenses.mit;
      description = "Flexible, lightweight layer for Haxe cross-platform developers";
    };
  };
}
