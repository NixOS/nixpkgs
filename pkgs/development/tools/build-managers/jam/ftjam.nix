{ lib
, stdenv
, fetchurl
, bison
}:

stdenv.mkDerivation rec {
  pname = "ftjam";
  version = "2.5.2";

  src = fetchurl {
    url = "https://downloads.sourceforge.net/project/freetype/${pname}/${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-6JdzUAqSkS3pGOn+v/q+S2vOedaa8ZRDX04DK4ptZqM=";
  };

  nativeBuildInputs = [
    bison
  ];

  preConfigure = ''
    unset AR
  '';

  buildPhase = ''
    runHook preBuild

    make jam0

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ./jam0 -j$NIX_BUILD_CORES -sBINDIR=$out/bin install
    mkdir -p $out/doc/jam
    cp *.html $out/doc/jam

    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://freetype.org/jam/";
    description = "Freetype's enhanced, backwards-compatible Jam clone";
    license = licenses.free;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
# TODO: setup hook for Jam
