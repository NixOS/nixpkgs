{ stdenv, lib, fetchurl, ncurses, buildPackages }:

let
  isCrossCompiling = stdenv.hostPlatform != stdenv.buildPlatform;
in

stdenv.mkDerivation rec {
  pname = "s9fes";
  version = "20181205";

  src = fetchurl {
    url = "https://www.t3x.org/s9fes/s9fes-${version}.tgz";
    sha256 = "sha256-Lp/akaDy3q4FmIE6x0fj9ae/SOD7tdsmzy2xdcCh13o=";
  };

  # Fix cross-compilation
  postPatch = ''
    substituteInPlace Makefile \
      --replace 'ar q' '${stdenv.cc.targetPrefix}ar q' \
      --replace 'strip' '${stdenv.cc.targetPrefix}strip'
    ${lib.optionalString isCrossCompiling "substituteInPlace Makefile --replace ./s9 '${buildPackages.s9fes}/bin/s9'"}
  '';

  buildInputs = [ ncurses ];
  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" "PREFIX=$(out)" ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Scheme 9 From Empty Space, an interpreter for R4RS Scheme";
    homepage = "http://www.t3x.org/s9fes/index.html";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
  };
}
