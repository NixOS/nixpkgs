{stdenv, fetchurl, pkgconfig, libX11, libXau, libXext, libXmu}:

stdenv.mkDerivation {
  name = "xauth-7.0";
  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~eelco/dist/xauth-7.0.tar.bz2;
    md5 = "d597005016baa8af81a5b0e38951d563";
  };
  buildInputs = [pkgconfig libX11 libXau libXext libXmu];
}
