{ lib
, stdenvNoCC
, fetchurl
, makeWrapper
, jdk17_headless
, nixosTests
}:

stdenvNoCC.mkDerivation rec {
  pname = "komga";
  version = "1.5.1";

  src = fetchurl {
    url = "https://github.com/gotson/${pname}/releases/download/v${version}/${pname}-${version}.jar";
    sha256 = "sha256-mEeeMMTZlAfBxp44gV8OLjyGrzcp+XCMPJLJ/sFELHs=";
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
  };

}
