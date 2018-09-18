{ stdenv, fetchFromGitHub, ocamlPackages, opaline }:

stdenv.mkDerivation rec {
  name = "dune-${version}";
  version = "1.1.1";
  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "dune";
    rev = "${version}";
    sha256 = "0v2pnxpmqsvrvidpwxvbsypzhqfdnjs5crjp9y61qi8nyj8d75zw";
  };

  buildInputs = with ocamlPackages; [ ocaml findlib ];

  dontAddPrefix = true;

  installPhase = "${opaline}/bin/opaline -prefix $out -libdir $OCAMLFIND_DESTDIR";

  meta = {
    inherit (src.meta) homepage;
    description = "Fast, portable and opinionated build system";
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    license = stdenv.lib.licenses.asl20;
    inherit (ocamlPackages.ocaml.meta) platforms;
  };
}
