{ lib, stdenv, fetchFromGitHub, cmake, qtcharts, qtbase, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "seer";
  version = "1.15";

  src = fetchFromGitHub {
    owner = "epasveer";
    repo = "seer";
    rev = "v${version}";
    sha256 = "sha256-TktCUO281Cok47qT60DMAO5uUIg1iDH1RKx+fBPezLs=";
  };

  preConfigure = ''
    cd src
  '';

  buildInputs = [ qtbase qtcharts ];
  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  meta = with lib; {
    description = "A Qt gui frontend for GDB";
    homepage = "https://github.com/epasveer/seer";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ foolnotion ];
  };
}
