{lib, stdenv, fetchurl, java, makeWrapper}:
let
  s = # Generated upstream information
  rec {
    baseName="apache-jena-fuseki";
    version = "4.3.1";
    name="${baseName}-${version}";
    url="https://dlcdn.apache.org/jena/binaries/apache-jena-fuseki-${version}.tar.gz";
    sha256 = "1r0vfa7d55lzw22yfx46mxxmz8x8pkr666vggqw2m1rzzj52z9nx";
  };
  buildInputs = [
    makeWrapper
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
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
  meta = {
    inherit (s) version;
    description = "SPARQL server";
    license = lib.licenses.asl20;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
    homepage = "https://jena.apache.org";
    downloadPage = "https://archive.apache.org/dist/jena/binaries/";
    downloadURLRegexp = "apache-jena-fuseki-.*[.]tar[.]gz\$";
  };
}
