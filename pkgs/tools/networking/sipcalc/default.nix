{stdenv, fetchurl}:
stdenv.mkDerivation rec {
  name = "sipcalc-${version}";
  version = "1.1.6";
  src = fetchurl {
    url = "http://www.routemeister.net/projects/sipcalc/files/${name}.tar.gz";
    sha256 = "cfd476c667f7a119e49eb5fe8adcfb9d2339bc2e0d4d01a1d64b7c229be56357";
  };
  meta = {
    description = "Advanced console ip subnet calculator";
    homepage = http://www.routemeister.net/projects/sipcalc/;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.all;
  };
}
