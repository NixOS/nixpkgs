{stdenv, fetchurl, kernelHeaders}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "uclibc-0.9.30.1";
  src = fetchurl {
    url = http://www.uclibc.org/downloads/uClibc-0.9.30.1.tar.bz2;
    sha256 = "132cf27hkgi0q4qlwbiyj4ffj76sja0jcxm0aqzzgks65jh6k5rd";
  };

  configurePhase = ''
    make defconfig
    sed -e s@/usr/include@${kernelHeaders}@ \
      -e 's@^RUNTIME_PREFIX.*@RUNTIME_PREFIX="/"@' \
      -e 's@^DEVEL_PREFIX.*@DEVEL_PREFIX="/"@' \
      ${if stdenv.system=="armv5tel-linux" then
      ''-e 's/.*CONFIG_ARM_OABI.*//' \
        -e 's/.*CONFIG_ARM_EABI.*/CONFIG_ARM_EABI=y/' \
        -e 's/.*ARCH_BIG_ENDIAN.*/#ARCH_BIG_ENDIAN=y/' \
        -e 's/.*ARCH_WANTS_BIG_ENDIAN.*/#ARCH_WANTS_BIG_ENDIAN=y/' \
        -e 's/.*ARCH_WANTS_LITTLE_ENDIAN.*/ARCH_WANTS_LITTLE_ENDIAN=y/' '' else ""} \
      -i .config
    make oldconfig
  '';

  installPhase = ''
    mkdir -p $out
    make PREFIX=$out install
    (cd $out/include && ln -s ${kernelHeaders}/include/* .) || exit 1
  '';
  
  meta = {
    homepage = http://www.uclibc.org/;
    description = "A small implementation of the C library";
    license = "LGPLv2";
  };
}
