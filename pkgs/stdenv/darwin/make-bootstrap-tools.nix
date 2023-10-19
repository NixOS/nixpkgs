{ pkgspath ? ../../.., test-pkgspath ? pkgspath
, localSystem ? { system = builtins.currentSystem; }
, crossSystem ? null
, bootstrapFiles ? null
}:

let cross = if crossSystem != null
      then { inherit crossSystem; }
      else {};
    custom-bootstrap = if bootstrapFiles != null
      then { stdenvStages = args:
              let args' = args // { bootstrapFiles = bootstrapFiles; };
              in (import "${pkgspath}/pkgs/stdenv/darwin" args');
           }
      else {};
in with import pkgspath ({ inherit localSystem; } // cross // custom-bootstrap);

let
  llvmPackages = llvmPackages_11;
in rec {
  coreutils_ = coreutils.override (args: {
    # We want coreutils without ACL support.
    aclSupport = false;
    # Cannot use a single binary build, or it gets dynamically linked against gmp.
    singleBinary = false;
  });

  cctools_ = darwin.cctools;

  # Avoid debugging larger changes for now.
  bzip2_ = bzip2.override (args: { linkStatic = true; });

  # Avoid messing with libkrb5 and libnghttp2.
  curl_ = curlMinimal.override (args: { gssSupport = false; http2Support = false; });

  build = stdenv.mkDerivation {
    name = "stdenv-bootstrap-tools";

    nativeBuildInputs = [ nukeReferences dumpnar ];

    buildCommand = ''
      mkdir -p $out/bin $out/lib $out/lib/system $out/lib/darwin

      ${lib.optionalString stdenv.targetPlatform.isx86_64 ''
        # Copy libSystem's .o files for various low-level boot stuff.
        cp -d ${lib.getLib darwin.Libsystem}/lib/*.o $out/lib

        # Resolv is actually a link to another package, so let's copy it properly
        cp -L ${lib.getLib darwin.Libsystem}/lib/libresolv.9.dylib $out/lib
      ''}

      cp -rL ${darwin.Libsystem}/include $out
      chmod -R u+w $out/include
      cp -rL ${darwin.ICU}/include* $out/include
      cp -rL ${libiconv}/include/* $out/include
      cp -rL ${lib.getDev gnugrep.pcre2}/include/* $out/include
      mv $out/include $out/include-Libsystem

      # Copy coreutils, bash, etc.
      cp ${coreutils_}/bin/* $out/bin
      (cd $out/bin && rm vdir dir sha*sum pinky factor pathchk runcon shuf who whoami shred users)

      cp ${bash}/bin/bash $out/bin
      ln -s bash $out/bin/sh
      cp ${findutils}/bin/find $out/bin
      cp ${findutils}/bin/xargs $out/bin
      cp -d ${diffutils}/bin/* $out/bin
      cp -d ${gnused}/bin/* $out/bin
      cp -d ${gnugrep}/bin/grep $out/bin
      cp ${gawk}/bin/gawk $out/bin
      cp -d ${gawk}/bin/awk $out/bin
      cp ${gnutar}/bin/tar $out/bin
      cp ${gzip}/bin/.gzip-wrapped $out/bin/gzip
      cp ${bzip2_.bin}/bin/bzip2 $out/bin
      ln -s bzip2 $out/bin/bunzip2
      cp -d ${gnumake}/bin/* $out/bin
      cp -d ${patch}/bin/* $out/bin
      cp -d ${xz.bin}/bin/xz $out/bin
      cp ${cpio}/bin/cpio $out/bin

      # This used to be in-nixpkgs, but now is in the bundle
      # because I can't be bothered to make it partially static
      cp ${curl_.bin}/bin/curl $out/bin
      cp -d ${curl_.out}/lib/libcurl*.dylib $out/lib
      cp -d ${libssh2.out}/lib/libssh*.dylib $out/lib
      cp -d ${lib.getLib openssl}/lib/*.dylib $out/lib

      cp -d ${gnugrep.pcre2.out}/lib/libpcre2*.dylib $out/lib
      cp -d ${lib.getLib libiconv}/lib/lib*.dylib $out/lib
      cp -d ${lib.getLib gettext}/lib/libintl*.dylib $out/lib
      chmod +x $out/lib/libintl*.dylib
      cp -d ${ncurses.out}/lib/libncurses*.dylib $out/lib
      cp -d ${libxml2.out}/lib/libxml2*.dylib $out/lib

      # Copy what we need of clang
      cp -d ${llvmPackages.clang-unwrapped}/bin/clang* $out/bin
      cp -rd ${lib.getLib llvmPackages.clang-unwrapped}/lib/* $out/lib

      cp -d ${lib.getLib llvmPackages.libcxx}/lib/libc++*.dylib $out/lib
      cp -d ${lib.getLib llvmPackages.libcxxabi}/lib/libc++abi*.dylib $out/lib
      cp -d ${lib.getLib llvmPackages.compiler-rt}/lib/darwin/libclang_rt* $out/lib/darwin
      cp -d ${lib.getLib llvmPackages.compiler-rt}/lib/libclang_rt* $out/lib
      cp -d ${lib.getLib llvmPackages.llvm.lib}/lib/libLLVM.dylib $out/lib
      cp -d ${lib.getLib libffi}/lib/libffi*.dylib $out/lib

      mkdir $out/include
      cp -rd ${llvmPackages.libcxx.dev}/include/c++     $out/include

      # copy .tbd assembly utils
      cp -d ${pkgs.darwin.rewrite-tbd}/bin/rewrite-tbd $out/bin
      cp -d ${lib.getLib pkgs.libyaml}/lib/libyaml*.dylib $out/lib

      # copy package extraction tools
      cp -d ${pkgs.pbzx}/bin/pbzx $out/bin
      cp -d ${lib.getLib pkgs.xar}/lib/libxar*.dylib $out/lib
      cp -d ${pkgs.bzip2.out}/lib/libbz2*.dylib $out/lib

      # copy sigtool
      cp -d ${pkgs.darwin.sigtool}/bin/sigtool $out/bin
      cp -d ${pkgs.darwin.sigtool}/bin/codesign $out/bin

      cp -d ${lib.getLib darwin.ICU}/lib/libicu*.dylib $out/lib
      cp -d ${zlib.out}/lib/libz.*       $out/lib
      cp -d ${gmpxx.out}/lib/libgmp*.*   $out/lib
      cp -d ${xz.out}/lib/liblzma*.*     $out/lib

      # Copy binutils.
      for i in as ld ar ranlib nm strip otool install_name_tool lipo codesign_allocate; do
        cp ${cctools_}/bin/$i $out/bin
      done

      cp -d ${lib.getLib darwin.libtapi}/lib/libtapi* $out/lib

      cp -rd ${pkgs.darwin.CF}/Library $out
      ${lib.optionalString stdenv.targetPlatform.isAarch64 ''
        cp -rd ${pkgs.darwin.libobjc}/lib/* $out/lib/
      ''}

      chmod -R u+w $out

      nuke-refs $out/bin/*

      rpathify() {
        local libs=$(${stdenv.cc.targetPrefix}otool -L "$1" | tail -n +2 | grep -o "$NIX_STORE.*-\S*") || true
        local newlib
        for lib in $libs; do
          ${stdenv.cc.targetPrefix}install_name_tool -change $lib "@rpath/$(basename "$lib")" "$1"
        done
      }

      # Strip executables even further
      for i in $out/bin/*; do
        if [[ ! -L $i ]] && isMachO "$i"; then
          chmod +w $i
          ${stdenv.cc.targetPrefix}strip $i || true
        fi
      done

      for i in $out/bin/* $out/lib/*.dylib $out/lib/darwin/*.dylib; do
        if [[ ! -L "$i" ]]; then
          rpathify $i
        fi
      done

      for i in $out/bin/*; do
        if [[ ! -L "$i" ]] && isMachO "$i"; then
          ${stdenv.cc.targetPrefix}install_name_tool -add_rpath '@executable_path/../lib' $i
        fi
      done

      ${if stdenv.targetPlatform.isx86_64 then ''
        rpathify $out/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation
      '' else ''
        sed -i -e 's|/nix/store/.*/libobjc.A.dylib|@executable_path/../libobjc.A.dylib|g' \
          $out/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation.tbd
      ''}

      nuke-refs $out/lib/*
      nuke-refs $out/lib/system/*
      nuke-refs $out/lib/darwin/*
      ${lib.optionalString stdenv.targetPlatform.isx86_64 ''
        nuke-refs $out/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation
      ''}

      mkdir $out/.pack
      mv $out/* $out/.pack
      mv $out/.pack $out/pack

      mkdir $out/on-server
      dumpnar $out/pack | ${xz}/bin/xz > $out/on-server/bootstrap-tools.nar.xz
    '';

    allowedReferences = [];

    meta = {
      maintainers = [ lib.maintainers.copumpkin ];
    };
  };

  dist = stdenv.mkDerivation {
    name = "stdenv-bootstrap-tools";

    buildCommand = ''
      mkdir -p $out/nix-support
      echo "file tools ${build}/on-server/bootstrap-tools.nar.xz" >> $out/nix-support/hydra-build-products
    '';
  };

  bootstrapFiles = {
    tools = "${build}/pack";
  };

  bootstrapTools = derivation {
    inherit (stdenv.hostPlatform) system;

    name = "bootstrap-tools";
    builder = "${bootstrapFiles.tools}/bin/bash";

    # This is by necessity a near-duplicate of patch-bootstrap-tools.sh. If we refer to it directly,
    # we can't make any changes to it due to our testing stdenv depending on it. Think of this as the
    # patch-bootstrap-tools.sh for the next round of bootstrap tools.
    args = [ ./patch-bootstrap-tools-next.sh ];

    inherit (bootstrapFiles) tools;

    allowedReferences = [ "out" ];
  };

  test = stdenv.mkDerivation {
    name = "test";

    realBuilder = "${bootstrapTools}/bin/bash";

    tools = bootstrapTools;
    buildCommand = ''
      # Create a pure environment where we use just what's in the bootstrap tools.
      export PATH=$tools/bin

      ls -l
      mkdir $out
      mkdir $out/bin
      sed --version
      find --version
      diff --version
      patch --version
      make --version
      awk --version
      grep --version
      clang --version
      xz --version

      # The grep will return a nonzero exit code if there is no match, and we want to assert that we have
      # an SSL-capable curl
      curl --version | grep SSL

      # This approximates a bootstrap version of libSystem can that be
      # assembled via fetchurl. Adapted from main libSystem expression.
      mkdir libSystem-boot
      cp -vr \
        ${stdenv.cc.libc_dev}/lib/libSystem.B.tbd \
        ${stdenv.cc.libc_dev}/lib/system \
        libSystem-boot

      substituteInPlace libSystem-boot/libSystem.B.tbd \
        --replace "/usr/lib/system/" "$PWD/libSystem-boot/system/"
      ln -s libSystem.B.tbd libSystem-boot/libSystem.tbd
      # End of bootstrap libSystem

      export flags="-idirafter $tools/include-Libsystem --sysroot=$tools -L$tools/lib -L$PWD/libSystem-boot"

      export CPP="clang -E $flags"
      export CC="clang $flags -rpath $tools/lib"
      export CXX="clang++ $flags --stdlib=libc++ -lc++abi -isystem$tools/include/c++/v1 -rpath $tools/lib"

      # NOTE: These tests do a separate 'install' step (using cp), because
      # having clang write directly to the final location apparently will make
      # running the executable fail signature verification. (SIGKILL'd)
      #
      # Suspect this is creating a corrupt entry in the kernel cache, but it is
      # unique to cctools ld. (The problem goes away with `-fuse-ld=lld`.)

      echo '#include <stdio.h>' >> hello1.c
      echo '#include <float.h>' >> hello1.c
      echo '#include <limits.h>' >> hello1.c
      echo 'int main() { printf("Hello World\n"); return 0; }' >> hello1.c
      $CC -o hello1 hello1.c
      cp hello1 $out/bin/
      $out/bin/hello1

      echo '#include <CoreFoundation/CoreFoundation.h>' >> hello2.c
      echo 'int main() { CFShow(CFSTR("Hullo")); return 0; }' >> hello2.c
      $CC -F$tools/Library/Frameworks -framework CoreFoundation -o hello2 hello2.c
      cp hello2 $out/bin/
      $out/bin/hello2

      echo '#include <iostream>' >> hello3.cc
      echo 'int main() { std::cout << "Hello World\n"; }' >> hello3.cc
      $CXX -v -o hello3 hello3.cc
      cp hello3 $out/bin/
      $out/bin/hello3

      tar xvf ${hello.src}
      cd hello-*
      # stdenv bootstrap tools ship a broken libiconv.dylib https://github.com/NixOS/nixpkgs/issues/158331
      am_cv_func_iconv=no ./configure --prefix=$out
      make
      make install
      $out/bin/hello
    '';
  };

  # The ultimate test: bootstrap a whole stdenv from the tools specified above and get a package set out of it
  # TODO: uncomment once https://github.com/NixOS/nixpkgs/issues/222717 is resolved
  /*
  test-pkgs = import test-pkgspath {
    # if the bootstrap tools are for another platform, we should be testing
    # that platform.
    localSystem = if crossSystem != null then crossSystem else localSystem;

    stdenvStages = args: let
        args' = args // { inherit bootstrapFiles; };
      in (import (test-pkgspath + "/pkgs/stdenv/darwin") args');
  };
  */
}
