{lib, stdenv, fetchurl, java, makeWrapper}:
let
  s = # Generated upstream information
  rec {
    baseName="apache-jena";
    version = "4.2.0";
    name="${baseName}-${version}";
    url="http://archive.apache.org/dist/jena/binaries/apache-jena-${version}.tar.gz";
    sha256 = "1yiqlsp1g2fladal8mj164b9s0qsl5csllg54p7x7w63wf7gixnq";
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
    description = "RDF database";
    license = lib.licenses.asl20;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
    homepage = "http://jena.apache.org";
    downloadPage = "http://archive.apache.org/dist/jena/binaries/";
    updateWalker = true;
    downloadURLRegexp = "apache-jena-.*[.]tar[.]gz\$";
  };
}
