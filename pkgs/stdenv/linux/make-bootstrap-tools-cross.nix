{system ? builtins.currentSystem}:

let buildFor = toolsArch: (

let
  pkgsFun = import ../../..;
  pkgsNoParams = pkgsFun {};
  
  sheevaplugCrossSystem = {
    crossSystem = rec {
      config = "armv5tel-unknown-linux-gnueabi";
      bigEndian = false;
      arch = "arm";
      float = "soft";
      withTLS = true;
      libc = "glibc";
      platform = pkgsNoParams.platforms.sheevaplug;
      openssl.system = "linux-generic32";
    };
  };
  
  raspberrypiCrossSystem = {
    crossSystem = rec {
      config = "armv6l-unknown-linux-gnueabi";  
      bigEndian = false;
      arch = "arm";
      float = "hard";
      fpu = "vfp";
      withTLS = true;
      libc = "glibc";
      platform = pkgsNoParams.platforms.raspberrypi;
      openssl.system = "linux-generic32";
      inherit (platform) gcc;
    };
  };
  
  armv7l-hf-multiplatform-crossSystem = {
    crossSystem = rec {
      config = "armv7l-unknown-linux-gnueabi";  
      bigEndian = false;
      arch = "arm";
      float = "hard";
      fpu = "vfpv3-d16";
      withTLS = true;
      libc = "glibc";
      platform = pkgsNoParams.platforms.armv7l-hf-multiplatform;
      openssl.system = "linux-generic32";
      inherit (platform) gcc;
    };
  };
  
  selectedCrossSystem =
    if toolsArch == "armv5tel" then sheevaplugCrossSystem else
    if toolsArch == "armv6l" then raspberrypiCrossSystem else
    if toolsArch == "armv7l" then armv7l-hf-multiplatform-crossSystem else null;

  pkgs = pkgsFun ({inherit system;} // selectedCrossSystem);

  inherit (pkgs) stdenv nukeReferences cpio binutilsCross;

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
  gcc = pkgs.gcc.cc.crossDrv;
  gmpxx = pkgs.gmpxx.crossDrv;
  mpfr = pkgs.mpfr.crossDrv;
  ppl = pkgs.ppl.crossDrv;
  cloogppl = pkgs.cloogppl.crossDrv;
  cloog = pkgs.cloog.crossDrv;
  zlib = pkgs.zlib.crossDrv;
  isl = pkgs.isl.crossDrv;
  libmpc = pkgs.libmpc.crossDrv;
  binutils = pkgs.binutils.crossDrv;
  libelf = pkgs.libelf.crossDrv;

in

rec {

  # We want coreutils without ACL support.
  coreutilsMinimal = (pkgs.coreutils.override (args: {
    aclSupport = false;
  })).crossDrv;
  
  curlMinimal = (pkgs.curl.override {
    zlibSupport = false;
    sslSupport = false;
    scpSupport = false;
  }).crossDrv;
  
  busyboxMinimal = (pkgs.busybox.override {
    # TBD: uClibc is broken.
    # useUclibc = true;
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
  }).crossDrv;
  
  inherit pkgs;

  build = 

    stdenv.mkDerivation {
      name = "build";

      buildInputs = [nukeReferences cpio binutilsCross];

      crossConfig = stdenv.cross.config;

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
        chmod -R u+w $out/include
        
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
        cp ${gnutar}/bin/tar $out/bin
        cp ${gzip}/bin/gzip $out/bin
        cp ${bzip2.bin}/bin/bzip2 $out/bin
        cp -d ${gnumake}/bin/* $out/bin
        cp -d ${patch}/bin/* $out/bin
        cp ${patchelf}/bin/* $out/bin
        cp ${curlMinimal}/bin/curl $out/bin
        cp -d ${curlMinimal}/lib/libcurl* $out/lib

        cp -d ${gnugrep.pcre.crossDrv}/lib/libpcre*.so* $out/lib # needed by grep
        
        # Copy what we need of GCC.
        cp -d ${gcc}/bin/gcc $out/bin
        cp -d ${gcc}/bin/cpp $out/bin
        cp -d ${gcc}/bin/g++ $out/bin
        cp -d ${gcc}/lib*/libgcc_s.so* $out/lib
        cp -d ${gcc}/lib*/libstdc++.so* $out/lib
        cp -rd ${gcc}/lib/gcc $out/lib
        chmod -R u+w $out/lib
        rm -f $out/lib/gcc/*/*/include*/linux
        rm -f $out/lib/gcc/*/*/include*/sound
        rm -rf $out/lib/gcc/*/*/include*/root
        rm -f $out/lib/gcc/*/*/include-fixed/asm
        rm -rf $out/lib/gcc/*/*/plugin
        #rm -f $out/lib/gcc/*/*/*.a
        cp -rd ${gcc}/libexec/* $out/libexec
        chmod -R u+w $out/libexec
        rm -rf $out/libexec/gcc/*/*/plugin
        mkdir $out/include
        cp -rd ${gcc}/include/c++ $out/include
        chmod -R u+w $out/include
        rm -rf $out/include/c++/*/ext/pb_ds
        rm -rf $out/include/c++/*/ext/parallel

        cp -d ${gmpxx}/lib/libgmp*.so* $out/lib
        cp -d ${mpfr.out}/lib/libmpfr*.so* $out/lib
        cp -d ${libmpc}/lib/libmpc*.so* $out/lib
        cp -d ${zlib.out}/lib/libz.so* $out/lib
        cp -d ${libelf}/lib/libelf.so* $out/lib
        
        # TBD: Why are these needed for cross but not native tools?
        cp -d ${cloogppl}/lib/libcloog*.so* $out/lib
        cp -d ${cloog}/lib/libcloog*.so* $out/lib
        cp -d ${isl}/lib/libisl*.so* $out/lib
        
        # Copy binutils.
        for i in as ld ar ranlib nm strip readelf objdump; do
          cp ${binutils}/bin/$i $out/bin
        done
        cp -d ${binutils.out}/lib/lib*.so* $out/lib

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

}

); in {
    armv5tel = buildFor "armv5tel";
    armv6l = buildFor "armv6l";
    armv7l = buildFor "armv7l";
}
