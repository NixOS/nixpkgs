{ stdenv, fetchFromGitHub, ocaml, opam }:

stdenv.mkDerivation rec {
  name = "jbuilder-${version}";
  version = "1.0+beta18";
  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "dune";
    rev = "${version}";
    sha256 = "1xw4i5qd2ndnddzb8b14fb52qxnjpr3lr9wx3mprv4f294kdg0l6";
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
