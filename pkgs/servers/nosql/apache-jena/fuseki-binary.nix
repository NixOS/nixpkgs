{stdenv, fetchurl, java, makeWrapper}:
let
  s = # Generated upstream information
  rec {
    baseName="apache-jena-fuseki";
    version = "2.4.1";
    name="${baseName}-${version}";
    url="http://archive.apache.org/dist/jena/binaries/apache-jena-fuseki-${version}.tar.gz";
    sha256 = "01yjpghgz637wwgnk5n9d7kchc3mmrbyrm8fs4rh2hkh66mq3ya4";
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
    ln -s "$out"/{fuseki-server,fuseki} "$out/bin"
    for i in "$out"/bin/*; do
      wrapProgram "$i" \
        --prefix "PATH" : "${java}/bin/" \
        --set "FUSEKI_HOME" '"''${FUSEKI_HOME:-'"$out"'}"' \
        ;
    done
  '';
  meta = {
    inherit (s) version;
    description = ''SPARQL server'';
    license = stdenv.lib.licenses.asl20;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "http://jena.apache.org";
    downloadPage = "http://archive.apache.org/dist/jena/binaries/";
    downloadURLRegexp = "apache-jena-fuseki-.*[.]tar[.]gz\$";
  };
}
