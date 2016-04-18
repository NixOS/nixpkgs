{ system ? builtins.currentSystem }:

with import ../../.. {inherit system;};

rec {


  # We want coreutils without ACL support.
  coreutilsMinimal = coreutils.override (args: {
    aclSupport = false;
  });

  tarMinimal = gnutar.override { acl = null; };

  busyboxMinimal = busybox.override {
    useMusl = true;
    enableStatic = true;
    enableMinimal = true;
    extraConfig = ''
      CONFIG_ASH y
      CONFIG_ASH_BUILTIN_ECHO y
      CONFIG_ASH_BUILTIN_TEST y
      CONFIG_ASH_OPTIMIZE_FOR_SIZE y
      CONFIG_MKDIR y
      CONFIG_TAR y
      CONFIG_UNXZ y
    '';
  };

  build =

    stdenv.mkDerivation {
      name = "stdenv-bootstrap-tools";

      buildInputs = [nukeReferences cpio];

      buildCommand = ''
        set -x
        mkdir -p $out/bin $out/lib $out/libexec

        # Copy what we need of Glibc.
        cp -d ${glibc.out}/lib/ld*.so* $out/lib
        cp -d ${glibc.out}/lib/libc*.so* $out/lib
        cp -d ${glibc.out}/lib/libc_nonshared.a $out/lib
        cp -d ${glibc.out}/lib/libm*.so* $out/lib
        cp -d ${glibc.out}/lib/libdl*.so* $out/lib
        cp -d ${glibc.out}/lib/librt*.so*  $out/lib
        cp -d ${glibc.out}/lib/libpthread*.so* $out/lib
        cp -d ${glibc.out}/lib/libnsl*.so* $out/lib
        cp -d ${glibc.out}/lib/libutil*.so* $out/lib
        cp -d ${glibc.out}/lib/libnss*.so* $out/lib
        cp -d ${glibc.out}/lib/libresolv*.so* $out/lib
        cp -d ${glibc.out}/lib/crt?.o $out/lib

        cp -rL ${glibc.dev}/include $out
        chmod -R u+w "$out"

        # glibc can contain linker scripts: find them, copy their deps,
        # and get rid of absolute paths (nuke-refs would make them useless)
        local lScripts=$(grep --files-with-matches --max-count=1 'GNU ld script' -R "$out/lib")
        cp -d -t "$out/lib/" $(cat $lScripts | tr " " "\n" | grep -F '${glibc.out}' | sort -u)
        for f in $lScripts; do
          substituteInPlace "$f" --replace '${glibc.out}/lib/' ""
        done

        # Hopefully we won't need these.
        rm -rf $out/include/mtd $out/include/rdma $out/include/sound $out/include/video
        find $out/include -name .install -exec rm {} \;
        find $out/include -name ..install.cmd -exec rm {} \;
        mv $out/include $out/include-glibc

        # Copy coreutils, bash, etc.
        cp ${coreutilsMinimal.out}/bin/* $out/bin
        (cd $out/bin && rm vdir dir sha*sum pinky factor pathchk runcon shuf who whoami shred users)

        cp ${bash.out}/bin/bash $out/bin
        cp ${findutils.out}/bin/find $out/bin
        cp ${findutils.out}/bin/xargs $out/bin
        cp -d ${diffutils.out}/bin/* $out/bin
        cp -d ${gnused.out}/bin/* $out/bin
        cp -d ${gnugrep.out}/bin/grep $out/bin
        cp ${gawk.out}/bin/gawk $out/bin
        cp -d ${gawk.out}/bin/awk $out/bin
        cp ${tarMinimal.out}/bin/tar $out/bin
        cp ${gzip.out}/bin/gzip $out/bin
        cp ${bzip2.bin}/bin/bzip2 $out/bin
        cp -d ${gnumake.out}/bin/* $out/bin
        cp -d ${patch}/bin/* $out/bin
        cp ${patchelf}/bin/* $out/bin

        cp -d ${gnugrep.pcre.out}/lib/libpcre*.so* $out/lib # needed by grep

        # Copy what we need of GCC.
        cp -d ${gcc.cc.out}/bin/gcc $out/bin
        cp -d ${gcc.cc.out}/bin/cpp $out/bin
        cp -d ${gcc.cc.out}/bin/g++ $out/bin
        cp -d ${gcc.cc.lib}/lib*/libgcc_s.so* $out/lib
        cp -d ${gcc.cc.lib}/lib*/libstdc++.so* $out/lib
        cp -rd ${gcc.cc.out}/lib/gcc $out/lib
        chmod -R u+w $out/lib
        rm -f $out/lib/gcc/*/*/include*/linux
        rm -f $out/lib/gcc/*/*/include*/sound
        rm -rf $out/lib/gcc/*/*/include*/root
        rm -f $out/lib/gcc/*/*/include-fixed/asm
        rm -rf $out/lib/gcc/*/*/plugin
        #rm -f $out/lib/gcc/*/*/*.a
        cp -rd ${gcc.cc.out}/libexec/* $out/libexec
        chmod -R u+w $out/libexec
        rm -rf $out/libexec/gcc/*/*/plugin
        mkdir $out/include
        cp -rd ${gcc.cc.out}/include/c++ $out/include
        chmod -R u+w $out/include
        rm -rf $out/include/c++/*/ext/pb_ds
        rm -rf $out/include/c++/*/ext/parallel

        cp -d ${gmpxx.out}/lib/libgmp*.so* $out/lib
        cp -d ${mpfr.out}/lib/libmpfr*.so* $out/lib
        cp -d ${libmpc}/lib/libmpc*.so* $out/lib
        cp -d ${zlib.out}/lib/libz.so* $out/lib
        cp -d ${libelf}/lib/libelf.so* $out/lib

        # Copy binutils.
        for i in as ld ar ranlib nm strip readelf objdump; do
          cp ${binutils.out}/bin/$i $out/bin
        done
        cp -d ${binutils.out}/lib/lib*.so* $out/lib

        chmod -R u+w $out

        # Strip executables even further.
        for i in $out/bin/* $out/libexec/gcc/*/*/*; do
            if test -x $i -a ! -L $i; then
                chmod +w $i
                strip -s $i || true
            fi
        done

        nuke-refs $out/bin/*
        nuke-refs $out/lib/*
        nuke-refs $out/libexec/gcc/*/*/*

        mkdir $out/.pack
        mv $out/* $out/.pack
        mv $out/.pack $out/pack

        mkdir $out/on-server
        tar cvfJ $out/on-server/bootstrap-tools.tar.xz -C $out/pack .
        cp ${busyboxMinimal}/bin/busybox $out/on-server
        chmod u+w $out/on-server/busybox
        nuke-refs $out/on-server/busybox
      ''; # */

      # The result should not contain any references (store paths) so
      # that we can safely copy them out of the store and to other
      # locations in the store.
      allowedReferences = [];
    };

  dist = stdenv.mkDerivation {
    name = "stdenv-bootstrap-tools";

    buildCommand = ''
      mkdir -p $out/nix-support
      echo "file tarball ${build}/on-server/bootstrap-tools.tar.xz" >> $out/nix-support/hydra-build-products
      echo "file busybox ${build}/on-server/busybox" >> $out/nix-support/hydra-build-products
    '';
  };

  bootstrapFiles = {
    busybox = "${build}/on-server/busybox";
    bootstrapTools = "${build}/on-server/bootstrap-tools.tar.xz";
  };

  bootstrapTools = (import ./default.nix {
    inherit system bootstrapFiles;
  }).bootstrapTools;

  test = derivation {
    name = "test-bootstrap-tools";
    inherit system;
    builder = bootstrapFiles.busybox;
    args = [ "ash" "-e" "-c" "eval \"$buildCommand\"" ];

    buildCommand = ''
      export PATH=${bootstrapTools}/bin

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
      gcc --version

      ldlinux=$(echo ${bootstrapTools}/lib/ld-linux*.so.?)
      export CPP="cpp -idirafter ${bootstrapTools}/include-glibc -B${bootstrapTools}"
      export CC="gcc -idirafter ${bootstrapTools}/include-glibc -B${bootstrapTools} -Wl,-dynamic-linker,$ldlinux -Wl,-rpath,${bootstrapTools}/lib"
      export CXX="g++ -idirafter ${bootstrapTools}/include-glibc -B${bootstrapTools} -Wl,-dynamic-linker,$ldlinux -Wl,-rpath,${bootstrapTools}/lib"

      echo '#include <stdio.h>' >> foo.c
      echo '#include <limits.h>' >> foo.c
      echo 'int main() { printf("Hello World\\n"); return 0; }' >> foo.c
      $CC -o $out/bin/foo foo.c
      $out/bin/foo

      echo '#include <iostream>' >> bar.cc
      echo 'int main() { std::cout << "Hello World\\n"; }' >> bar.cc
      $CXX -v -o $out/bin/bar bar.cc
      $out/bin/bar

      tar xvf ${hello.src}
      cd hello-*
      ./configure --prefix=$out
      make
      make install
    '';
  };
}
