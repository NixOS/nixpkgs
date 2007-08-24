{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "enscript-1.6.4";
  src = fetchurl {
    url = http://www.iki.fi/mtr/genscript/enscript-1.6.4.tar.gz;
    md5 = "b5174b59e4a050fb462af5dbf28ebba3";
  };
}
