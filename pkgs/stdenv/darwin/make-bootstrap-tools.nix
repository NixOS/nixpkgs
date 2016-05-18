{ system ? builtins.currentSystem }:

with import ../../.. { inherit system; };

rec {
  # We want coreutils without ACL support.
  coreutils_ = coreutils.override (orig: {
    aclSupport = false;
  });

  build = stdenv.mkDerivation {
    name = "stdenv-bootstrap-tools";

    buildInputs = [nukeReferences cpio];

    buildCommand = ''
      mkdir -p $out/bin $out/lib

      # Our (fake) loader
      cp -d ${darwin.dyld}/lib/dyld $out/lib/

      # C standard library stuff
      cp -d ${darwin.Libsystem}/lib/*.o $out/lib/
      cp -d ${darwin.Libsystem}/lib/*.dylib $out/lib/
      cp -d ${darwin.Libsystem}/lib/system/*.dylib $out/lib/

      # Resolv is actually a link to another package, so let's copy it properly
      rm $out/lib/libresolv.9.dylib
      cp -L ${darwin.Libsystem}/lib/libresolv.9.dylib $out/lib

      cp -rL ${darwin.Libsystem}/include $out
      chmod -R u+w $out/include
      cp -rL ${icu.dev}/include*             $out/include
      cp -rL ${libiconv}/include/*       $out/include
      cp -rL ${gnugrep.pcre.dev}/include/*   $out/include
      mv $out/include $out/include-Libsystem

      # Copy coreutils, bash, etc.
      cp ${coreutils_}/bin/* $out/bin
      (cd $out/bin && rm vdir dir sha*sum pinky factor pathchk runcon shuf who whoami shred users)

      cp ${bash}/bin/bash $out/bin
      cp ${findutils}/bin/find $out/bin
      cp ${findutils}/bin/xargs $out/bin
      cp -d ${diffutils}/bin/* $out/bin
      cp -d ${gnused}/bin/* $out/bin
      cp -d ${gnugrep}/bin/grep $out/bin
      cp ${gawk}/bin/gawk $out/bin
      cp -d ${gawk}/bin/awk $out/bin
      cp ${gnutar}/bin/tar $out/bin
      cp ${gzip}/bin/gzip $out/bin
      cp ${bzip2.bin}/bin/bzip2 $out/bin
      cp -d ${gnumake}/bin/* $out/bin
      cp -d ${patch}/bin/* $out/bin
      cp -d ${xz.bin}/bin/xz $out/bin

      # This used to be in-nixpkgs, but now is in the bundle
      # because I can't be bothered to make it partially static
      cp ${curl.bin}/bin/curl $out/bin
      cp -d ${curl.out}/lib/libcurl*.dylib $out/lib
      cp -d ${libssh2.out}/lib/libssh*.dylib $out/lib
      cp -d ${openssl.out}/lib/*.dylib $out/lib

      cp -d ${gnugrep.pcre.out}/lib/libpcre*.dylib $out/lib
      cp -d ${lib.getLib libiconv}/lib/lib*.dylib $out/lib
      cp -d ${gettext}/lib/libintl*.dylib $out/lib
      chmod +x $out/lib/libintl*.dylib
      cp -d ${ncurses.out}/lib/libncurses*.dylib $out/lib

      # Copy what we need of clang
      cp -d ${llvmPackages.clang-unwrapped}/bin/clang $out/bin
      cp -d ${llvmPackages.clang-unwrapped}/bin/clang++ $out/bin
      cp -d ${llvmPackages.clang-unwrapped}/bin/clang-[0-9].[0-9] $out/bin

      cp -rL ${llvmPackages.clang-unwrapped}/lib/clang $out/lib

      cp -d ${libcxx}/lib/libc++*.dylib $out/lib
      cp -d ${libcxxabi}/lib/libc++abi*.dylib $out/lib

      mkdir $out/include
      cp -rd ${libcxx}/include/c++     $out/include

      cp -d ${icu.out}/lib/libicu*.dylib $out/lib
      cp -d ${zlib.out}/lib/libz.*       $out/lib
      cp -d ${gmpxx.out}/lib/libgmp*.*   $out/lib
      cp -d ${xz.out}/lib/liblzma*.*     $out/lib

      # Copy binutils.
      for i in as ld ar ranlib nm strip otool install_name_tool dsymutil; do
        cp ${darwin.cctools}/bin/$i $out/bin
      done

      cp -rd ${pkgs.darwin.CF}/Library $out

      chmod -R u+w $out

      nuke-refs $out/bin/*

      rpathify() {
        local libs=$(${darwin.cctools}/bin/otool -L "$1" | tail -n +2 | grep -o "$NIX_STORE.*-\S*") || true
        for lib in $libs; do
          ${darwin.cctools}/bin/install_name_tool -change $lib "@rpath/$(basename $lib)" "$1"
        done
      }

      fix_dyld() {
        # This is clearly a hack. Once we have an install_name_tool-alike that can patch dyld, this will be nicer.
        ${perl}/bin/perl -i -0777 -pe 's/\/nix\/store\/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-dyld-239\.4\/lib\/dyld/\/usr\/lib\/dyld\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00/sg' "$1"
      }

      # Strip executables even further
      for i in $out/bin/*; do
        if test -x $i -a ! -L $i; then
          chmod +w $i

          fix_dyld $i
          strip $i || true
        fi
      done

      for i in $out/bin/* $out/lib/*.dylib $out/lib/clang/*/lib/darwin/*.dylib $out/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation; do
        if test -x $i -a ! -L $i; then
          echo "Adding rpath to $i"
          rpathify $i
        fi
      done

      nuke-refs $out/lib/*
      nuke-refs $out/lib/clang/*/lib/darwin/*
      nuke-refs $out/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation

      set -x
      mkdir $out/.pack
      mv $out/* $out/.pack
      mv $out/.pack $out/pack

      mkdir $out/on-server
      cp ${stdenv.shell} $out/on-server/sh
      cp ${cpio}/bin/cpio $out/on-server
      cp ${coreutils_}/bin/mkdir $out/on-server
      cp ${bzip2.bin}/bin/bzip2 $out/on-server

      chmod u+w $out/on-server/*
      strip $out/on-server/*
      nuke-refs $out/on-server/*

      for i in $out/on-server/*; do
        fix_dyld $i
      done

      (cd $out/pack && (find | cpio -o -H newc)) | bzip2 > $out/on-server/bootstrap-tools.cpio.bz2
    '';

    allowedReferences = [];

    meta = {
      maintainers = [ stdenv.lib.maintainers.copumpkin ];
    };
  };

  dist = stdenv.mkDerivation {
    name = "stdenv-bootstrap-tools";

    buildCommand = ''
      mkdir -p $out/nix-support
      echo "file tarball ${build}/on-server/bootstrap-tools.cpio.bz2" >> $out/nix-support/hydra-build-products
      echo "file sh ${build}/on-server/sh" >> $out/nix-support/hydra-build-products
      echo "file cpio ${build}/on-server/cpio" >> $out/nix-support/hydra-build-products
      echo "file mkdir ${build}/on-server/mkdir" >> $out/nix-support/hydra-build-products
      echo "file bzip2 ${build}/on-server/bzip2" >> $out/nix-support/hydra-build-products
    '';
  };

  bootstrapFiles = {
    sh      = "${build}/on-server/sh";
    bzip2   = "${build}/on-server/bzip2";
    mkdir   = "${build}/on-server/mkdir";
    cpio    = "${build}/on-server/cpio";
    tarball = "${build}/on-server/bootstrap-tools.cpio.bz2";
  };

  unpack = stdenv.mkDerivation (bootstrapFiles // {
    name = "unpack";

    # This is by necessity a near-duplicate of unpack-bootstrap-tools.sh. If we refer to it directly,
    # we can't make any changes to it due to our testing stdenv depending on it. Think of this as the
    # unpack-bootstrap-tools.sh for the next round of bootstrap tools.
    # TODO: think through alternate designs, such as hosting this script as an output of the process.
    buildCommand = ''
      # Unpack the bootstrap tools tarball.
      echo Unpacking the bootstrap tools...
      $mkdir $out
      $bzip2 -d < $tarball | (cd $out && $cpio -i)

      # Set the ELF interpreter / RPATH in the bootstrap binaries.
      echo Patching the tools...

      export PATH=$out/bin

      for i in $out/bin/*; do
        if ! test -L $i; then
          echo patching $i
          install_name_tool -add_rpath $out/lib $i || true
        fi
      done

      for i in $out/lib/*.dylib $out/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation; do
        if ! test -L $i; then
          echo patching $i

          id=$(otool -D "$i" | tail -n 1)
          install_name_tool -id "$(dirname $i)/$(basename $id)" $i

          libs=$(otool -L "$i" | tail -n +2 | grep -v Libsystem | cat)
          if [ -n "$libs" ]; then
            install_name_tool -add_rpath $out/lib $i
          fi
        fi
      done

      ln -s bash $out/bin/sh
      ln -s bzip2 $out/bin/bunzip2

      cat >$out/bin/dsymutil << EOF
      #!$out/bin/sh
      EOF
    '';

    allowedReferences = [ "out" ];
  });

  test = stdenv.mkDerivation {
    name = "test";

    realBuilder = "${unpack}/bin/bash";

    buildCommand = ''
      export PATH=${unpack}/bin
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

      ${build}/on-server/sh -c 'echo Hello World'

      export flags="-idirafter ${unpack}/include-Libsystem --sysroot=${unpack} -L${unpack}/lib"

      export CPP="clang -E $flags"
      export CC="clang $flags -Wl,-rpath,${unpack}/lib -Wl,-v"
      export CXX="clang++ $flags --stdlib=libc++ -lc++abi -isystem${unpack}/include/c++/v1 -Wl,-rpath,${unpack}/lib -Wl,-v"

      echo '#include <stdio.h>' >> foo.c
      echo '#include <float.h>' >> foo.c
      echo '#include <limits.h>' >> foo.c
      echo 'int main() { printf("Hello World\n"); return 0; }' >> foo.c
      $CC -o $out/bin/foo foo.c
      $out/bin/foo

      echo '#include <CoreFoundation/CoreFoundation.h>' >> bar.c
      echo 'int main() { CFShow(CFSTR("Hullo")); return 0; }' >> bar.c
      $CC -F${unpack}/Library/Frameworks -framework CoreFoundation -o $out/bin/bar bar.c
      $out/bin/bar

      echo '#include <iostream>' >> bar.cc
      echo 'int main() { std::cout << "Hello World\n"; }' >> bar.cc
      $CXX -v -o $out/bin/bar bar.cc
      $out/bin/bar

      tar xvf ${hello.src}
      cd hello-*
      ./configure --prefix=$out
      make
      make install

      $out/bin/hello
    '';
  };

  # The ultimate test: bootstrap a whole stdenv from the tools specified above and get a package set out of it
  test-pkgs = let
    stdenv = import ./. { inherit system bootstrapFiles; };
  in import ../../.. {
    inherit system;
    bootStdenv = stdenv.stdenvDarwin;
  };
}
