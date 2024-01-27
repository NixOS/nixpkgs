{ lib, stdenv, fetchurl, java, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "apache-jena";
  version = "4.10.0";
  src = fetchurl {
    url = "mirror://apache/jena/binaries/apache-jena-${version}.tar.gz";
    hash = "sha256-G2kCh5F2WfrSOCr+fEO02mlOSVfV2Oy3uZGNEarLR+M=";
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
