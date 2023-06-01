{ lib, stdenv, fetchurl, java, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "apache-jena-fuseki";
  version = "4.8.0";
  src = fetchurl {
    url = "mirror://apache/jena/binaries/apache-jena-fuseki-${version}.tar.gz";
    hash = "sha256-rJCY8vG1vfEGGA0gsIqNFXKl75O2Zp4zUIWSDfplpVE=";
  };
  nativeBuildInputs = [
    makeWrapper
  ];
  installPhase = ''
    cp -r . "$out"
    chmod +x $out/fuseki
    ln -s "$out"/{fuseki-backup,fuseki-server,fuseki} "$out/bin"
    for i in "$out"/bin/*; do
      wrapProgram "$i" \
        --prefix "PATH" : "${java}/bin/" \
        --set-default "FUSEKI_HOME" "$out" \
        ;
    done
  '';
  meta = with lib; {
    description = "SPARQL server";
    license = licenses.asl20;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    homepage = "https://jena.apache.org";
    downloadPage = "https://archive.apache.org/dist/jena/binaries/";
  };
}
