{ lib, stdenv, fetchurl, allegro }:

stdenv.mkDerivation rec {
  pname = "atanks";
  version = "6.6";

  src = fetchurl {
    url = "mirror://sourceforge/project/atanks/atanks/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-vGse/J/H52JPrR2DUtcuknvg+6IWC7Jbtri9bGNwv0M=";
  };

  buildInputs = [ allegro ];

  makeFlags = [ "PREFIX=$(out)/" "INSTALL=install" "CXX=g++" ];

  meta = with lib; {
    description = "Atomic Tanks ballistics game";
    mainProgram = "atanks";
    homepage = "http://atanks.sourceforge.net/";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
