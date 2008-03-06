{stdenv, fetchurl}:
   
stdenv.mkDerivation {
  name = "libvolume_id-0.81.0";
   
  src = fetchurl {
    url = http://www.marcuscom.com/downloads/libvolume_id-0.81.0.tar.bz2;
    sha256 = "1dpmp1kb40kb1jxj6flpi37wy789wf91dm4bax6jspd1jdc6hsrg";
  };

  preBuild = "
    makeFlagsArray=(prefix=$out E=echo RANLIB=ranlib INSTALL='install -c')
  ";

  # Work around a broken Makefile.
  postInstall = "
    rm $out/lib/libvolume_id.so.0
    cp -f libvolume_id.so.0 $out/lib/
  ";
}
