{ stdenv, fetchFromGitHub, ocamlPackages, opaline }:

stdenv.mkDerivation rec {
  name = "jbuilder-${version}";
  version = "1.0.1";
  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "dune";
    rev = "${version}";
    sha256 = "0k6r9qrbwlnb4rqwqys5fr7khwza7n7d8wpgl9jbb3xpag2zl3q9";
  };

  buildInputs = with ocamlPackages; [ ocaml findlib ];

  dontAddPrefix = true;

  installPhase = "${opaline}/bin/opaline -prefix $out -libdir $OCAMLFIND_DESTDIR";

  preFixup = "rm -rf $out/jbuilder";

  meta = {
    inherit (src.meta) homepage;
    description = "Fast, portable and opinionated build system";
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    license = stdenv.lib.licenses.asl20;
    inherit (ocamlPackages.ocaml.meta) platforms;
  };
}
