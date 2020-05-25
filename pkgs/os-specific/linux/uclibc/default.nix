{ stdenv, buildPackages
, fetchurl, linuxHeaders, libiconvReal
, extraConfig ? ""
}:

let
  configParser = ''
    function parseconfig {
        set -x
        while read LINE; do
            NAME=`echo "$LINE" | cut -d \  -f 1`
            OPTION=`echo "$LINE" | cut -d \  -f 2`

            if test -z "$NAME"; then
                continue
            fi

            echo "parseconfig: removing $NAME"
            sed -i /^$NAME=/d .config

            #if test "$OPTION" != n; then
                echo "parseconfig: setting $NAME=$OPTION"
                echo "$NAME=$OPTION" >> .config
            #fi
        done
        set +x
    }
  '';

  # UCLIBC_SUSV4_LEGACY defines 'tmpnam', needed for gcc libstdc++ builds.
  nixConfig = ''
    RUNTIME_PREFIX "/"
    DEVEL_PREFIX "/"
    UCLIBC_HAS_WCHAR y
    UCLIBC_HAS_FTW y
    UCLIBC_HAS_RPC y
    DO_C99_MATH y
    UCLIBC_HAS_PROGRAM_INVOCATION_NAME y
    UCLIBC_SUSV4_LEGACY y
    UCLIBC_HAS_THREADS_NATIVE y
    KERNEL_HEADERS "${linuxHeaders}/include"
  '' + stdenv.lib.optionalString (stdenv.isAarch32 && stdenv.buildPlatform != stdenv.hostPlatform) ''
    CONFIG_ARM_EABI y
    ARCH_WANTS_BIG_ENDIAN n
    ARCH_BIG_ENDIAN n
    ARCH_WANTS_LITTLE_ENDIAN y
    ARCH_LITTLE_ENDIAN y
    UCLIBC_HAS_FPU n
  '';

  version = "1.0.33";
in

stdenv.mkDerivation {
  name = "uclibc-ng-${version}";
  inherit version;

  src = fetchurl {
    url = "https://downloads.uclibc-ng.org/releases/${version}/uClibc-ng-${version}.tar.bz2";
    # from "${url}.sha256";
    sha256 = "0qy9xsqacrhhrxd16azm26pqb2ks6c43wbrlq3i8xmq2917kw3xi";
  };

  # 'ftw' needed to build acl, a coreutils dependency
  configurePhase = ''
    make defconfig
    ${configParser}
    cat << EOF | parseconfig
    ${nixConfig}
    ${extraConfig}
    ${stdenv.hostPlatform.platform.uclibc.extraConfig or ""}
    EOF
    ( set +o pipefail; yes "" | make oldconfig )
  '';

  hardeningDisable = [ "stackprotector" ];

  # Cross stripping hurts.
  dontStrip = stdenv.hostPlatform != stdenv.buildPlatform;

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  makeFlags = [
    "ARCH=${stdenv.hostPlatform.parsed.cpu.name}"
    "VERBOSE=1"
  ] ++ stdenv.lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "CROSS=${stdenv.cc.targetPrefix}"
  ];

  # `make libpthread/nptl/sysdeps/unix/sysv/linux/lowlevelrwlock.h`:
  # error: bits/sysnum.h: No such file or directory
  enableParallelBuilding = false;

  installPhase = ''
    mkdir -p $out
    make PREFIX=$out VERBOSE=1 install
    (cd $out/include && ln -s $(ls -d ${linuxHeaders}/include/* | grep -v "scsi$") .)
    # libpthread.so may not exist, so I do || true
    sed -i s@/lib/@$out/lib/@g $out/lib/libc.so $out/lib/libpthread.so || true
  '';

  passthru = {
    # Derivations may check for the existance of this attribute, to know what to link to.
    libiconv = libiconvReal;
  };

  meta = with stdenv.lib; {
    homepage = "https://uclibc-ng.org";
    description = "A small implementation of the C library";
    maintainers = with maintainers; [ rasendubi ];
    license = licenses.lgpl2;
    platforms = intersectLists platforms.linux platforms.x86; # fails to build on ARM
  };
}
