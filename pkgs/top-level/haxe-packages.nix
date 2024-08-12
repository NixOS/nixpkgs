{ stdenv, lib, fetchzip, fetchFromGitHub, fetchFromGitLab, writeText, haxe, neko, jdk, mono, libvlc }:

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
      pname = libname;
      inherit version;

      nativeBuildInputs = (attrs.nativeBuildInputs or [ ]) ++ [ haxe neko ]; # for setup-hook.sh to work
      src = attrs.src or (fetchzip rec {
        name = "${libname}-${version}";
        url = "http://lib.haxe.org/files/3.0/${withCommas name}.zip";
        inherit sha256;
        stripRoot = false;
      });

      passthru = {
        haxe_libname = libname;
      };

      prePatch = attrs.prePatch or ''
        if [ $(ls . | wc -l) == 1 ]; then
          cd ./* || cd .
        fi
      '';

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
in rec {
  inherit buildHaxeLib;

  format = buildHaxeLib {
    libname = "format";
    version = "3.7.0";
    sha256 = "sha256-/xXMP/UkLOXd9Qs43d3APjDZ3c0TZV0NqXCIrqmsaj0=";
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
    version = "2.5.0";
    sha256 = "sha256-R+RuoVkw6DiR4bHZZIr1AfYcdDcgE2McxpJuubqvGeU=";
    meta = with lib; {
      license = licenses.mit;
      description = "Scripting engine for a subset of the Haxe language";
    };
  };

  flixel = buildHaxeLib {
    libname = "flixel";
    version = "5.8.0";
    sha256 = "sha256-UkfuOtquKmq4kFlnYihKCovDB+aqws++wjR4IsHlJos=";
    meta = with lib; {
      license = licenses.mit;
      description = "2D game engine based on OpenFL that delivers cross-platform games";
    };
  };

  flixel-addons = buildHaxeLib {
    libname = "flixel-addons";
    version = "3.2.3";
    sha256 = "sha256-cda4HooAeQ7IaHNLAVLotDc9tCy1H6MzjhTj3A7s+1g=";
    meta = with lib; {
      license = licenses.mit;
      description = "Set of useful, but optional classes for HaxeFlixel created by the community";
    };
  };

  flixel-ui = buildHaxeLib {
    libname = "flixel-ui";
    version = "2.6.1";
    sha256 = "sha256-jRfBnWx8AIjboovPUbKbTP0XrnKHvRLJg3glzQBzW3E=";
    meta = with lib; {
      license = licenses.mit;
      description = "UI library for Flixel";
    };
  };

  haxeui-core = buildHaxeLib {
    libname = "haxeui-core";
    version = "1.7.0";
    sha256 = "sha256-P0CgY0Or0M9nia0LHfXzjSztNzIsZGoiL7sLoPWOhQo=";
    meta = with lib; {
      license = licenses.mit;
      description = "Core library of the HaxeUI framework";
    };
  };

  haxeui-flixel = buildHaxeLib {
    libname = "haxeui-flixel";
    version = "1.7.0";
    sha256 = "sha256-VI+SDGMFms2sMhEAsVRb+cKuaeFQbj+otPWsFvY5egU=";
    meta = with lib; {
      license = licenses.mit;
      description = "Flixel backend of the HaxeUI framework";
    };
  };

  flixel-text-input = buildHaxeLib {
    libname = "flixel-text-input";
    version = "2.0.2";
    sha256 = "sha256-c3XhV2Jz9jm5yRLJIVEEIFzjYXFu/PKJFOAx9P3Jels=";
    meta = with lib; {
      license = licenses.mit;
      description = "Improved text input object for HaxeFlixel.";
    };
  };

  flxanimate = buildHaxeLib {
    libname = "flxanimate";
    version = "3.0.4";
    sha256 = "sha256-PJserY/EpjmaEnYd9ufhI9+/6U9Ws6HD+talROAMJ64=";
    meta = with lib; {
      license = licenses.mit;
      description = "Adobe Animate's texture atlases player for HaxeFlixel.";
    };
  };

  polymod = buildHaxeLib {
    libname = "polymod";
    version = "1.8.0";
    sha256 = "sha256-RoBIW4u+bcG2UNYbyDbUoW+CDHymhUWgCP7nn2ldDCA=";
    propagatedBuildInputs = [
      jsonpatch
      jsonpath
      thx_semver
    ];
    meta = with lib; {
      license = licenses.mit;
      description = "Atomic modding framework for Haxe games/apps";
    };
  };

  jsonpatch = buildHaxeLib {
    libname = "jsonpatch";
    version = "1.0.0";
    sha256 = "sha256-5R+qiss7oVFWds5sxV13DbkUju7SjNbbEwCEmgRVCrc=";
    propagatedBuildInputs = [
      jsonpath
      thx_core
    ];
    meta = with lib; {
      license = licenses.mit;
      description = "Llibrary for parsing and evaluating JSONPatch documents on JSON data objects.";
    };
  };

  jsonpath = buildHaxeLib {
    libname = "jsonpath";
    version = "1.0.0";
    src = fetchFromGitHub {
      owner = "EliteMasterEric";
      repo = "jsonpath";
      rev = "7a24193717b36393458c15c0435bb7c4470ecdda";
      sha256 = "sha256-aLQ3FwKjxx7XXgG/J1oeaNtCu59etaJhklc3KuoOlb0=";
    };
    meta = with lib; {
      license = licenses.mit;
      description = "Library for parsing and evaluating JSONPath queries on JSON data objects.";
    };
  };

  thx_core = buildHaxeLib {
    libname = "thx.core";
    version = "0.44.0";
    sha256 = "sha256-FdCk2wTznJ9qQBcPzB+OR9hGzL7ZGfstsGUyCjv7yYk=";
    meta = with lib; {
      license = licenses.mit;
      description = "General purpose library. It contains extensions to many of the types contained in the standard library as well as new complementary types.";
    };
  };

  thx_semver = buildHaxeLib {
    libname = "thx.semver";
    version = "0.2.2";
    sha256 = "sha256-BO/YgaM8UZNWETsu+P5fFqMfCrAXew+bsMx316eR00s=";
    meta = with lib; {
      license = licenses.mit;
      description = "Semantic version library for Haxe. It follows the specifications for Semantic Versioning 2.0.0 described at http://semver.org/";
    };
  };

  newgrounds = buildHaxeLib {
    libname = "newgrounds";
    version = "2.0.3";
    sha256 = "sha256-dbgny7r2I8XLdagWsYTVYJO5esoTeQdeiSeYW5AuC7k=";
    meta = with lib; {
      license = licenses.mit;
      description = "Newgrounds API for haxe";
    };
  };

  openfl = buildHaxeLib {
    libname = "openfl";
    version = "9.3.4";
    sha256 = "sha256-D0DDgHFCUPb+vMwvTflNil6hKxPuuo9V8YAOmVMq+x4=";
    meta = with lib; {
      license = licenses.mit;
      description = "Open Flash Library for fast 2D development";
    };
  };

  lime = buildHaxeLib {
    libname = "lime";
    version = "8.1.3";
    sha256 = "sha256-ZdwhgCIqzsgSeViCITLk71ouOTIANzY/082ibLa1As0=";
    buildInputs = [
      hxcpp
      format
      hxp
    ];
    buildPhase = ''
      (
        cd tools
        rm -f tools.n
        haxe ./tools.hxml
      )
    '';
    meta = with lib; {
      license = licenses.mit;
      description = "Flexible, lightweight layer for Haxe cross-platform developers";
    };
  };

  hxcodec = buildHaxeLib {
    libname = "hxCodec";
    version = "3.0.2";
    sha256 = "sha256-M9ZfkM4puCy6fMLaF5wY7VOAcHInHtxEzRZJ6xcWJpw=";
    propagatedBuildInputs = [ libvlc ];
    meta = with lib; {
      license = licenses.mpl20;
      description = "Native video support for HaxeFlixel & OpenFL";
    };
  };

  grig.audio = buildHaxeLib {
    libname = "grig.audio";
    version = "unstable-23-05-2024";
    src = fetchFromGitLab {
      owner = "haxe-grig";
      repo = "grig.audio";
      rev = "57f5d47f2533fd0c3dcd025a86cb86c0dfa0b6d2";
      sha256 = "sha256-aa73zpeExfmoa2b2jSlyWiQGIc5H7Q1ZcwZnJF3tkR8=";
    };
    prePatch = "cd src/";
    meta = {
      license = lib.licenses.mit;
      description = "Audio I/O and Audio Primitives for haxe.";
    };
  };

  funkin.vis = buildHaxeLib {
    libname = "funkin.vis";
    version = "unstable-07-06-2024";
    src = fetchFromGitHub {
      owner = "FunkinCrew";
      repo = "funkVis";
      rev = "d5361037efa3a02c4ab20b5bd14ca11e7d00f519";
      sha256 = "sha256-uvln//zhcY7iumJxnN/sNEduE7v43BHA3s/XYJhj6dE=";
    };
    # Code is a M.I.T, a few examples are cc-by
    meta = {
      license = [ lib.licenses.mit lib.licenses.cc-by-30 ];
    };
  };

  FlxPartialSound = buildHaxeLib {
    libname = "FlxPartialSound";
    version = "unstable-18-06-2024";
    src = fetchFromGitHub {
      owner = "FunkinCrew";
      repo = "FlxPartialSound";
      rev = "a1eab7b9bf507b87200a3341719054fe427f3b15";
      sha256 = "sha256-uDvzArqh/ECxKye+9Mh6nA7yac2zA690ek5Bg4AQSss=";
    };
    meta = {
      license = lib.licenses.mit;
      description = "Haxelib for haxeflixel for loading partial data from an audio file";
    };
  };

  json2object = buildHaxeLib {
    libname = "json2object";
    version = "3.11.0";
    sha256 = "sha256-M2iJZjI9Un6QOIWd/7Qv0XsQSntq3JJmXwTIzBSEXCo=";
    propagatedBuildInputs = [
      hxjsonast
    ];
    meta = {
      license = lib.licenses.mit;
      description = "Type safe Haxe/JSON (de)serializer";
    };
  };

  hxjsonast = buildHaxeLib {
    libname = "hxjsonast";
    version = "1.1.0";
    sha256 = "sha256-5Kbq/hDKypx29omnU8bFfd634KqBVYybEmUZh13qjYc=";
    meta = {
      license = lib.licenses.mit;
      description = "Type-safe position-aware JSON parsing & printing";
    };
  };

  hxp = buildHaxeLib {
    libname = "hxp";
    version = "1.3.0";
    sha256 = "sha256-h1vziyWzJUk/pHGkkMO1gMrs38rdhKjp9HYi6+QBbCM=";
    meta = {
      license = lib.licenses.mit;
      description = "Cross-platform build tools for desktop, mobile, web and consoles";
    };
  };
}
