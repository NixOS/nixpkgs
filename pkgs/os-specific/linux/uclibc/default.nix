{stdenv, fetchurl, linuxHeaders, cross ? null, gccCross ? null}:

assert stdenv.isLinux;
assert cross != null -> gccCross != null;

let
    enableArmEABI = (cross == null && stdenv.platform.kernelArch == "arm")
      || (cross != null && cross.arch == "arm");

    configArmEABI = if enableArmEABI then
        ''-e 's/.*CONFIG_ARM_OABI.*//' \
        -e 's/.*CONFIG_ARM_EABI.*/CONFIG_ARM_EABI=y/' '' else "";

    enableBigEndian = (cross != null && cross.bigEndian);
    
    configBigEndian = if enableBigEndian then ""
      else
        ''-e 's/.*ARCH_BIG_ENDIAN.*/#ARCH_BIG_ENDIAN=y/' \
        -e 's/.*ARCH_WANTS_BIG_ENDIAN.*/#ARCH_WANTS_BIG_ENDIAN=y/' \
        -e 's/.*ARCH_WANTS_LITTLE_ENDIAN.*/ARCH_WANTS_LITTLE_ENDIAN=y/' '';

    archMakeFlag = if (cross != null) then "ARCH=${cross.arch}" else "";
    crossMakeFlag = if (cross != null) then "CROSS=${cross.config}-" else "";
in
stdenv.mkDerivation {
  name = "uclibc-0.9.30.2" + stdenv.lib.optionalString (cross != null)
    ("-" + cross.config);

  src = fetchurl {
    url = http://www.uclibc.org/downloads/uClibc-0.9.30.2.tar.bz2;
    sha256 = "0wr4hlybssiyswdc73wdcxr31xfbss3lnqiv5lcav3rg3v4r4vmb";
  };

  configurePhase = ''
    make defconfig ${archMakeFlag}
    sed -e s@/usr/include@${linuxHeaders}/include@ \
      -e 's@^RUNTIME_PREFIX.*@RUNTIME_PREFIX="/"@' \
      -e 's@^DEVEL_PREFIX.*@DEVEL_PREFIX="/"@' \
      -e 's@.*UCLIBC_HAS_WCHAR.*@UCLIBC_HAS_WCHAR=y@' \
      -e 's@.*UCLIBC_HAS_RPC.*@UCLIBC_HAS_RPC=y@' \
      -e 's@.*DO_C99_MATH.*@DO_C99_MATH=y@' \
      -e 's@.*UCLIBC_HAS_PROGRAM_INVOCATION_NAME.*@UCLIBC_HAS_PROGRAM_INVOCATION_NAME=y@' \
      ${configArmEABI} \
      ${configBigEndian} \
      -i .config
    make oldconfig
  '';

  # Cross stripping hurts.
  dontStrip = if (cross != null) then true else false;

  makeFlags = [ crossMakeFlag "VERBOSE=1" ];

  buildInputs = stdenv.lib.optional (gccCross != null) gccCross;

  installPhase = ''
    mkdir -p $out
    make PREFIX=$out VERBOSE=1 install ${crossMakeFlag}
    (cd $out/include && ln -s $(ls -d ${linuxHeaders}/include/* | grep -v "scsi$") .)
    sed -i s@/lib/@$out/lib/@g $out/lib/libc.so
  '';
  
  meta = {
    homepage = http://www.uclibc.org/;
    description = "A small implementation of the C library";
    license = "LGPLv2";
  };
}
