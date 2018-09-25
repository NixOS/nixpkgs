{ stdenv, fetchFromGitHub, ocamlPackages, opaline }:

stdenv.mkDerivation rec {
  name = "dune-${version}";
  version = "1.2.1";
  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "dune";
    rev = "${version}";
    sha256 = "14m5zg1b6d0y03c5qsmqmwiwz2h0iys02rlgn6kzm519ck679bkq";
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
