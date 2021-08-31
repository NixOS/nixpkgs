{ lib, stdenv, fetchFromGitHub
, neko
, nodejs
, pkgsi686Linux
, pkgsStatic
, pkgsMusl
, llvmPackages
, python2, python3
, lua52Packages, lua53Packages, luajitPackages
, php74, php80
, jre8, jdk11
, mono4, mono5, mono6
, haxe41Packages, haxe42Packages
}:

let
  src = fetchFromGitHub {
    owner = "lukaskj";
    repo = "haxe-example";
    rev = "8158623a0918d7f5ea2a8dd3e0e5bb16f91c4e48";
    sha256 = "02qkfnh7cwsqan52ajvipgng2k0mfk13059k6g0mvxdhd96k40h9";
  };
  generic = { haxePackages }: {
    run = stdenv.mkDerivation {
      pname = "haxe-example-run";
      inherit (haxePackages.haxe) version;
      inherit src;
      nativeBuildInputs = [ haxePackages.haxe ];
      doInstallCheck = true;
      installCheckPhase = "haxe run.hxml";
    };

    neko-bytecode = stdenv.mkDerivation {
      pname = "haxe-example-neko-bytecode";
      inherit (haxePackages.haxe) version;
      inherit src;
      nativeBuildInputs = [ haxePackages.haxe neko ];
      buildPhase = "haxe build-executable.hxml";
      installPhase = "install -Dm444 -t ${placeholder "out"} dist/neko/build.n";
      doInstallCheck = true;
      installCheckPhase = "neko ${placeholder "out"}/build.n";
    };
    neko-exe = stdenv.mkDerivation {
      pname = "haxe-example-neko-exe";
      inherit (haxePackages.haxe) version;
      inherit src;
      nativeBuildInputs = [ haxePackages.haxe neko ];
      buildPhase = "haxe build-executable.hxml";
      installPhase = "install -D -t ${placeholder "out"} dist/neko/build";
      doInstallCheck = true;
      installCheckPhase = "${placeholder "out"}/build";
    };

    hashlink-bytecode = stdenv.mkDerivation {
      pname = "haxe-example-hashlink-bytecode";
      inherit (haxePackages.haxe) version;
      inherit src;
      nativeBuildInputs = [ haxePackages.haxe haxePackages.hashlink ];
      buildPhase = "haxe -hl Main.hl -cp src -main Main";
      installPhase = "install -Dm444 -t ${placeholder "out"} Main.hl";
      doInstallCheck = true;
      installCheckPhase = "hl ${placeholder "out"}/Main.hl";
    };
    hashlink-exe = stdenv.mkDerivation {
      pname = "haxe-example-hashlink-exe";
      inherit (haxePackages.haxe) version;
      inherit src;
      nativeBuildInputs = [ haxePackages.haxe haxePackages.hashlink ];
      buildPhase = ''
        haxe -hl src/_main.c -cp src -main Main
        gcc -Wall -O3 -Isrc -lhl -o hlc src/_main.c
      '';
      installPhase = "install -D -t ${placeholder "out"} hlc";
      doInstallCheck = true;
      installCheckPhase = "${placeholder "out"}/hlc";
    };

    js = stdenv.mkDerivation {
      pname = "haxe-example-js";
      inherit (haxePackages.haxe) version;
      inherit src;
      postPatch = ''substituteInPlace src/Main.hx --replace 'Sys.systemName()' '"Sys.systemName()"' '';  # https://github.com/lukaskj/haxe-example/issues/1
      nativeBuildInputs = [ haxePackages.haxe haxePackages.hxnodejs_12 ];
      buildPhase = "haxe build-js.hxml";
      installPhase = "install -Dm444 -t ${placeholder "out"} dist/build.js";
      doInstallCheck = true;
      installCheckInputs = [ nodejs ];
      installCheckPhase = "node ${placeholder "out"}/build.js";
    };
  } // (
    lib.mapAttrs (name: {python}:
      stdenv.mkDerivation {
        pname = "haxe-example-${name}";
        inherit (haxePackages.haxe) version;
        inherit src;
        nativeBuildInputs = [ haxePackages.haxe ];
        buildPhase = "haxe build-python.hxml";
        installPhase = "install -Dm444 -t ${placeholder "out"} dist/build.py";
        doInstallCheck = true;
        installCheckInputs = [ python ];
        installCheckPhase = "python ${placeholder "out"}/build.py";
        meta.broken = haxePackages.haxe.version == "4.2.3"; # the loop never ends
      })
    {
      python2 = { python = python2; };
      python3 = { python = python3; };
    }
  ) // (
    lib.mapAttrs (name: {stdenv}:
      stdenv.mkDerivation {
        pname = "haxe-example-${name}";
        inherit (haxePackages.haxe) version;
        inherit src;
        nativeBuildInputs = [ haxePackages.haxe haxePackages.hxcpp ];
        buildPhase = "haxe build-cpp.hxml";
        installPhase = "install -Dt ${placeholder "out"} dist/cpp/Main";
        doInstallCheck = true;
        installCheckPhase = "${placeholder "out"}/Main";
      })
    {
      cpp        = { stdenv = stdenv; };
      cpp-32     = { stdenv = pkgsi686Linux.stdenv; };
      cpp-static = { stdenv = pkgsStatic.stdenv; };
      cpp-musl   = { stdenv = pkgsMusl.stdenv; };
      cpp-clang  = { stdenv = llvmPackages.stdenv; };
    }
  ) // (
    lib.mapAttrs (name: {php}:
      stdenv.mkDerivation {
        pname = "haxe-example-${name}";
        inherit (haxePackages.haxe) version;
        inherit src;
        nativeBuildInputs = [ haxePackages.haxe ];
        buildPhase = "haxe build-php.hxml";
        installPhase = "cp -r dist/php ${placeholder "out"}";
        doInstallCheck = true;
        installCheckInputs = [ php ];
        installCheckPhase = "php ${placeholder "out"}/index.php";
      })
    {
      php74 = { php = php74; };
      php80 = { php = php80; };
    }
  ) // (
    lib.mapAttrs (name: {luaPackages}:
      stdenv.mkDerivation {
        pname = "haxe-example-${name}";
        inherit (haxePackages.haxe) version;
        inherit src;
        nativeBuildInputs = [ haxePackages.haxe ];
        buildPhase = "haxe build-lua.hxml";
        installPhase = "install -Dm444 -t ${placeholder "out"} dist/build.lua";
        doInstallCheck = true;
        installCheckInputs = [ luaPackages.lua luaPackages.luautf8 ];
        installCheckPhase = "lua ${placeholder "out"}/build.lua";
      })
    {
      lua52  = { luaPackages = lua52Packages;  };
      lua53  = { luaPackages = lua53Packages;  };
      luajit = { luaPackages = luajitPackages; };
    }
  ) // (
    lib.mapAttrs (name: {jre}:
      stdenv.mkDerivation {
        pname = "haxe-example-${name}";
        inherit (haxePackages.haxe) version;
        inherit src;
        nativeBuildInputs = [ haxePackages.haxe haxePackages.hxjava ];
        buildPhase = "haxe build-java.hxml";
        installPhase = "install -Dm444 -t ${placeholder "out"} dist/java/Main.jar";
        doInstallCheck = true;
        installCheckInputs = [ jre ];
        installCheckPhase = "java -jar ${placeholder "out"}/Main.jar";
      })
    {
      java8  = { jre = jre8;  };
      java11 = { jre = jdk11; };
    }
  ) // (
    lib.mapAttrs (name: {mono}:
      stdenv.mkDerivation {
        pname = "haxe-example-${name}";
        inherit (haxePackages.haxe) version;
        inherit src;
        nativeBuildInputs = [ haxePackages.haxe haxePackages.hxcs ];
        buildPhase = "haxe build-cs.hxml";
        installPhase = "install -Dm444 -t ${placeholder "out"} dist/cs/bin/Main.exe";
        doInstallCheck = true;
        installCheckInputs = [ mono ];
        installCheckPhase = "mono ${placeholder "out"}/Main.exe";
      })
    {
      mono4  = { mono = mono4; };
      mono5  = { mono = mono5; };
      mono6  = { mono = mono6; };
    }
  );
in {
  haxe-example_4_1 = generic { haxePackages = haxe41Packages; };
  haxe-example_4_2 = generic { haxePackages = haxe42Packages; };
}
