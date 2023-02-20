{ stdenv, fetchurl, curl, cacert }:

let
  version="0.16.1";
in stdenv.mkDerivation {
  name = "giter8";
  src = fetchurl {
    url = "https://github.com/foundweekends/giter8/archive/refs/tags/v${version}.tar.gz";
    sha256 = "sha256-5rXSKD4W0B3dOlY42Qj8U4S/jSWvGq66slXcH8sqb9c=";
  };
  buildInputs = [ curl cacert];
  buildPhase = ''
  '';
  installPhase = ''
    mkdir -p $out/bin
    curl https://repo1.maven.org/maven2/org/foundweekends/giter8/giter8-bootstrap_2.12/${version}/giter8-bootstrap_2.12-${version}.sh > $out/bin/g8
    chmod +x $out/bin/g8
  '';
  propagatedBuildInputs = [ ];
}