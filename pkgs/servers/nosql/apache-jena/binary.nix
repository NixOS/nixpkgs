{
  lib,
  stdenv,
  fetchurl,
  java,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "apache-jena";
  version = "5.6.0";
  src = fetchurl {
    url = "mirror://apache/jena/binaries/apache-jena-${version}.tar.gz";
    hash = "sha256-s5qmzKBrED7U1Qm0Lu5RI5QIiFnfK1NnqFiSe/H85yg=";
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
