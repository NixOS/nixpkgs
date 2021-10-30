{lib, stdenv, fetchurl, java, makeWrapper}:
let
  s = # Generated upstream information
  rec {
    baseName="apache-jena-fuseki";
    version = "4.2.0";
    name="${baseName}-${version}";
    url="http://archive.apache.org/dist/jena/binaries/apache-jena-fuseki-${version}.tar.gz";
    sha256 = "1x3va4yqmxh55lhr6ms85ks9v0lqkl3y41h0bpjdycp8j96lsy3h";
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
    homepage = "http://jena.apache.org";
    downloadPage = "http://archive.apache.org/dist/jena/binaries/";
    downloadURLRegexp = "apache-jena-fuseki-.*[.]tar[.]gz\$";
  };
}
