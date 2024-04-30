{ lib
, stdenvNoCC
, fetchurl
, makeWrapper
, jdk17_headless
, nixosTests
}:

stdenvNoCC.mkDerivation rec {
  pname = "komga";
  version = "1.11.0";

  src = fetchurl {
    url = "https://github.com/gotson/${pname}/releases/download/${version}/${pname}-${version}.jar";
    sha256 = "sha256-bqWPkD8Pzlryv5wG65cEJNLoFVsu6yCymUgyfhrQR0M=";
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

  meta = {
    description = "Free and open source comics/mangas server";
    homepage = "https://komga.org/";
    license = lib.licenses.mit;
    platforms = jdk17_headless.meta.platforms;
    maintainers = with lib.maintainers; [ govanify ];
    mainProgram = "komga";
  };

}
