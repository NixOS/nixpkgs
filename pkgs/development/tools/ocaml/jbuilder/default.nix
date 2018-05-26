{ stdenv, fetchFromGitHub, ocaml, opam }:

stdenv.mkDerivation rec {
  name = "jbuilder-${version}";
  version = "1.0+beta20";
  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "dune";
    rev = "${version}";
    sha256 = "0571lzm8caq6wnia7imgy4a27x5l2bvxiflg0jrwwml0ylnii65f";
  };

  buildInputs = [ ocaml ];

  dontAddPrefix = true;

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
