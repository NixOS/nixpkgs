{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "parse-cli-bin-${version}";
  version = "3.0.5";

  src = fetchurl {
    url = "https://github.com/ParsePlatform/parse-cli/releases/download/release_${version}/parse_linux";
    sha256 = "1iyfizbbxmr87wjgqiwqds51irgw6l3vm9wn89pc3zpj2zkyvf5h";
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