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

rec {
  build = stdenv.mkDerivation {
    name = "stdenv-bootstrap-tools";

    nativeBuildInputs = [ dumpnar nukeReferences ];

    buildCommand = let
      inherit (lib)
        getBin
        getDev
        getLib
        ;

      coreutils_ = (coreutils.override (args: {
        # We want coreutils without ACL support.
        aclSupport = false;
        # Cannot use a single binary build, or it gets dynamically linked against gmp.
        singleBinary = false;
      })).overrideAttrs (oa: {
        # Increase header size to be able to inject extra RPATHs. Otherwise
        # x86_64-darwin build fails as:
        #    https://cache.nixos.org/log/g5wyq9xqshan6m3kl21bjn1z88hx48rh-stdenv-bootstrap-tools.drv
        NIX_LDFLAGS = (oa.NIX_LDFLAGS or "") + " -headerpad_max_install_names";
      });

      cctools_ = darwin.cctools;

      # Avoid messing with libkrb5 and libnghttp2.
      curl_ = curlMinimal.override (args: {
        gssSupport = false;
        http2Support = false;
        scpSupport = false;
      });

      unpackScript = writeText "bootstrap-tools-unpack.sh" ''
        set -euo pipefail

        echo Unpacking the bootstrap tools... >&2
        mkdir $out
        tar xf "$1" -C $out

        updateInstallName() {
          local path="$1"

          cp "$path" "$path.new"
          install_name_tool -id "$path" "$path.new"
          codesign -f -i "$(basename "$path")" -s - "$path.new"
          mv -f "$path.new" "$path"
        }

        find $out/lib -type f -name '*.dylib' -print0 | while IFS= read -r -d $'\0' lib; do
          updateInstallName "$lib"
        done

        # as is a wrapper around clang. need to replace the nuked store paths
        sed -i 's|/.*/bin/|'"$out"'/bin/|' $out/bin/as

        # Provide a gunzip script.
        cat > $out/bin/gunzip <<EOF
        #!$out/bin/sh
        exec $out/bin/gzip -d "\$@"
        EOF
        chmod +x $out/bin/gunzip

        # Provide fgrep/egrep.
        echo "#! $out/bin/sh" > $out/bin/egrep
        echo "exec $out/bin/grep -E \"\$@\"" >> $out/bin/egrep
        echo "#! $out/bin/sh" > $out/bin/fgrep
        echo "exec $out/bin/grep -F \"\$@\"" >> $out/bin/fgrep

        cat >$out/bin/dsymutil << EOF
        #!$out/bin/sh
        EOF

        chmod +x $out/bin/egrep $out/bin/fgrep $out/bin/dsymutil
    '';

    in
    ''
      mkdir -p $out/bin $out/lib $out/lib/darwin

      ${lib.optionalString stdenv.targetPlatform.isx86_64 ''
        # Copy libSystem's .o files for various low-level boot stuff.
        cp -d ${getLib darwin.Libsystem}/lib/*.o $out/lib

        # Resolv is actually a link to another package, so let's copy it properly
        cp -L ${getLib darwin.Libsystem}/lib/libresolv.9.dylib $out/lib
      ''}

      cp -rL ${getDev darwin.Libsystem}/include $out
      chmod -R u+w $out/include
      cp -rL ${getDev libiconv}/include/* $out/include
      cp -rL ${getDev gnugrep.pcre2}/include/* $out/include
      mv $out/include $out/include-Libsystem

      # Copy binutils.
      for i in as ld ar ranlib nm strip otool install_name_tool lipo codesign_allocate; do
        cp ${getBin cctools_}/bin/$i $out/bin
      done

      # Copy coreutils, bash, etc.
      cp ${getBin coreutils_}/bin/* $out/bin
      (cd $out/bin && rm vdir dir sha*sum pinky factor pathchk runcon shuf who whoami shred users)

      cp -d ${getBin bash}/bin/{ba,}sh $out/bin
      cp -d ${getBin diffutils}/bin/* $out/bin
      cp ${getBin findutils}/bin/{find,xargs} $out/bin
      cp -d ${getBin gawk}/bin/{g,}awk $out/bin
      cp -d ${getBin gnugrep}/bin/grep $out/bin
      cp -d ${getBin gnumake}/bin/* $out/bin
      cp -d ${getBin gnused}/bin/* $out/bin
      cp -d ${getBin patch}/bin/* $out/bin

      cp -d ${getLib gettext}/lib/libintl*.dylib $out/lib
      cp -d ${getLib gnugrep.pcre2}/lib/libpcre2*.dylib $out/lib
      cp -d ${getLib libiconv}/lib/lib*.dylib $out/lib
      cp -d ${getLib libxml2}/lib/libxml2*.dylib $out/lib
      cp -d ${getLib ncurses}/lib/libncurses*.dylib $out/lib

      # copy package extraction tools
      cp -d ${getBin bzip2}/bin/b{,un}zip2 $out/bin
      cp ${getBin cpio}/bin/cpio $out/bin
      cp ${getBin gnutar}/bin/tar $out/bin
      cp ${getBin gzip}/bin/.gzip-wrapped $out/bin/gzip
      cp ${getBin pbzx}/bin/pbzx $out/bin
      cp ${getBin xz}/bin/xz $out/bin
      cp -d ${getLib bzip2}/lib/libbz2*.dylib $out/lib
      cp -d ${getLib gmpxx}/lib/libgmp*.dylib $out/lib
      cp -d ${getLib xar}/lib/libxar*.dylib $out/lib
      cp -d ${getLib xz}/lib/liblzma*.dylib $out/lib
      cp -d ${getLib zlib}/lib/libz*.dylib $out/lib

      # This used to be in-nixpkgs, but now is in the bundle
      # because I can't be bothered to make it partially static
      cp ${getBin curl_}/bin/curl $out/bin
      cp -d ${getLib curl_}/lib/libcurl*.dylib $out/lib
      cp -d ${getLib openssl}/lib/*.dylib $out/lib

      # Copy what we need of clang
      cp -d ${getBin llvmPackages.clang-unwrapped}/bin/clang{,++,-cl,-cpp,-[0-9]*} $out/bin
      cp -d ${getLib llvmPackages.clang-unwrapped}/lib/libclang-cpp*.dylib $out/lib
      cp -rd ${getLib llvmPackages.clang-unwrapped}/lib/clang $out/lib

      cp -d ${getLib llvmPackages.libcxx}/lib/libc++*.dylib $out/lib
      mkdir -p $out/lib/darwin
      cp -d ${getLib llvmPackages.compiler-rt}/lib/darwin/libclang_rt.{,profile_}osx.a  $out/lib/darwin
      cp -d ${getLib llvmPackages.compiler-rt}/lib/libclang_rt.{,profile_}osx.a $out/lib
      cp -d ${getLib llvmPackages.llvm}/lib/libLLVM.dylib $out/lib
      cp -d ${getLib libffi}/lib/libffi*.dylib $out/lib

      mkdir $out/include
      cp -rd ${getDev llvmPackages.libcxx}/include/c++ $out/include

      # copy .tbd assembly utils
      cp ${getBin darwin.rewrite-tbd}/bin/rewrite-tbd $out/bin
      cp -d ${getLib libyaml}/lib/libyaml*.dylib $out/lib

      # copy sigtool
      cp -d ${getBin darwin.sigtool}/bin/{codesign,sigtool} $out/bin

      cp -d ${getLib darwin.libtapi}/lib/libtapi*.dylib $out/lib

      # tools needed to unpack bootstrap archive
      mkdir -p unpack/bin unpack/lib
      cp -d ${getBin bash}/bin/{bash,sh} unpack/bin
      cp ${getBin coreutils_}/bin/mkdir unpack/bin
      cp ${getBin gnutar}/bin/tar unpack/bin
      cp ${getBin xz}/bin/xz unpack/bin
      cp -d ${getLib gettext}/lib/libintl*.dylib unpack/lib
      cp -d ${getLib libiconv}/lib/lib*.dylib unpack/lib
      cp -d ${getLib xz}/lib/liblzma*.dylib unpack/lib
      cp ${unpackScript} unpack/bootstrap-tools-unpack.sh

      #
      # All files copied. Perform processing to update references to point into
      # the archive
      #

      chmod -R u+w $out unpack

      # - change nix store library paths to use @rpath/library
      # - if needed add an rpath containing lib/
      # - strip executable
      rpathify() {
        local libs=$(${stdenv.cc.targetPrefix}otool -L "$1" | tail -n +2 | grep -o "$NIX_STORE.*-\S*" || true)
        local lib rpath
        for lib in $libs; do
          ${stdenv.cc.targetPrefix}install_name_tool -change $lib "@rpath/$(basename "$lib")" "$1"
        done

        case "$(dirname "$1")" in
        */bin)
          # Strip executables even further
          ${stdenv.cc.targetPrefix}strip "$i"
          rpath='@executable_path/../lib'
          ;;
        */lib)
          # the '/.' suffix is required
          rpath='@loader_path/.'
          ;;
        */lib/darwin)
          rpath='@loader_path/..'
          ;;
        *)
          echo unkown executable $1 >&2
          exit 1
          ;;
        esac

        # if shared object contains references add an rpath to lib/
        if ${stdenv.cc.targetPrefix}otool -l "$1"| grep -q '@rpath/'; then
          ${stdenv.cc.targetPrefix}install_name_tool -add_rpath "$rpath" "$1"
        fi
      }

      # check that linked library paths exist in lib
      # must be run after rpathify is performed
      checkDeps() {
        local deps=$(${stdenv.cc.targetPrefix}otool -l "$1"| grep -o '@rpath/[^      ]*' || true)
        local lib
        shopt -s extglob
        for lib in $deps; do
          local root="''${1/\/@(lib|bin)\/*}"
          if [[ ! -e $root/''${lib/@rpath/lib} ]]; then
            echo "error: $1 missing lib for $lib" >&2
            exit 1
          fi
        done
        shopt -u extglob
      }

      for i in {unpack,$out}/bin/* {unpack,$out}/lib{,/darwin}/*.dylib; do
        if [[ ! -L $i ]] && isMachO "$i"; then
          rpathify "$i"
          checkDeps "$i"
        fi
      done

      nuke-refs {unpack,$out}/bin/*
      nuke-refs {unpack,$out}/lib/*
      nuke-refs $out/lib/darwin/*

      mkdir $out/.pack
      mv $out/* $out/.pack
      mv $out/.pack $out/pack

      mkdir $out/on-server
      cp -r unpack $out

      XZ_OPT="-9 -T $NIX_BUILD_CORES" tar cvJf $out/on-server/bootstrap-tools.tar.xz \
        --hard-dereference --sort=name --numeric-owner --owner=0 --group=0 --mtime=@1 -C $out/pack .
      dumpnar $out/unpack | xz -9 -T $NIX_BUILD_CORES > $out/on-server/unpack.nar.xz
    '';

    allowedReferences = [];

    meta = {
      maintainers = [ lib.maintainers.copumpkin ];
    };
  };

  dist = runCommand "stdenv-bootstrap-tools" {} ''
    mkdir -p $out/nix-support
    echo "file tarball ${build}/on-server/*.tar.xz" >> $out/nix-support/hydra-build-products
    echo "file unpack ${build}/on-server/unpack.* " >> $out/nix-support/hydra-build-products
  '';

  bootstrapFiles = {
    bootstrapTools = "${build}/on-server/bootstrap-tools.tar.xz";
    unpack = runCommand "unpack" { allowedReferences = []; } ''
      cp -r ${build}/unpack $out
    '';
  };

  bootstrapTools = derivation {
    inherit (stdenv.hostPlatform) system;

    name = "bootstrap-tools";
    builder = "${bootstrapFiles.unpack}/bin/bash";

    args = [
      "${bootstrapFiles.unpack}/bootstrap-tools-unpack.sh"
        bootstrapFiles.bootstrapTools
    ];

    PATH = lib.makeBinPath [
      (placeholder "out")
      bootstrapFiles.unpack
    ];

    allowedReferences = [ "out" ];
  };

  test = derivation {
    name = "test-bootstrap-tools";
    inherit (stdenv.hostPlatform) system;
    builder = "${bootstrapTools}/bin/bash";
    args = [ "-euo" "pipefail" "-c" "eval \"$buildCommand\"" ];
    PATH = lib.makeBinPath [ bootstrapTools ];
    tools = bootstrapTools;
    "${stdenv.cc.darwinMinVersionVariable}" = stdenv.cc.darwinMinVersion;

    # Create a pure environment where we use just what's in the bootstrap tools.
    buildCommand = ''
      mkdir -p $out/bin

      for exe in $tools/bin/*; do
        [[ $exe =~ bunzip2|codesign.*|false|install_name_tool|ld|lipo|pbzx|ranlib|rewrite-tbd|sigtool ]] && continue
        $exe --version > /dev/null || { echo $exe failed >&2; exit 1; }
      done

      # run all exes that don't take a --version flag
      bunzip2 -h
      codesign --help
      codesign_allocate -i $tools/bin/true -r -o true
      false || (($? == 1))
      install_name_tool -id true true
      ld -v
      lipo -info true
      pbzx -v
      # ranlib gets tested bulding hello
      rewrite-tbd </dev/null
      sigtool -h
      rm true

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

      sed -i "s|/usr/lib/system/|$PWD/libSystem-boot/system/|g" libSystem-boot/libSystem.B.tbd
      ln -s libSystem.B.tbd libSystem-boot/libSystem.tbd
      # End of bootstrap libSystem

      export flags="-idirafter $tools/include-Libsystem --sysroot=$tools -L$tools/lib -L$PWD/libSystem-boot"

      export CPP="clang -E $flags"
      export CC="clang $flags"
      export CXX="clang++ $flags --stdlib=libc++ -isystem$tools/include/c++/v1"

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

      echo '#include <iostream>' >> hello3.cc
      echo 'int main() { std::cout << "Hello World\n"; }' >> hello3.cc
      $CXX -v -o hello3 hello3.cc
      cp hello3 $out/bin/
      $out/bin/hello3

      # test that libc++.dylib rpaths are correct so it can reference libc++abi.dylib when linked.
      # using -Wl,-flat_namespace is required to generate an error
      mkdir libtest/
      ln -s $tools/lib/libc++.dylib libtest/
      clang++ -Wl,-flat_namespace -idirafter $tools/include-Libsystem -isystem$tools/include/c++/v1 \
        --sysroot=$tools -L./libtest -L$PWD/libSystem-boot hello3.cc

      tar xvf ${hello.src}
      cd hello-*
      # hello configure detects -liconv is needed but doesn't add to the link step
      LDFLAGS=-liconv ./configure --prefix=$out
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
