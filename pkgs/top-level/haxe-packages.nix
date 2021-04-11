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
    meta,
    ...
  } @ attrs:
    assert sha256 != null || src != null;
    stdenv.mkDerivation (attrs // {
      name = "${libname}-${version}";

      buildInputs = (attrs.buildInputs or [ ]) ++ [ haxe neko ]; # for setup-hook.sh to work
      src = attrs.src or (fetchzip rec {
        name = "${libname}-${version}";
        url = "http://lib.haxe.org/files/3.0/${withCommas name}.zip";
        inherit sha256;
        stripRoot = false;
      });

      installPhase = attrs.installPhase or ''
        runHook preInstall
        (
          if [ $(ls $src | wc -l) == 1 ]; then
            cd $src/* || cd $src
          else
            cd $src
          fi
          ${installLibHaxe { inherit libname version; }}
        )
        runHook postInstall
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

  hxcpp = buildHaxeLib rec {
    libname = "hxcpp";
    version = "4.2.1";
    sha256 = "10ijb8wiflh46bg30gihg7fyxpcf26gibifmq5ylx0fam4r51lhp";
    postFixup = ''
      for f in $out/lib/haxe/${withCommas libname}/${withCommas version}/{,project/libs/nekoapi/}bin/Linux{,64}/*; do
        chmod +w "$f"
        patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker)   "$f" || true
        patchelf --set-rpath ${ lib.makeLibraryPath [ stdenv.cc.cc ] }  "$f" || true
      done
    '';
    setupHook = writeText "setup-hook.sh" ''
      if [ "$\{enableParallelBuilding-}" ]; then
        export HXCPP_COMPILE_THREADS=$NIX_BUILD_CORES
      else
        export HXCPP_COMPILE_THREADS=1
      fi
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
    sha256 = "0n2qkvfbwgk35py26vlnmgga711x37rik32dca63jhh46j1m4h7d";
    meta = with lib; {
      license = licenses.mit;
      description = "Flexible, lightweight layer for Haxe cross-platform developers";
    };
  };
}
