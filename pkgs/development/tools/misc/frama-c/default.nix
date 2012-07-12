{ stdenv, fetchurl, ocamlPackages }:

let

  version = "20111001";
  sha256 = "8afad848321c958fab265045cd152482e77ce7c175ee7c9af2d4bec57a1bc671";

in stdenv.mkDerivation {
  name = "frama-c-${version}";

  src = fetchurl {
    url = "http://frama-c.com/download/frama-c-Nitrogen-${version}.tar.gz";
    inherit sha256;
  };

  buildInputs = with ocamlPackages; [
    ocaml findlib
  ];

  meta = {
    description = "Frama-C is an extensible tool for source-code analysis of C software";

    homepage = http://frama-c.com/;
    license = "GPLv2";

    maintainers = [ stdenv.lib.maintainers.amiddelk ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
