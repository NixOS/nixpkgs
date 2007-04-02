{stdenv, fetchurl, zlib, libjpeg, libpng, libtiff, pam}:

stdenv.mkDerivation {
  name = "cups-1.2.10";
  
  src = fetchurl {
    url = http://ftp.funet.fi/pub/mirrors/ftp.easysw.com/pub/cups/1.2.10/cups-1.2.10-source.tar.bz2;
    sha256 = "0dmvjl513kqbb7m4m0b22wa4xvn9avdyihr7fi3n2ly5as93n6v0";
  };

  buildInputs = [zlib libjpeg libpng libtiff pam];
  
  preBuild = "
    makeFlagsArray=(INITDIR=$out/etc/rc.d)
  ";
}
