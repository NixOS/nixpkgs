{stdenv, fetchurl, pam}:

# This is just coreutils, except that we only build su, with the PAM
# patch.  We build su separately because we don't want to give all of
# coreutils a dependency on PAM.

stdenv.mkDerivation {
  name = "su-6.7";
  src = fetchurl {
    url = mirror://gnu/coreutils/coreutils-6.7.tar.bz2;
    md5 = "a16465d0856cd011a1acc1c21040b7f4";
  };
  patches = [
    # PAM patch taken from SUSE's coreutils-6.7-5.src.rpm.
    ./su-pam.patch
  ];
  buildInputs = [pam];
  buildPhase = "
    make -C lib
    make -C src su su_OBJECTS=\"su.o getdef.o\" CFLAGS=\"-DUSE_PAM\" LDFLAGS=\"-lpam -lpam_misc -ldl\"
  ";
  installPhase = "
    ensureDir $out/bin
    cp src/su $out/bin
  ";
}
