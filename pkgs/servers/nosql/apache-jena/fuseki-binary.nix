{ lib, stdenv, fetchurl, java, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "apache-jena-fuseki";
  version = "4.3.1";
  src = fetchurl {
    url = "https://dlcdn.apache.org/jena/binaries/apache-jena-fuseki-${version}.tar.gz";
    sha256 = "1r0vfa7d55lzw22yfx46mxxmz8x8pkr666vggqw2m1rzzj52z9nx";
  };
  buildInputs = [
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
