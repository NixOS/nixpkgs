{ stdenv, fetchzip, ocaml, opam }:

stdenv.mkDerivation {
  name = "jbuilder-1.0+beta14";
  src = fetchzip {
    url = http://github.com/janestreet/jbuilder/archive/1.0+beta14.tar.gz;
    sha256 = "0vq4chqp7bm3rd5n6ry1j1ia6xqlz463059ljd1jmawa4dcyilvl";
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
