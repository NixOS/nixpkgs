{
  lib,
  stdenv,
  fetchurl,
  java,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "apache-jena";
  version = "6.0.0";
  src = fetchurl {
    url = "mirror://apache/jena/binaries/apache-jena-${version}.tar.gz";
    hash = "sha256-N8TPKExwUNdlrPB23/qQm08io/JHq3bDzVoCd8ot6VQ=";
  };
  nativeBuildInputs = [
    makeWrapper
  ];
  installPhase = ''
    cp -r . "$out"
    for i in "$out"/bin/*; do
      wrapProgram "$i" --prefix "PATH" : "${java}/bin/"
    done
  '';
  meta = {
    description = "RDF database";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.unix;
    homepage = "https://jena.apache.org";
    downloadPage = "https://archive.apache.org/dist/jena/binaries/";
  };
}
