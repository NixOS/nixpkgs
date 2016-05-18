{stdenv, fetchurl, java, makeWrapper}:
let
  s = # Generated upstream information
  rec {
    baseName="apache-jena";
    version = "3.1.0";
    name="${baseName}-${version}";
    url="http://archive.apache.org/dist/jena/binaries/apache-jena-${version}.tar.gz";
    sha256 = "1nfb567v9s17j31l75v5gkdalmkrqba7ahz3z8gzz4kpmdzdhajk";
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
    for i in "$out"/bin/*; do
      wrapProgram "$i" --prefix "PATH" : "${java}/bin/"
    done
  '';
  meta = {
    inherit (s) version;
    description = ''RDF database'';
    license = stdenv.lib.licenses.asl20;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "http://jena.apache.org";
    downloadPage = "http://archive.apache.org/dist/jena/binaries/";
    updateWalker = true;
    downloadURLRegexp = "apache-jena-.*[.]tar[.]gz\$";
  };
}
