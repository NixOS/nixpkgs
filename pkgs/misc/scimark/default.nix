{ lib
, stdenv
, fetchurl
, unzip
}:

stdenv.mkDerivation rec {
  pname = "scimark";
  version = "4c";

  src = fetchurl {
    url = "https://math.nist.gov/scimark2/${pname}${version}.zip";
    hash = "sha256-kcg5vKYp0B7+bC/CmFMO/tMwxf9q6nvuFv0vRSy3MbE=";
  };

  nativeBuildInputs = [
    unzip
  ];

  dontConfigure = true;

  installPhase = ''
    install -d $out/bin/
    install scimark4 $out/bin/
  '';

  meta = with lib; {
    homepage = "https://math.nist.gov/scimark2/index.html";
    description = "Scientific and numerical computing benchmark (ANSI C version)";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ AndersonTorres ];
    mainProgram = "scimark4";
    platforms = platforms.all;
  };
}
# TODO [ AndersonTorres ]: Java version
