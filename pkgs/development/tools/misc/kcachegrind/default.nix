{stdenv, fetchurl, kdelibs}:

stdenv.mkDerivation {
  name = "/kcachegrind-0.4.6";
  src = fetchurl {
    url = http://kcachegrind.sourceforge.net/kcachegrind-0.4.6.tar.gz;
    md5 = "4ed60028dcefd6bf626635d5f2f50273";
  };

  buildInputs = [kdelibs];
}
