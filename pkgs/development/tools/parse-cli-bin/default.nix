{ stdenv, fetchurl }:

let
  version = "3.0.1";

in stdenv.mkDerivation rec {

  name = "parse-cli-bin-${version}";

  src = fetchurl {
    url    = "https://github.com/ParsePlatform/parse-cli/releases/download/release_${version}/parse_linux";
    sha256 = "d68eccc1d9408b60901b149d2b4710f3cfd0eabe5772d2e222c06870fdeca3c7";
  };

  meta = with stdenv.lib; {
    description = "Parse Command Line Interface";
    homepage    = "https://parse.com";
    platforms   = platforms.linux;
  };

  phases = "installPhase";

  installPhase = ''
    mkdir -p "$out/bin"
    cp "$src" "$out/bin/parse"
    chmod +x "$out/bin/parse"
  '';

}
