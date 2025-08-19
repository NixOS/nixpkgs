{
  lib,
  stdenv,
  fetchurl,
  java,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "apache-jena";
  version = "5.5.0";
  src = fetchurl {
    url = "mirror://apache/jena/binaries/apache-jena-${version}.tar.gz";
    hash = "sha256-atRcW9U3PjX/E3QhTa6dBfvb19Rb3n6ROpLeGinGD1U=";
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
  meta = with lib; {
    description = "RDF database";
    license = licenses.asl20;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
    homepage = "https://jena.apache.org";
    downloadPage = "https://archive.apache.org/dist/jena/binaries/";
  };
}
