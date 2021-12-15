{lib, stdenv, fetchurl, java, makeWrapper}:
let
  s = # Generated upstream information
  rec {
    baseName="apache-jena";
    version = "4.3.1";
    name="${baseName}-${version}";
    url="https://dlcdn.apache.org/jena/binaries/apache-jena-${version}.tar.gz";
    sha256 = "02asp88smayn68hc019fwp0si9mc79vxn8py7qhx3qzwjk6j9p71";
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
