{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "ps3netsrv";
  version = "1.1.0";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "dirkvdb";
    repo = "ps3netsrv--";
    rev = "e54a66cbf142b86e2cffc1701984b95adb921e81";
    sha256 = "sha256-SpPyRhPwOhTONAYH/eqLGmVl2XzhA1r1nUwKj7+rGyY=";
    fetchSubmodules = true;
  };

  buildPhase = "make CXX=$CXX";
  installPhase = ''
    mkdir -p $out/bin
    cp ps3netsrv++ $out/bin
  '';

  meta = {
    description = "C++ implementation of the ps3netsrv server";
    homepage = "https://github.com/dirkvdb/ps3netsrv--";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ makefu ];
    mainProgram = "ps3netsrv++";
  };
}
