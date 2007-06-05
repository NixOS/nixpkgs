{stdenv, fetchurl}:
   
stdenv.mkDerivation {
  name = "libvolume_id-0.75.0";
   
  src = fetchurl {
    url = http://www.marcuscom.com/downloads/libvolume_id-0.75.0.tar.bz2;
    sha256 = "1n1ji2jz45ncvyv529nz8xwcz058z9z98970v9h2wwwg8ra2a1sl";
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
