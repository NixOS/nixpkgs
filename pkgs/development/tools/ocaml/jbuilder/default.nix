{ stdenv, fetchFromGitHub, ocamlPackages, opaline }:

stdenv.mkDerivation rec {
  name = "jbuilder-${version}";
  version = "1.5.1";
  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "dune";
    rev = "${version}";
    sha256 = "abc45a0b5c49795d564bf3b201a224a3c416021bde8e4c051dff011ad2db89eb";
  };

  buildInputs = with ocamlPackages; [ ocaml findlib ];

  dontAddPrefix = true;

  installPhase = "${opaline}/bin/opaline -prefix $out -libdir $OCAMLFIND_DESTDIR";

  preFixup = "rm -rf $out/jbuilder";

  meta = {
    inherit (src.meta) homepage;
    description = "Fast, portable and opinionated build system";
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    license = stdenv.lib.licenses.asl20;
    inherit (ocamlPackages.ocaml.meta) platforms;
  };
}
