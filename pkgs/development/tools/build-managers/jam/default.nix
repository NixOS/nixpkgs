{ lib, stdenv, fetchurl, bison }:

stdenv.mkDerivation rec {
  pname = "jam";
  version = "2.6.1";

  src = fetchurl {
    url = "https://swarm.workshop.perforce.com/projects/perforce_software-jam/download/main/${pname}-${version}.tar";
    sha256 = "19xkvkpycxfsncxvin6yqrql3x3z9ypc1j8kzls5k659q4kv5rmc";
  };

  nativeBuildInputs = [ bison ];

  # Jambase expects ar to have flags.
  preConfigure = ''
    export AR="$AR rc"
  '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

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
    maintainers = with maintainers; [ impl orivej ];
    platforms = platforms.unix;
  };
}
