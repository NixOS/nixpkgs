{stdenv, fetchurl, libjpeg, libX11}:

stdenv.mkDerivation {
  name = "mjpegtools-1.6.2";
  src = fetchurl {
    url = http://mesh.dl.sourceforge.net/sourceforge/mjpeg/mjpegtools-1.6.2.tar.gz ;
    md5 = "01c0120b0182de67f182ef99ad855daa" ;
  };
  buildInputs = [libjpeg libX11];
  patches = [./fix.patch];
}
