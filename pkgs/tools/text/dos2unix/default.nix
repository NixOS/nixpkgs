{stdenv, fetchurl, perl, gettext }:

stdenv.mkDerivation rec {
  pname = "dos2unix";
  version = "7.4.1";

  src = fetchurl {
    url = "https://waterlan.home.xs4all.nl/dos2unix/${pname}-${version}.tar.gz";
    sha256 = "08w6yywzirsxq8bh87jycvvw922ybhc2l426j2iqzliyn1h8mm8w";
  };

  configurePhase = ''
    substituteInPlace Makefile \
    --replace /usr $out
    '';

  nativeBuildInputs = [ perl gettext ];

  meta = with stdenv.lib; {
    homepage = http://waterlan.home.xs4all.nl/dos2unix.html;
    description = "Tools to transform text files from dos to unix formats and vicervesa";
    license = licenses.bsd2;
    maintainers = with maintainers; [ndowens ];

  };
}
