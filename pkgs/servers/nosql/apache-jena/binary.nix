{ lib, stdenv, fetchurl, java, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "apache-jena";
  version = "4.7.0";
  src = fetchurl {
    url = "https://dlcdn.apache.org/jena/binaries/apache-jena-${version}.tar.gz";
    sha256 = "sha256-3tJRJ9UHsOYfWvwPZHp+hkRZxb0RODchJjQMAZ3lkuY=";
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
    platforms = platforms.linux;
    homepage = "https://jena.apache.org";
    downloadPage = "https://archive.apache.org/dist/jena/binaries/";
  };
}
