{ lib, stdenv, fetchurl, nettle }:

stdenv.mkDerivation rec {
  pname = "rdfind";
  version = "1.5.0";

  src = fetchurl {
    url = "https://rdfind.pauldreik.se/${pname}-${version}.tar.gz";
    sha256 = "103hfqzgr6izmj57fcy4jsa2nmb1ax43q4b5ij92pcgpaq9fsl21";
  };

  buildInputs = [ nettle ];

  meta = with lib; {
    homepage = "https://rdfind.pauldreik.se/";
    description = "Removes or hardlinks duplicate files very swiftly";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.wmertens ];
    platforms = platforms.all;
  };
}
