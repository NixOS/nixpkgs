{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "sipcalc";
  version = "1.1.6";

  src = fetchurl {
    url = "http://www.routemeister.net/projects/sipcalc/files/${pname}-${version}.tar.gz";
    sha256 = "cfd476c667f7a119e49eb5fe8adcfb9d2339bc2e0d4d01a1d64b7c229be56357";
  };

  meta = with lib; {
    description = "Advanced console ip subnet calculator";
    homepage = "http://www.routemeister.net/projects/sipcalc/";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ maintainers.globin ];
    mainProgram = "sipcalc";
  };
}
