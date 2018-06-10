{ stdenv, fetchFromGitHub, ocamlPackages, opaline }:

stdenv.mkDerivation rec {
  name = "jbuilder-${version}";
  version = "1.0+beta20";
  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "dune";
    rev = "${version}";
    sha256 = "0571lzm8caq6wnia7imgy4a27x5l2bvxiflg0jrwwml0ylnii65f";
  };

  buildInputs = with ocamlPackages; [ ocaml findlib ];

  dontAddPrefix = true;

  installPhase = "${opaline}/bin/opaline -prefix $out -libdir $OCAMLFIND_DESTDIR";

  preFixup = "rm -rf $out/jbuilder";

  meta = {
    homepage = https://github.com/janestreet/jbuilder;
    description = "Fast, portable and opinionated build system";
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    license = stdenv.lib.licenses.asl20;
    inherit (ocamlPackages.ocaml.meta) platforms;
  };
}
