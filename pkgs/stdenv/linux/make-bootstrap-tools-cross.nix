{system ? builtins.currentSystem}:

let buildFor = toolsArch: (

let
  lib = import ../../../lib;
  pkgsFun = import ../../..;

  inherit (lib.systems.examples)
    sheevaplug raspberryPi armv7l-hf-multiplatform
    aarch64-multiplatform scaleway-c1 pogoplug4;

  selectedCrossSystem =
    if toolsArch == "armv5tel" then sheevaplug else
    if toolsArch == "scaleway" then scaleway-c1 else
    if toolsArch == "pogoplug4" then pogoplug4 else
    if toolsArch == "armv6l" then raspberryPi else
    if toolsArch == "armv7l" then armv7l-hf-multiplatform else
    if toolsArch == "aarch64" then aarch64-multiplatform else null;

  pkgs = pkgsFun ({ inherit system; crossSystem = selectedCrossSystem; });

  glibc = pkgs.libcCross;
  bash = pkgs.bash;
  findutils = pkgs.findutils;
  diffutils = pkgs.diffutils;
  gnused = pkgs.gnused;
  gnugrep = pkgs.gnugrep;
  gawk = pkgs.gawk;
  gzip = pkgs.gzip;
  bzip2 = pkgs.bzip2;
  gnumake = pkgs.gnumake;
  patch = pkgs.patch;
  patchelf = pkgs.patchelf;
  gcc = pkgs.gcc.cc;
  gmpxx = pkgs.gmpxx;
  mpfr = pkgs.mpfr;
  zlib = pkgs.zlib;
  libmpc = pkgs.libmpc;
  binutils = pkgs.binutils;
  libelf = pkgs.libelf;

  # Keep these versions in sync with the versions used in the current GCC!
  isl = pkgs.isl_0_14;
in

rec {


  coreutilsMinimal = pkgs.coreutils.override (args: {
    # We want coreutils without ACL/attr support.
    aclSupport = false;
    attrSupport = false;
    # Our tooling currently can't handle scripts in bin/, only ELFs and symlinks.
    singleBinary = "symlinks";
  });

  tarMinimal = pkgs.gnutar.override { acl = null; };

  busyboxMinimal = pkgs.busybox.override {
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

    pkgs.stdenv.mkDerivation {
      name = "stdenv-bootstrap-tools-cross";
      crossConfig = pkgs.hostPlatform.config;

      nativeBuildInputs = [
        pkgs.buildPackages.nukeReferences
        pkgs.buildPackages.cpio
      ];

      buildCommand = ''
        set -x
        mkdir -p $out/bin $out/lib $out/libexec

        # Copy what we need of Glibc.
        cp -d ${glibc.out}/lib/ld-*.so* $out/lib
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
        cp ${coreutilsMinimal}/bin/* $out/bin
        (cd $out/bin && rm vdir dir sha*sum pinky factor pathchk runcon shuf who whoami shred users)

        cp ${bash}/bin/bash $out/bin
        cp ${findutils}/bin/find $out/bin
        cp ${findutils}/bin/xargs $out/bin
        cp -d ${diffutils}/bin/* $out/bin
        cp -d ${gnused}/bin/* $out/bin
        cp -d ${gnugrep}/bin/grep $out/bin
        cp ${gawk}/bin/gawk $out/bin
        cp -d ${gawk}/bin/awk $out/bin
        cp ${tarMinimal}/bin/tar $out/bin
        cp ${gzip}/bin/gzip $out/bin
        cp ${bzip2.bin}/bin/bzip2 $out/bin
        cp -d ${gnumake}/bin/* $out/bin
        cp -d ${patch}/bin/* $out/bin
        cp ${patchelf}/bin/* $out/bin

        cp -d ${gnugrep.pcre.out}/lib/libpcre*.so* $out/lib # needed by grep

        # Copy what we need of GCC.
        cp -d ${gcc.out}/bin/gcc $out/bin
        cp -d ${gcc.out}/bin/cpp $out/bin
        cp -d ${gcc.out}/bin/g++ $out/bin
        cp -d ${gcc.lib}/lib*/libgcc_s.so* $out/lib
        cp -d ${gcc.lib}/lib*/libstdc++.so* $out/lib
        cp -rd ${gcc.out}/lib/gcc $out/lib
        chmod -R u+w $out/lib
        rm -f $out/lib/gcc/*/*/include*/linux
        rm -f $out/lib/gcc/*/*/include*/sound
        rm -rf $out/lib/gcc/*/*/include*/root
        rm -f $out/lib/gcc/*/*/include-fixed/asm
        rm -rf $out/lib/gcc/*/*/plugin
        #rm -f $out/lib/gcc/*/*/*.a
        cp -rd ${gcc.out}/libexec/* $out/libexec
        chmod -R u+w $out/libexec
        rm -rf $out/libexec/gcc/*/*/plugin
        mkdir $out/include
        cp -rd ${gcc.out}/include/c++ $out/include
        chmod -R u+w $out/include
        rm -rf $out/include/c++/*/ext/pb_ds
        rm -rf $out/include/c++/*/ext/parallel

        cp -d ${gmpxx.out}/lib/libgmp*.so* $out/lib
        cp -d ${mpfr.out}/lib/libmpfr*.so* $out/lib
        cp -d ${libmpc.out}/lib/libmpc*.so* $out/lib
        cp -d ${zlib.out}/lib/libz.so* $out/lib
        cp -d ${libelf}/lib/libelf.so* $out/lib

        # These needed for cross but not native tools because the stdenv
        # GCC has certain things built in statically. See
        # pkgs/stdenv/linux/default.nix for the details.
        cp -d ${isl}/lib/libisl*.so* $out/lib

        cp -d ${bzip2.out}/lib/libbz2.so* $out/lib

        # Copy binutils.
        for i in as ld ar ranlib nm strip readelf objdump; do
          cp ${binutils.out}/bin/$i $out/bin
        done
        cp -d ${binutils.lib}/lib/lib*.so* $out/lib

        chmod -R u+w $out

        # Strip executables even further.
        for i in $out/bin/* $out/libexec/gcc/*/*/*; do
            if test -x $i -a ! -L $i; then
                chmod +w $i
                $crossConfig-strip -s $i || true
            fi
        done

        nuke-refs $out/bin/*
        nuke-refs $out/lib/*
        nuke-refs $out/libexec/gcc/*/*/*

        mkdir $out/.pack
        mv $out/* $out/.pack
        mv $out/.pack $out/pack

        mkdir $out/on-server
        tar cvfJ $out/on-server/bootstrap-tools.tar.xz --hard-dereference --sort=name --numeric-owner --owner=0 --group=0 --mtime=@1 -C $out/pack .
        cp ${busyboxMinimal}/bin/busybox $out/on-server
        chmod u+w $out/on-server/busybox
        nuke-refs $out/on-server/busybox
      ''; # */

      # The result should not contain any references (store paths) so
      # that we can safely copy them out of the store and to other
      # locations in the store.
      allowedReferences = [];
    };

  dist = pkgs.stdenv.mkDerivation {
    name = "stdenv-bootstrap-tools-cross";

    buildCommand = ''
      mkdir -p $out/nix-support
      echo "file tarball ${build}/on-server/bootstrap-tools.tar.xz" >> $out/nix-support/hydra-build-products
      echo "file busybox ${build}/on-server/busybox" >> $out/nix-support/hydra-build-products
    '';
  };
}

); in {
    armv5tel = buildFor "armv5tel";
    armv6l = buildFor "armv6l";
    armv7l = buildFor "armv7l";
    aarch64 = buildFor "aarch64";
    scaleway = buildFor "scaleway";
    pogoplug4 = buildFor "pogoplug4";
}
