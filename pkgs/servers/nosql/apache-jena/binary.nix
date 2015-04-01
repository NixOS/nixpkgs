{stdenv, fetchurl, java, makeWrapper}:
let
  s = # Generated upstream information
  rec {
    baseName="apache-jena";
    version = "2.13.0";
    name="${baseName}-${version}";
    url="http://archive.apache.org/dist/jena/binaries/apache-jena-${version}.tar.gz";
    sha256 = "0fb5f2rv7rgi60r4b80r1wzap1rngmajv378mdkcyhm7bj4ba31d";
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
    downloadURLRegex = "apache-jena-.*[.]tar[.]gz\$";
  };
}
