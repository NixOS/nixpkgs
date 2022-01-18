{ lib, stdenv, fetchurl, bison }:

stdenv.mkDerivation rec {
  pname = "jam";
  version = "2.6.1";

  src = fetchurl {
    url = "https://swarm.workshop.perforce.com/projects/perforce_software-jam/download/main/${pname}-${version}.tar";
    sha256 = "19xkvkpycxfsncxvin6yqrql3x3z9ypc1j8kzls5k659q4kv5rmc";
  };

  nativeBuildInputs = [ bison ];

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
    homepage = "https://www.perforce.com/resources/documentation/jam";
    license = licenses.free;
    description = "Just Another Make";
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.unix;
  };
}
