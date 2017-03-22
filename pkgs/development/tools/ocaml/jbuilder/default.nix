{ stdenv, fetchzip, ocaml, opam }:

stdenv.mkDerivation {
  name = "jbuilder-1.0+beta5";
  src = fetchzip {
    url = http://github.com/janestreet/jbuilder/archive/1.0+beta5.tar.gz;
    sha256 = "00kh83n3216g1n7rhh14mcmw9bj5vzq7kiixm1abrc09dhwh4m7a";
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
