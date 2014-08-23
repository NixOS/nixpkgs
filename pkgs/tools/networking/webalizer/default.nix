{stdenv, fetchurl, zlib, libpng, gd, geoip, db}:

stdenv.mkDerivation {
  name = "webalizer-2.23-05";

  src = fetchurl {
    url = ftp://ftp.mrunix.net/pub/webalizer/webalizer-2.23-05-src.tar.bz2;
    sha256 = "0nl88y57a7gawfragj3viiigfkh5sgivfb4n0k89wzcjw278pj5g";
  };

  preConfigure =
    ''
      substituteInPlace ./configure \
        --replace "--static" "" 
    '';

  buildInputs = [zlib libpng gd geoip db]; 

  configureFlags = "--enable-dns --enable-geoip --disable-static --enable-shared";
}
