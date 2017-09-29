{ stdenv, fetchzip, ocaml, opam }:

stdenv.mkDerivation {
  name = "jbuilder-1.0+beta12";
  src = fetchzip {
    url = http://github.com/janestreet/jbuilder/archive/1.0+beta12.tar.gz;
    sha256 = "1gqpp1spcya9951mw2kcavam8v0m5s6zc5pjb7bkv5d71si04rlf";
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
