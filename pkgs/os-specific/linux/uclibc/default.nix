{stdenv, fetchurl, linuxHeaders, libiconv, cross ? null, gccCross ? null,
extraConfig ? ""}:

assert stdenv.isLinux;
assert cross != null -> gccCross != null;

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

            if test "$NAME" == "CLEAR"; then
                echo "parseconfig: CLEAR"
                echo > .config
            fi

            echo "parseconfig: removing $NAME"
            sed -i /^$NAME=/d .config

            if test "$OPTION" != n; then
                echo "parseconfig: setting $NAME=$OPTION"
                echo "$NAME=$OPTION" >> .config
            fi
        done
        set +x
    }
  '';

  archMakeFlag = if cross != null then "ARCH=${cross.arch}" else "";
  crossMakeFlag = if cross != null then "CROSS=${cross.config}-" else "";

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
  '';

in
stdenv.mkDerivation {
  name = "uclibc-0.9.33.2" + stdenv.lib.optionalString (cross != null)
    ("-" + cross.config);

  src = fetchurl {
    url = http://www.uclibc.org/downloads/uClibc-0.9.33.2.tar.bz2;
    sha256 = "0qhngsbzj2s6nz92b1s2p0dmvwk8xiqpy58j7ljzw186grvjr3cq";
  };

  # 'ftw' needed to build acl, a coreutils dependency
  configurePhase = ''
    make defconfig ${archMakeFlag}
    ${configParser}
    cat << EOF | parseconfig
    ${nixConfig}
    ${extraConfig}
    ${if cross != null then stdenv.lib.attrByPath [ "uclibc" "extraConfig" ] "" cross else ""}
    $extraCrossConfig
    EOF
    make oldconfig
  '';

  # Cross stripping hurts.
  dontStrip = cross != null;

  makeFlags = [ crossMakeFlag "VERBOSE=1" ];

  buildInputs = stdenv.lib.optional (gccCross != null) gccCross;

  installPhase = ''
    mkdir -p $out
    make PREFIX=$out VERBOSE=1 install ${crossMakeFlag}
    (cd $out/include && ln -s $(ls -d ${linuxHeaders}/include/* | grep -v "scsi$") .)
    # libpthread.so may not exist, so I do || true
    sed -i s@/lib/@$out/lib/@g $out/lib/libc.so $out/lib/libpthread.so || true
  '';

  passthru = {
    # Derivations may check for the existance of this attribute, to know what to link to.
    inherit libiconv;
  };
  
  meta = {
    homepage = http://www.uclibc.org/;
    description = "A small implementation of the C library";
    license = "LGPLv2";
  };
}
