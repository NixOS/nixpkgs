{ stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cups-1.1.23";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.funet.fi/pub/mirrors/ftp.easysw.com/pub/cups/1.1.23/cups-1.1.23-source.tar.bz2;
    md5 = "4ce09b1dce09b6b9398af0daae9adf63";
  };
  patches = [./cups-rc.d.patch];
}
