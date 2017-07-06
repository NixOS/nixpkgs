{ stdenv, fetchzip, fetchFromGitHub, newScope, haxe, neko, nodejs, wine, php, python3, jdk, mono, haskellPackages, fetchpatch }:

let
  self = haxePackages;
  callPackage = newScope self;
  haxePackages = with self; {

    withCommas = stdenv.lib.replaceChars ["."] [","];

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
      sha256,
      meta,
      ...
    } @ attrs:
      stdenv.mkDerivation (attrs // {
        name = "${libname}-${version}";

        buildInputs = (attrs.buildInputs or []) ++ [ haxe neko ]; # for setup-hook.sh to work
        src = fetchzip rec {
          name = "${libname}-${version}";
          url = "http://lib.haxe.org/files/3.0/${withCommas name}.zip";
          inherit sha256;
          stripRoot = false;
        };

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
          license = stdenv.lib.licenses.bsd2;
          platforms = stdenv.lib.platforms.all;
          description = throw "please write meta.description";
        } // attrs.meta;
      });

    hxcpp = buildHaxeLib rec {
      libname = "hxcpp";
      version = "3.4.64";
      sha256 = "04gyjm6wqmsm0ifcfkxmq1yv8xrfzys3z5ajqnvvjrnks807mw8q";
      postFixup = ''
        for f in $out/lib/haxe/${withCommas libname}/${withCommas version}/{,project/libs/nekoapi/}bin/Linux{,64}/*; do
          chmod +w "$f"
          patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker)   "$f" || true
          patchelf --set-rpath ${ stdenv.lib.makeLibraryPath [ stdenv.cc.cc ] }  "$f" || true
        done
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

    hxnodejs_6 = let
      libname = "hxnodejs";
      version = "6.9.0";
    in stdenv.mkDerivation rec {
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
        license = stdenv.lib.licenses.bsd2;
        platforms = stdenv.lib.platforms.all;
        description = "Extern definitions for node.js 6.9";
      };
    };
  };
in self
