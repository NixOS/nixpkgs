{ stdenv, fetchzip, ocaml, opam }:

stdenv.mkDerivation {
  name = "jbuilder-1.0+beta2";
  src = fetchzip {
    url = http://github.com/janestreet/jbuilder/archive/1.0+beta2.tar.gz;
    sha256 = "0xbq6p0n4a740l3jvq4a0a58mwfcal0q37vi8ix053f3jiqki6ng";
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
