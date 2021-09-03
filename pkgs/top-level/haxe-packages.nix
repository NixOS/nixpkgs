{ stdenv, lib, fetchzip, fetchFromGitHub, haxe, neko, libuv, SDL2, zlib, libjpeg, libpng, libvorbis, libGL, libGLU, openal, mbedtls, mesa, sqlite }:

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
      sha256,
      meta ? {},
      ...
    } @ attrs:
      stdenv.mkDerivation (attrs // {
        pname = libname;
        inherit version;

        buildInputs = (attrs.buildInputs or []) ++ [ haxe neko ]; # for setup-hook.sh to work
        src = fetchzip rec {
          name = "${libname}-${version}";
          url = "https://lib.haxe.org/files/3.0/${withCommas name}.zip";
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
          homepage = "https://lib.haxe.org/p/${libname}";
          platforms = lib.platforms.all;
        } // attrs.meta or {};
      });

    inherit haxe;

    hxcpp = buildHaxeLib rec {
      libname = "hxcpp";
      version = "4.2.1";
      sha256 = "10ijb8wiflh46bg30gihg7fyxpcf26gibifmq5ylx0fam4r51lhp";
      postFixup = ''
        # <xlocale> is not available on both glibc and musl, but it looks that there is no __MUSL__ to detect it
        substituteInPlace ${placeholder "out"}/lib/haxe/${withCommas libname}/${withCommas version}/src/hx/libs/std/Sys.cpp --replace \
          '&& !defined(__GLIBC__)' \
          '&& 0'

        for f in ${placeholder "out"}/lib/haxe/${withCommas libname}/${withCommas version}/{,project/libs/nekoapi/}bin/Linux{,64}/*; do
          chmod +w "$f"
          patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker)  "$f" || true
          patchelf --set-rpath       ${ lib.makeLibraryPath [ stdenv.cc.cc ] }  "$f" || true
        done
      '';
      meta.description = "Runtime support library for the Haxe C++ backend";
    };

    hxjava = buildHaxeLib {
      libname = "hxjava";
      version = "4.2.0";
      sha256 = "0y3pbp0khyfm3fscn8amnya6pc7lv6fn0hsghjqg843vjj54xax2";
      meta.description = "Support library for the Java backend of the Haxe compiler";
    };

    hxcs = buildHaxeLib {
      libname = "hxcs";
      version = "4.2.0";
      sha256 = "0sszajl00ll11h2ljvadmsj6cqrjrvylbncd49ma5g6y6fl4c6wf";
      meta.description = "Support library for the C# backend of the Haxe compiler";
    };

    hxnodejs_12 = stdenv.mkDerivation rec {
      pname = "hxnodejs";
      version = "12.1.0";
      src = fetchFromGitHub {
        owner = "HaxeFoundation";
        repo = "hxnodejs";
        rev = version;
        sha256 = "17jy2rdbgrvm0adwdl3szsfm23i2k8dfw902x1xsjq6hzrhn4mdf";
      };
      installPhase = installLibHaxe { libname = pname; inherit version; };
      meta = {
        homepage = "https://lib.haxe.org/p/${pname}";
        platforms = lib.platforms.all;
        description = "Extern definitions for node.js ${version}";
      };
    };

    heaps = self.buildHaxeLib {
      libname = "heaps";
      version = "1.9.1";
      sha256 = "0lmnr3yxknwwawafgv2nwkijvgi0w4smrikv2224gwv1g8m0i4cb";
    };

    format = self.buildHaxeLib {
      libname = "format";
      version = "3.5.0";
      sha256 = "1w6b77f0x0kswvpzhfqxiz9pkk3flgzmzyv6s2qy3qpvwdpppxp6";
    };

    hashlink = stdenv.mkDerivation rec {
      pname = "hashlink";
      version = "1.11";
      src = fetchFromGitHub {
        owner = "HaxeFoundation";
        repo = pname;
        rev = version;
        sha256 = "1bgx8pr062xsy81ygbakm3v033d68dqqx0dgfs0dczdqy8q0039k";
      };
      nativeBuildInputs = [ haxe ];
      buildInputs = [ libuv zlib libpng SDL2 libvorbis libjpeg libGL libGLU openal mbedtls mesa sqlite ];

      buildPhase = ''
        make LIBOPENGL=-lGL
        ( cd other/haxelib; haxe --neko run.n Run.hx )
        ( cd libs/mesa;     make mesa.hdll LLVM_LIBDIR=${mesa.llvmPackages.llvm.lib}/lib MESA_LIBS='-L${mesa.osmesa}/lib -L${mesa}/lib -lGL -lglapi -lOSMesa' )
      '';

      installPhase = ''
        install  -Dm755 -t ${placeholder "out"}/bin hl
        install  -Dm755 -t ${placeholder "out"}/lib libhl.so *.hdll

        # install hashlink support lib
        mkdir -p ${placeholder "out"}/lib/haxe/hashlink/${withCommas version}  ; cp -r other/haxelib/haxelib.json other/haxelib/run.n other/haxelib/Run.hx  ${placeholder "out"}/lib/haxe/hashlink/${withCommas version}  ; echo "${version}" > ${placeholder "out"}/lib/haxe/hashlink/.current
        mkdir -p ${placeholder "out"}/lib/haxe/hlsdl/${withCommas version}     ; cp -r libs/sdl/haxelib.json      libs/sdl/sdl                              ${placeholder "out"}/lib/haxe/hlsdl/${withCommas version}     ; echo "${version}" > ${placeholder "out"}/lib/haxe/hlsdl/.current
        mkdir -p ${placeholder "out"}/lib/haxe/hlopenal/${withCommas version}  ; cp -r libs/openal/haxelib.json   libs/openal/openal                        ${placeholder "out"}/lib/haxe/hlopenal/${withCommas version}  ; echo "${version}" > ${placeholder "out"}/lib/haxe/hlopenal/.current

        # install files to include in generated C-code
        cp -r "$src/src" ${placeholder "out"}/include
      '';

      doInstallCheck = true;
      installCheckInputs = [ self.heaps self.format ];
      installCheckPhase = ''
        ( export HAXELIB_PATH="$HAXELIB_PATH:${placeholder "out"}/lib/haxe"
          haxelib list

          # Run bytecode
          haxe -hl hello.hl -cp other/tests -main HelloWorld -D interp
          ./hl hello.hl

          # Generate C-code
          haxe -hl src/_main.c -cp other/tests -main HelloWorld
          make hlc
          ./hlc

          # Build mesa example
          ( cd libs/mesa
            substituteInPlace sample/Test.hx --replace h3d.scene.DirLight h3d.scene.fwd.DirLight  # fix for news `heaps`
            haxe -cp sample -lib hlsdl -lib heaps -hl test.hl -main Test -D usegl -D usesys )

          # it should fail with "Uncaught exception: Failed to create window"
          ./hl libs/mesa/test.hl  || true
        )
      '';

      meta = {
        description = "Virtual machine for Haxe";
        platforms = lib.platforms.linux;
      };
    };

  };
in self
