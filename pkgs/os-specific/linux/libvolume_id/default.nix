{stdenv, fetchurl}:
   
stdenv.mkDerivation {
  name = "libvolume_id-0.81.1";
   
  src = fetchurl {
    url = http://www.marcuscom.com/downloads/libvolume_id-0.81.1.tar.bz2;
    sha256 = "029z04vdxxsl8gycm9whcljhv6dy4b12ybsxdb99jr251gl1ifs5";
  };

  preBuild = "
    makeFlagsArray=(prefix=$out E=echo RANLIB=ranlib INSTALL='install -c')
  ";

  # Work around a broken Makefile.
  postInstall = "
    rm $out/lib/libvolume_id.so.0
    cp -f libvolume_id.so.0 $out/lib/
  ";

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
