{ lib, stdenv, fetchurl, cmake, elfutils }:

stdenv.mkDerivation rec {
  pname = "dwz";
  version = "0.14";

  src = fetchurl {
    url = "https://www.sourceware.org/ftp/${pname}/releases/${pname}-${version}.tar.gz";
    sha256 = "07qdvzfk4mvbqj5z3aff7vc195dxqn1mi27w2dzs1w2zhymnw01k";
  };

  nativeBuildInputs = [ elfutils ];

  installPhase = ''
    mkdir -p "$out/bin"
    cp dwz "$out/bin"
  '';

  meta = with lib; {
    homepage = "https://sourceware.org/dwz/";
    description = "DWARF optimization and duplicate removal tool";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jbcrail ];
    platforms = platforms.all;
  };
}
