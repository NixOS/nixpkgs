{ lib, stdenv, fetchurl, nettle }:

stdenv.mkDerivation rec {
  pname = "rdfind";
  version = "1.6.0";

  src = fetchurl {
    url = "https://rdfind.pauldreik.se/${pname}-${version}.tar.gz";
    sha256 = "sha256-ekBujvGIalhpZVYEYY3Zj2cvEsamvkkm0FO+ZQcPMnk=";
  };

  buildInputs = [ nettle ];

  meta = with lib; {
    homepage = "https://rdfind.pauldreik.se/";
    description = "Removes or hardlinks duplicate files very swiftly";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.wmertens ];
    platforms = platforms.all;
    mainProgram = "rdfind";
  };
}
