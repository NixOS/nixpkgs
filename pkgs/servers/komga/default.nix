{ lib
, stdenvNoCC
, fetchurl
, makeWrapper
, jdk11_headless
}:

stdenvNoCC.mkDerivation rec {
  pname = "komga";
  version = "0.157.0";

  src = fetchurl {
    url = "https://github.com/gotson/${pname}/releases/download/v${version}/${pname}-${version}.jar";
    sha256 = "sha256-PkQL61fKplt6h1jcFCIMER+ZfzowDP466dR1AaDHw5Q=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildCommand = ''
    makeWrapper ${jdk11_headless}/bin/java $out/bin/komga --add-flags "-jar $src"
  '';

  meta = with lib; {
    description = "Free and open source comics/mangas server";
    homepage = "https://komga.org/";
    license = licenses.mit;
    platforms = jdk11_headless.meta.platforms;
    maintainers = with maintainers; [ govanify ];
  };

}
