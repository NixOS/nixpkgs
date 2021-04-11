{ stdenv, lib, fetchzip, fetchFromGitHub, haxe, neko, jdk, mono }:

let
  self = haxePackages;
  haxePackages = with self; {

    withCommas = lib.replaceChars ["."] [","];

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

        buildInputs = (attrs.buildInputs or []) ++ [ haxe neko ]; # for setup-hook.sh to work
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
    in stdenv.mkDerivation {
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

    lime = buildHaxeLib {
      libname = "lime";
      version = "7.9.0";
      sha256 = "0n2qkvfbwgk35py26vlnmgga711x37rik32dca63jhh46j1m4h7d";
      meta = with lib; {
        license = licenses.mit;
        description = "Flexible, lightweight layer for Haxe cross-platform developers";
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

    flixel = buildHaxeLib {
      libname = "flixel";
      version = "4.8.1";
      sha256 = "1m7l92xg6nndy7m98yfmcrsqvd2rhafckx1xbv0im69y823c27a3";
      meta = with lib; {
        license = licenses.mit;
        description = "2D game engine based on OpenFL that delivers cross-platform games";
      };
    };

    flixel-addons = buildHaxeLib {
      libname = "flixel-addons";
      version = "2.9.0";
      sha256 = "1zz1pcp20j3r87m0laq32dg0708kir3188dpgpx7c3c3mmxlw6sp";
      meta = with lib; {
        license = licenses.mit;
        description = "Set of useful, but optional classes for HaxeFlixel created by the community";
      };
    };

    flixel-ui = buildHaxeLib {
      libname = "flixel-ui";
      version = "2.3.3";
      sha256 = "1xrsjzcg1wv7j9fbifcg5v9zvfr1vhs0spar8nmi86liiqv1iwka";
      meta = with lib; {
        license = licenses.mit;
        description = "UI library for Flixel";
      };
    };

    newgrounds = buildHaxeLib {
      libname = "newgrounds";
      version = "1.1.4";
      sha256 = "0lk4wiqj3k209qfxc1c6qs038m6a3hd1mhjk0z40y90r13n3hfzj";
      meta = with lib; {
        license = licenses.mit;
        description = "Newgrounds API for haxe";
      };
    };

    polymod = buildHaxeLib {
      libname = "polymod";
      version = "unstable-2021-04-06";
      src = fetchFromGitHub {
        owner = "larsiusprime";
        repo = "polymod";
        rev = "bb5f0a120419ac3a7132d96aff1e6f7a36b97d67";
        sha256 = "1afrajf4mcw0kqz64gsa8h71r54c4i6hhb2pn6kw6z4rg3ilixlf";
      };
      meta = with lib; {
        license = licenses.mit;
        description = "Atomic modding framework for Haxe games/apps";
      };
    };

  };
in self
