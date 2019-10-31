{ stdenv, fetchgit }:

stdenv.mkDerivation {
  pname = "ps3netsrv";
  version = "1.1.0";

  enableParallelBuilding = true;

  src = fetchgit {
    url = "https://github.com/dirkvdb/ps3netsrv--";
    fetchSubmodules = true;
    rev = "e54a66cbf142b86e2cffc1701984b95adb921e81";
    sha256 = "09hvmfzqy2jckpsml0z1gkcnar8sigmgs1q66k718fph2d3g54sa";
  };

  buildPhase = "make CXX=$CXX";
  installPhase = ''
    mkdir -p $out/bin
    cp ps3netsrv++ $out/bin
  '';

  meta = {
    description = "C++ implementation of the ps3netsrv server";
    homepage = https://github.com/dirkvdb/ps3netsrv--;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ makefu ];
  };
}
