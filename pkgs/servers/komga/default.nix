{ lib
, stdenvNoCC
, fetchurl
, makeWrapper
, jdk17_headless
, nixosTests
}:

stdenvNoCC.mkDerivation rec {
  pname = "komga";
  version = "1.6.4";

  src = fetchurl {
    url = "https://github.com/gotson/${pname}/releases/download/v${version}/${pname}-${version}.jar";
    sha256 = "sha256-tqrC3l2njYGRVIdvt86JVKTCVaAK7GPoYacx3hFRggg=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildCommand = ''
    makeWrapper ${jdk17_headless}/bin/java $out/bin/komga --add-flags "-jar $src"
  '';

  passthru.tests = {
    komga = nixosTests.komga;
  };

  meta = with lib; {
    description = "Free and open source comics/mangas server";
    homepage = "https://komga.org/";
    license = licenses.mit;
    platforms = jdk17_headless.meta.platforms;
    maintainers = with maintainers; [ govanify ];
    mainProgram = "komga";
  };

}
