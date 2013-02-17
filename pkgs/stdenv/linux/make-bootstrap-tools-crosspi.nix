{system ? builtins.currentSystem}:

let
  pkgsFun = import ../../top-level/all-packages.nix;
  pkgsNoParams = pkgsFun {};
  raspberrypiCrossSystem = {
    crossSystem = {
      config = "armv6l-unknown-linux-gnueabi";  
      bigEndian = false;
      arch = "arm";
      float = "hard";
      fpu = "vfp";
      withTLS = true;
      libc = "glibc";
      platform = pkgsNoParams.platforms.raspberrypi;
      openssl.system = "linux-generic32";
      gcc = {
        arch = "armv6";
        fpu = "vfp";
        float = "hard";
      };
    };
  };

  raspberrypiCrossSystemUclibc = {
    crossSystem = {
      config = "armv6l-unknown-linux-gnueabi";  
      bigEndian = false;
      arch = "arm";
      float = "hard";
      fpu = "vfp";
      withTLS = true;
      libc = "uclibc";
      platform = pkgsNoParams.platforms.raspberrypi;
      openssl.system = "linux-generic32";
      gcc = {
        arch = "armv6";
        fpu = "vfp";
        float = "hard";
      };
      uclibc.extraConfig = ''
        ARCH_WANTS_BIG_ENDIAN n
        ARCH_BIG_ENDIAN n
        ARCH_WANTS_LITTLE_ENDIAN y
        ARCH_LITTLE_ENDIAN y
      '';
    };
  };

  pkgsuclibc = pkgsFun ({inherit system;} // raspberrypiCrossSystemUclibc);
  pkgs = pkgsFun ({inherit system;} // raspberrypiCrossSystem);

  inherit (pkgs) stdenv nukeReferences cpio binutilsCross;

  # We want coreutils without ACL support.
  coreutils_base = pkgs.coreutils.override (args: {
    aclSupport = false;
  });

  coreutils_ = coreutils_base.crossDrv;

  glibc = pkgs.libcCross;
  bash = pkgs.bash.crossDrv;
  findutils = pkgs.findutils.crossDrv;
  diffutils = pkgs.diffutils.crossDrv;
  gnused = pkgs.gnused.crossDrv;
  gnugrep = pkgs.gnugrep.crossDrv;
  gawk = pkgs.gawk.crossDrv;
  gnutar = pkgs.gnutar.crossDrv;
  gzip = pkgs.gzip.crossDrv;
  bzip2 = pkgs.bzip2.crossDrv;
  gnumake = pkgs.gnumake.crossDrv;
  patch = pkgs.patch.crossDrv;
  patchelf = pkgs.patchelf.crossDrv;
  replace = pkgs.replace.crossDrv;
  gcc = pkgs.gcc47;
  gmp = pkgs.gmp.crossDrv;
  mpfr = pkgs.mpfr.crossDrv;
  ppl = pkgs.ppl.crossDrv;
  cloogppl = pkgs.cloogppl.crossDrv;
  cloog = pkgs.cloog.crossDrv;
  zlib = pkgs.zlib.crossDrv;
  isl = pkgs.isl.crossDrv;
  mpc = pkgs.mpc.crossDrv;
  binutils = pkgs.binutils.crossDrv;
  klibc = pkgs.klibc.crossDrv;

in

rec {

  curlStatic = import <nixpkgs/pkgs/tools/networking/curl> {
    stdenv = pkgsuclibc.stdenv;
    inherit (pkgsuclibc) fetchurl;
    zlibSupport = false;
    sslSupport = false;
    linkStatic = true;
  };

  bzip2Static = import <nixpkgs/pkgs/tools/compression/bzip2> {
    stdenv = pkgsuclibc.stdenv;
    inherit (pkgsuclibc) fetchurl;
    linkStatic = true;
  };

  inherit pkgs;

  build = 

    stdenv.mkDerivation {
      name = "build";

      buildInputs = [nukeReferences cpio binutilsCross];

      crossConfig = stdenv.cross.config;

      buildCommand = ''
	set -x
        ensureDir $out/bin $out/lib $out/libexec

        # Copy what we need of Glibc.
        cp -d ${glibc}/lib/ld-*.so* $out/lib
        cp -d ${glibc}/lib/libc*.so* $out/lib
        cp -d ${glibc}/lib/libc_nonshared.a $out/lib
        cp -d ${glibc}/lib/libm*.so* $out/lib
        cp -d ${glibc}/lib/libdl*.so* $out/lib
        cp -d ${glibc}/lib/librt*.so*  $out/lib
        cp -d ${glibc}/lib/libpthread*.so* $out/lib
        cp -d ${glibc}/lib/libnsl*.so* $out/lib
        cp -d ${glibc}/lib/libutil*.so* $out/lib
        cp -d ${glibc}/lib/crt?.o $out/lib
        
        cp -rL ${glibc}/include $out
        chmod -R u+w $out/include
        
        # Hopefully we won't need these.
        rm -rf $out/include/mtd $out/include/rdma $out/include/sound $out/include/video
        find $out/include -name .install -exec rm {} \;
        find $out/include -name ..install.cmd -exec rm {} \;
        mv $out/include $out/include-glibc
        
        # Copy coreutils, bash, etc.
        cp ${coreutils_}/bin/* $out/bin
        (cd $out/bin && rm vdir dir sha*sum pinky factor pathchk runcon shuf who whoami shred users)
        
        cp ${bash}/bin/bash $out/bin
        cp ${findutils}/bin/find $out/bin
        cp ${findutils}/bin/xargs $out/bin
        cp -d ${diffutils}/bin/* $out/bin
        cp -d ${gnused}/bin/* $out/bin
        cp -d ${gnugrep}/bin/* $out/bin
        cp ${gawk}/bin/gawk $out/bin
        cp -d ${gawk}/bin/awk $out/bin
        cp ${gnutar}/bin/tar $out/bin
        cp ${gzip}/bin/gzip $out/bin
        cp ${bzip2}/bin/bzip2 $out/bin
        cp -d ${gnumake}/bin/* $out/bin
        cp -d ${patch}/bin/* $out/bin
        cp ${patchelf}/bin/* $out/bin
        cp ${replace}/bin/* $out/bin

        cp -d ${gnugrep.pcre.crossDrv}/lib/libpcre*.so* $out/lib # needed by grep
        
        # Copy what we need of GCC.
        cp -d ${gcc.gcc.crossDrv}/bin/gcc $out/bin
        cp -d ${gcc.gcc.crossDrv}/bin/cpp $out/bin
        cp -d ${gcc.gcc.crossDrv}/bin/g++ $out/bin
        cp -d ${gcc.gcc.crossDrv}/lib*/libgcc_s.so* $out/lib
        cp -d ${gcc.gcc.crossDrv}/lib*/libstdc++.so* $out/lib
        cp -rd ${gcc.gcc.crossDrv}/lib/gcc $out/lib
        chmod -R u+w $out/lib
        rm -f $out/lib/gcc/*/*/include*/linux
        rm -f $out/lib/gcc/*/*/include*/sound
        rm -rf $out/lib/gcc/*/*/include*/root
        rm -f $out/lib/gcc/*/*/include-fixed/asm
        rm -rf $out/lib/gcc/*/*/plugin
        #rm -f $out/lib/gcc/*/*/*.a
        cp -rd ${gcc.gcc.crossDrv}/libexec/* $out/libexec
        mkdir $out/include
        cp -rd ${gcc.gcc.crossDrv}/include/c++ $out/include
        chmod -R u+w $out/include
        rm -rf $out/include/c++/*/ext/pb_ds
        rm -rf $out/include/c++/*/ext/parallel

        cp -d ${gmp}/lib/libgmp*.so* $out/lib
        cp -d ${mpfr}/lib/libmpfr*.so* $out/lib
        cp -d ${cloogppl}/lib/libcloog*.so* $out/lib
        cp -d ${cloog}/lib/libcloog*.so* $out/lib
        cp -d ${ppl}/lib/libppl*.so* $out/lib
        cp -d ${isl}/lib/libisl*.so* $out/lib
        cp -d ${mpc}/lib/libmpc*.so* $out/lib
        cp -d ${zlib}/lib/libz.so* $out/lib
        
        # Copy binutils.
        for i in as ld ar ranlib nm strip readelf objdump; do
          cp ${binutils}/bin/$i $out/bin
        done

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
        nuke-refs $out/libexec/gcc/*/*/*/*

        mkdir $out/.pack
        mv $out/* $out/.pack
        mv $out/.pack $out/pack

        mkdir $out/on-server
        (cd $out/pack && (find | cpio -o -H newc)) | bzip2 > $out/on-server/bootstrap-tools.cpio.bz2

        mkdir $out/in-nixpkgs
        cp ${klibc}/lib/klibc/bin.static/sh $out/in-nixpkgs
        cp ${klibc}/lib/klibc/bin.static/cpio $out/in-nixpkgs
        cp ${klibc}/lib/klibc/bin.static/mkdir $out/in-nixpkgs
        cp ${klibc}/lib/klibc/bin.static/ln $out/in-nixpkgs
        cp ${curlStatic.crossDrv}/bin/curl $out/in-nixpkgs
        cp ${bzip2Static.crossDrv}/bin/bzip2 $out/in-nixpkgs
        chmod u+w $out/in-nixpkgs/*
        $crossConfig-strip $out/in-nixpkgs/*
        nuke-refs $out/in-nixpkgs/*
        bzip2 $out/in-nixpkgs/curl
      ''; # */

      # The result should not contain any references (store paths) so
      # that we can safely copy them out of the store and to other
      # locations in the store.
      allowedReferences = [];
    };

  
  unpack =
    
    stdenv.mkDerivation {
      name = "unpack";

      buildCommand = ''
        ${build}/in-nixpkgs/mkdir $out
        ${build}/in-nixpkgs/bzip2 -d < ${build}/on-server/bootstrap-tools.cpio.bz2 | (cd $out && ${build}/in-nixpkgs/cpio -V -i)

        for i in $out/bin/* $out/libexec/gcc/*/*/*; do
            echo patching $i
            if ! test -L $i; then
                LD_LIBRARY_PATH=$out/lib $out/lib/ld-linux*.so.2 \
                    $out/bin/patchelf --set-interpreter $out/lib/ld-linux*.so.2 --set-rpath $out/lib --force-rpath $i
            fi
        done

        # Fix the libc linker script.
        for i in $out/lib/libc.so; do
            cat $i | sed "s|/nix/store/e*-[^/]*/|$out/|g" > $i.tmp
            mv $i.tmp $i
        done
      ''; # " */

      allowedReferences = ["out"];
    };

    
}
