{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "marlin-calc";
  version = "2019-06-04";

  src = fetchFromGitHub {
    owner = "eyal0";
    repo = "Marlin";
    rev = "4120d1c72d6c32e9c5cc745c05d20963ba4bbca3";
    sha256 = "06aly7s4k1r31njm43sbxq9a0127sw43pnaddh92a3cc39rbj2va";
  };

  buildPhase = ''
    cd Marlin/src
    c++ module/planner.cpp module/calc.cpp feature/fwretract.cpp \
      -O2 -Wall -std=gnu++11 -o marlin-calc
  '';

  installPhase = ''
    install -Dm0755 {,$out/bin/}marlin-calc
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/eyal0/Marlin";
    description = "Marlin 3D printer timing simulator";
    license = licenses.gpl3;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.unix;
  };
}
