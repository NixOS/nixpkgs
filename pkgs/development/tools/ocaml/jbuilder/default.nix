{ stdenv, fetchFromGitHub, ocaml, opam }:

stdenv.mkDerivation rec {
  name = "jbuilder-${version}";
  version = "1.0+beta17";
  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "dune";
    rev = "${version}";
    sha256 = "04pyry459hp2r2s9m5xkcq1glzp20ddz5wb1w8nzp3zgygy0431x";
  };

  buildInputs = [ ocaml ];

  installPhase = "${opam}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR";

  preFixup = "rm -rf $out/jbuilder";

  meta = {
    homepage = https://github.com/janestreet/jbuilder;
    description = "Fast, portable and opinionated build system";
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
