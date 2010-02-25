{stdenv, fetchurl, zlib, libpng, gd, geoip, db4}:

stdenv.mkDerivation {
  name = "webalizer-2.21-02";

  src = fetchurl {
    url = ftp://ftp.mrunix.net/pub/webalizer/webalizer-2.21-02-src.tgz;
    sha256 = "0spfsqxhgfnmd2yyhrmrj8chjilr8qbx1g2n3kn44k9gd4y3jfc7";
  };

  preConfigure =
    ''
      substituteInPlace ./configure \
        --replace "--static" "" 
    '';

  buildInputs = [zlib libpng gd geoip db4]; 

  configureFlags = "--enable-dns --enable-geoip --disable-static --enable-shared";
}
