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

    actuate = buildHaxeLib {
      libname = "actuate";
      version = "1.8.7";
      sha256 = "1qqdmlfsxj79h3mgy71j5c5w3bf0pnidazkwwpjlq9rgnsg97i3a";
      meta.description = ''Actuate is a fast and flexible tween library that uses a jQuery-style "chaining" syntax'';
    };

    firetongue = buildHaxeLib {
      libname = "firetongue";
      version = "2.0.0";
      sha256 = "0s8z6agqsiylfpfh1jxz36da9ljz5gj271z8dcasiv64gn7r4vsa";
      meta.description = "Framework-agnostic translation/localization library";
    };

    msgpack-haxe = buildHaxeLib {
      libname = "msgpack-haxe";
      version = "1.15.1";
      sha256 = "1synzy59h89pnz0svdpvxksqpbmr5mxqiclbwcc45pk04s0rb9wc";
      meta.description = "MessagePack (http://msgpack.org) for HaXe";
    };

    format = buildHaxeLib {
      libname = "format";
      version = "3.3.0";
      sha256 = "05hkdvkhf0xz02rfafdq414m7a84albalpccn1vyq1kh9j8d5ydg";
      meta.description = "A Haxe Library for supporting different file formats";
    };

    hamcrest = buildHaxeLib {
      libname = "hamcrest";
      version = "2.0.1";
      sha256 = "06fb0mhvxz57js9ywaqx1addz0xrc92968w5ph0gkwrq2mrmv786";
      meta.description = "Library of Matchers (also known as constraints or predicates) allowing 'match' rules to be defined declaratively, to be used in other frameworks";
    };

    mlib = buildHaxeLib {
      libname = "mlib";
      version = "2.0.2";
      sha256 = "1gnyk19kfhmyssj9c2cfb4mh7vp67h2pifhmcayr2dx3860sp28h";
      meta.description = "Cross platform unit testing framework for Haxe with metadata test markup and tools for generating, compiling and running tests from the command line";
    };

    mconsole = buildHaxeLib {
      libname = "mconsole";
      version = "1.6.0";
      sha256 = "11s40dhfzxqq3vydprhh2iw62gff6h2w25xl1jz2vzs5ng9h64l2";
      meta.description = "Cross platform Haxe implementation of the WebKit console API";
    };

    mcover = buildHaxeLib {
      libname = "mcover";
      version = "2.1.1";
      sha256 = "09agn0la9pc0nbhw0slnzy7cdizpabqy3maarmjkdg7a30hc9idy";
      meta.description = "Cross platform code coverage framework for Haxe with testing and profiling applications";
    };

    munit = buildHaxeLib {
      libname = "munit";
      version = "2.1.2";
      sha256 = "1dagsv871ky0crwpx8w3dqnz1kmcnfpz029bl62hryyq16dpn86d";
      meta.description = "Cross platform unit testing framework";
    };

    hashlink = buildHaxeLib {
      libname = "hashlink";
      version = "0.1.0";
      sha256 = "0agb7snxwh74mkjif6vk2i5jf224acd13dcn3090krxphyvc9jj6";
      meta.description = "Hashlink support library";
    };

    box2d = buildHaxeLib {
      libname = "box2d";
      version = "1.2.3";
      sha256 = "14ws3qsiajahz5f4cxnc0qc7cpr8a4j2pk59mcfb80wlhxf9wfmv";
      meta.description = "Tremendously popular physics engine for most platforms";
    };

    layout = buildHaxeLib {
      libname = "layout";
      version = "1.2.1";
      sha256 = "0ns8h060d4nx7pri1b1ydkb9d1523aj9ja5gmjq2x54r07vkhcny";
      meta.description = "Flexible system for fluid resizing layouts";
    };

    electron = buildHaxeLib {
      libname = "electron";
      version = "1.1.1";
      sha256 = "1yppx9z0li7iv3kcb8sgzb4cwkzg8z6nxsn3ihiq8wxbc0na2jjv";
      meta.description = "Externs for the electron framework";
    };

    slambda = buildHaxeLib {
      libname = "slambda";
      version = "0.8.5";
      sha256 = "1419vwmmdmkfmdzw4z5z0xyql2rm0bc06gg2sshl1ibgawcjvc5s";
      meta.description = "Short Lambda expressions in a tiny library";
    };

    unifill = buildHaxeLib {
      libname = "unifill";
      version = "0.4.1";
      sha256 = "1l4cvq01amdsxrjfzrl8s1jnlqckfl4znxxi4cdxk25hdyra73sw";
      meta.description = "Library for Unicode string support";
    };

    haxe-strings = buildHaxeLib {
      libname = "haxe-strings";
      version = "4.0.0";
      sha256 = "1g0g9ljwbp2cla3mq3ha35z5mwj2k1c1zf25iw1f5743asbag8f8";
      meta.description = "Library for consistent cross-platform UTF-8 string manipulation";
    };

    spinehaxe = buildHaxeLib {
      libname = "spinehaxe";
      version = "3.5.0";
      sha256 = "1sqvyl1p8a13xgd9d4pvm8cmhkq13rf6yc639lanajris0zwisx7";
      meta.description = "Spine runtime for Haxe";
    };

    nape = buildHaxeLib {
      libname = "nape";
      version = "2.0.20";
      sha256 = "16aa787yjymnv1l17hb5p45m148nnd5ayfi083i34z7kfi7yxg32";
      meta.description = "Nape 2D Physics Engine";
    };

    poly2trihx = buildHaxeLib {
      libname = "poly2trihx";
      version = "0.1.4";
      sha256 = "0s9iyqrfyxqmp0hvp3lg702rrqbyp5b9iwayh6g6rab22cs99h4i";
      meta.description = "Haxe port of the poly2tri library, an excellent Delaunay triangulation library, which supports constrained edges and holes";
    };

    systools = buildHaxeLib {
      libname = "systools";
      version = "1.1.0";
      sha256 = "10rajqqzmyb606dpjrjqivvj3kl5gpcl9hccscpa24xp0ijnx38n";
      meta.description = "Cross-platform extension to the Neko VM for accessing system APIs";
    };

    task = buildHaxeLib {
      libname = "task";
      version = "1.0.7";
      sha256 = "1kr9gv842dk5xiqaaly67lrxi9fq6dayfhipj12aww23337h015n";
      meta.description = "Use the Task and TaskList API to simplify asynchronous tasks";
    };

    air3 = buildHaxeLib {
      libname = "air3";
      version = "0.0.1";
      sha256 = "0x8riacldqrg881jyzvx1j4wq095dlspkc5zh8jz4vdzmknadid0";
      meta.description = "Externs for Adobe AIR3";
    };

    hxsl = buildHaxeLib {
      libname = "hxsl";
      version = "2.0.5";
      sha256 = "09pxixgcnbs8197v11vwwrm0xcaznqz40ar2i2jybb293fm9yl85";
      meta.description = "Haxe high level shader library";
      propagatedBuildInputs = [ format ];
    };

    flambe = buildHaxeLib {
      libname = "flambe";
      version = "4.1.0";
      sha256 = "184ra0hbxnsnyhzqycvbzycw0f64bcaj2jdwyqcp46jk50v55bb7";
      meta.description = "Fast, expressive, and cross-platform engine for HTML5 and Flash games";
      propagatedBuildInputs = [ air3 hxsl ];
    };

    perf_js = buildHaxeLib {
      libname = "perf.js";
      version = "1.1.8";
      sha256 = "1zd25zrjrvriq7hrg3vlays9is7296imk21csf669pmplzfl4sfc";
      meta.description = "Simple FPS and Memory monitor";
    };

    pixijs = buildHaxeLib {
      libname = "pixijs";
      version = "4.5.1";
      sha256 = "19kllv67bh5vdvagnqvpqd5jmvm9m8krx33kmy425acvfnhslaxk";
      meta.description = "Externs of pixi.js v4.x for Haxe - JavaScript 2D webGL renderer with canvas fallback";
      propagatedBuildInputs = [ perf_js ];
    };

    HtmlParser = buildHaxeLib {
      libname = "HtmlParser";
      version = "3.3.0";
      sha256 = "0bw18cgxng33avwmcbxpjxk75k2grxpa1sp693b65by2y3k3gv8w";
      meta.description = "HTML/XML parser with a jQuery-like find() method";
    };

    stdlib = buildHaxeLib {
      libname = "stdlib";
      version = "2.2.0";
      sha256 = "1yk6n00wrpa0zjw3nx3627mzn4g17fd4k6ngw5a5gmn20r8ql41s";
      meta.description = "Standard library improvements: exceptions, string triming with a trimed chars specified, min/max for integers and so on";
    };

    mcli = buildHaxeLib {
      libname = "mcli";
      version = "0.1.6";
      sha256 = "0chq5gs7pkqqnh2fl7i8h16kv3dqrhnpbvjyil33ig9ddn3vnkad";
      meta.description = "A simple command-line object mapper";
    };

    waud = buildHaxeLib {
      libname = "waud";
      version = "0.9.9";
      sha256 = "013d45mqc0by0irmb5fhzbv23lpd4ji3pzvmp9zhwrz3a55gdwqx";
      meta.description = "Web Audio Library";
    };

    struct = buildHaxeLib {
      libname = "struct";
      version = "0.11.0";
      sha256 = "1dj5zjgfzvxsbbrf3fha0rc5bz7ib1n9ci92v457gdmgp7sbbwav";
      meta.description = "Data Structures and Algorithms";
    };

    compiletime = buildHaxeLib {
      libname = "compiletime";
      version = "2.7.0";
      sha256 = "06mhd8rwxxmflj6g2x0rffr9li6dalxvbm2zvncfgq1rsa9zyg0s";
      meta.description = "Simple Haxe Macro Helpers that let you do or get things at compile-time";
    };

    thx_core = buildHaxeLib {
      libname = "thx.core";
      version = "0.42.1";
      sha256 = "1wan3w1avi5c9w2gaph6alidvhpwz6jpgl3yqd92hwivlsh558qn";
      meta.homepage = http://thx-lib.org/;
      meta.description = "General purpose library. It contains extensions to many of the types contained in the standard library as well as new complementary types";
    };

    thx_color = buildHaxeLib {
      libname = "thx.color";
      version = "0.19.1";
      sha256 = "0r0rq0gsky9n4pm6ridvb8brx8358v7y9kdd6nhas3ckzg3z7g5z";
      meta.description = "Library for color manipulation";
      propagatedBuildInputs = [ thx_core ];
    };

    thx_csv = buildHaxeLib {
      libname = "thx.csv";
      version = "0.2.0";
      sha256 = "1q9nfgq8mhiqqsavz4jb0kl7r31gm2xl6g5888k24m8fwhhn5yas";
      meta.description = "CSV parsing and writing libraries. Also supports DSV and TSV";
      propagatedBuildInputs = [ thx_core ];
    };

    thx_culture = buildHaxeLib {
      libname = "thx.culture";
      version = "0.5.0";
      sha256 = "1jz6lnw4yh932lwy5jws0dlf7ca5dl3by0gbxncgl54z5mn032qh";
      meta.description = "Localization library";
      propagatedBuildInputs = [ thx_core ];
    };

    thx_format = buildHaxeLib {
      libname = "thx.format";
      version = "0.6.0";
      sha256 = "0zj9kxl1dzli34vc8av2xwkj73iqf7rfzdp0hs1603kp9i901wfi";
      meta.description = "Formatting library (Numbers and Dates)";
      propagatedBuildInputs = [ thx_culture ];
    };

    thx_promise = buildHaxeLib {
      libname = "thx.promise";
      version = "0.6.0";
      sha256 = "15yizzmf32n0092bfnjr3g1zlqqy7q5x03scabhi5cvnimvadhap";
      meta.description = "Library for lightweight promises and futures.";
      propagatedBuildInputs = [ thx_core ];
    };

    thx_stream = buildHaxeLib {
      libname = "thx.stream";
      version = "0.6.1";
      sha256 = "0vgwgw7xcnfqnnvid33q5h8i53ipjl2msw9w4nfykia4hhxjxl3p";
      meta.description = "Stream library for Haxe";
      propagatedBuildInputs = [ thx_promise ];
    };

    thx_semver = buildHaxeLib {
      libname = "thx.semver";
      version = "0.2.2";
      sha256 = "0jykj6kxfxycn2dhyyqpn051z8qnbzzghbiv25b96l9wlf0xivq4";
      meta.description = "Semantic version library for Haxe";
    };

    thx_unit = buildHaxeLib {
      libname = "thx.unit";
      version = "0.8.0";
      sha256 = "1478g2xyvqv5ggnsq7vmqdxm2n5rigsd0r56p7mi04wwb1hrhzca";
      meta.description = "Library for unit of measurements";
      propagatedBuildInputs = [ thx_core ];
    };

    hscript = let
      libname = "hscript";
      version = "2.0.7";
    in stdenv.mkDerivation rec {
      name = "${libname}-${version}";
      src = fetchFromGitHub {
        owner = "HaxeFoundation";
        repo = "hscript";
        rev = "7708159";
        sha256 = "1j7f4m8wmw0c2zjz7m96q2mwl22dg7m9bl1byqysjmj83gy9nj7k";
      };
      buildInputs = [ haxe neko hxcpp hxjava hxcs nodejs wine php python3 ];
      buildPhase = ''
        ${simulateHaxelibDev "hscript"}
        (cd script; haxe build.hxml)
      '';
      doCheck = true;
      checkPhase = ''
        haxe bin/build-interp.hxml
        haxe bin/build-neko.hxml         && neko bin/Test.n
        haxe bin/build-js.hxml           && node bin/Test.js
        haxe bin/build-java.hxml         && java -jar bin/Test.jar
        ( export HOME=$(mktemp -d)
          haxe bin/build-cs.hxml           && wine bin/bin/Test.exe )
        haxe bin/build-cpp.hxml          && bin/Test
        #BROKEN# haxe bin/build-flash.hxml -D fdb && haxe flash/run.hxml bin/Test.swf
        haxe bin/build-php.hxml          && php bin/index.php
        haxe bin/build-python.hxml       && python bin/Test.py
      '';
      installPhase = installLibHaxe { inherit libname version; files = "hscript script extraParams.hxml haxelib.json README.md run.n"; };
      meta = {
        homepage = "http://lib.haxe.org/p/${libname}";
        license = stdenv.lib.licenses.bsd2;
        platforms = stdenv.lib.platforms.all;
        description = "Haxe Script is a scripting engine for a subset of the Haxe language";
      };
    };

    hxparse = let
      libname = "hxparse";
      version = "3.2.1.0";
    in stdenv.mkDerivation rec {
      name = "${libname}-${version}";
      src = fetchFromGitHub {
        owner = "Simn";
        repo = "hxparse";
        rev = "1343cc9";
        sha256 = "04nj7g3viiqmdijk6ssginx4khz5b80minzbk98s1fyvadj1frx5";
      };
      buildInputs = [ haxe neko unifill hxcpp hxjava hxcs ];
      doCheck = false;
      checkPhase = ''
        ${simulateHaxelibDev "hxparse"}
        haxe -cp src -cp test -main Test -dce full -lib unifill  -D dump=pretty -neko bin/hxparse.n
        haxe -cp src -cp test -main Test -dce full -lib unifill  -swf bin/hxparse.swf
        haxe -cp src -cp test -main Test -dce full -lib unifill  -swf-version 8 -swf bin/hxparse8.swf
        haxe -cp src -cp test -main Test -dce full -lib unifill  -js bin/hxparse.js
        haxe -cp src -cp test -main Test -dce full -lib unifill  -php bin/php
        haxe -cp src -cp test -main Test -dce full -lib unifill  -cpp bin/cpp
        #BROKEN# haxe -cp src -cp test -main Test -dce full -lib unifill  -java bin/java
        haxe -cp src -cp test -main Test -dce full -lib unifill  -cs bin/cs
        haxe -cp src -cp test -main Test -dce full -lib unifill  -python bin/hxparse.py
      '';
      installPhase = installLibHaxe { inherit libname version; };
      meta = {
        homepage = "http://lib.haxe.org/p/${libname}";
        license = stdenv.lib.licenses.bsd2;
        platforms = stdenv.lib.platforms.all;
        description = "This library provides tools for creating lexers and parsers in haxe";
      };
    };

    haxeparser = let
      libname = "haxeparser";
      version = "3.3.0";
    in stdenv.mkDerivation rec {
      name = "${libname}-${version}";
      src = fetchFromGitHub {
        owner = "Simn";
        repo = "haxeparser";
        rev = "9be07a2";
        sha256 = "11272lnyk4ilf9qlkfgnirsmjy681gmaaw0wzaaypchidj0mm7xv";
      };
      buildInputs = [ haxe neko hxparse ];
      doCheck = true;
      checkPhase = ''
        ${simulateHaxelibDev "haxeparser"}
        haxe build.hxml
      '';
      installPhase = installLibHaxe { inherit libname version; };
      meta = {
        homepage = "http://lib.haxe.org/p/${libname}";
        license = stdenv.lib.licenses.bsd2;
        platforms = stdenv.lib.platforms.all;
        description = "A Haxe parser";
      };
    };

    inherit (callPackage ../development/haxe-modules/snowkit.nix { })
      flow
      linc_openal
      linc_timestamp
      linc_stb
      linc_ogg
      linc_sdl
      linc_opengl
      snow
      luxe;

    inherit (callPackage ../development/haxe-modules/openfl { webify = haskellPackages.webify; })
      lime
      lime-samples
      openfl
      openfl-samples;

    inherit (callPackage ../development/haxe-modules/openfl/3.6.nix { webify = haskellPackages.webify; })
      lime_2_9
      openfl_3_6;

    inherit (callPackage ../development/haxe-modules/nme.nix { })
      gm2d
      nme;

    inherit (callPackage ../development/haxe-modules/flixel.nix { })
      flixel
      flixel-ui
      flixel-addons
      flixel-tools
      flixel-templates
      flixel-demos;

    inherit (callPackage ../development/haxe-modules/haxeui.nix { })
      haxeui-core
      haxeui-flixel
      haxeui-openfl
      haxeui-luxe
      haxeui-flambe
      haxeui-pixijs
      haxeui-html5
      haxeui-nme
      haxeui-kha
      haxeui-xwt
      haxeui-hxwidgets
      hxWidgets;

  };
in self
