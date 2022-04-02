{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "marlin-calc";
  version = "2019-10-17";

  src = fetchFromGitHub {
    owner = "eyal0";
    repo = "Marlin";
    rev = "3d5a5c86bea35a2a169eb56c70128bf2d070feef";
    sha256 = "14sqajm361gnrcqv84g7kbmyqm8pppbhqsabszc4j2cn7vbwkdg5";
  };

  buildPhase = ''
    cd Marlin/src
    c++ module/planner.cpp module/calc.cpp feature/fwretract.cpp \
      -O2 -Wall -std=gnu++11 -o marlin-calc
  '';

  installPhase = ''
    install -Dm0755 {,$out/bin/}marlin-calc
  '';

  meta = with lib; {
    homepage = "https://github.com/eyal0/Marlin";
    description = "Marlin 3D printer timing simulator";
    license = licenses.gpl3;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/marlin-calc.x86_64-darwin
  };
}
