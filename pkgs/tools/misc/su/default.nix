{stdenv, fetchurl, pam}:

# This is just coreutils, except that we only build su, with the PAM
# patch.  We build su separately because we don't want to give all of
# coreutils a dependency on PAM.

stdenv.mkDerivation {
  name = "su-7.0";
  
  src = fetchurl {
    url = "ftp://alpha.gnu.org/gnu/coreutils/coreutils-7.0.tar.gz";
    sha256 = "00cwf8rqbj89ikv8fhdhv26dpc2ghzw1hn48pk1vg3nnmxj55nr7";
  };
  
  patches = [
    # PAM patch taken from SUSE's coreutils-6.7-5.src.rpm.
    ./su-pam.patch
  ];
  
  buildInputs = [pam];
  
  buildPhase = ''
    make -C lib
    make -C src version.h
    make -C src su su_OBJECTS="su.o getdef.o" CFLAGS="-DUSE_PAM" LDFLAGS="-lpam -lpam_misc -ldl"
  '';
  
  installPhase = ''
    ensureDir $out/bin
    cp src/su $out/bin
  '';
}
