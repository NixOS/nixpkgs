{ stdenv, fetchurl, ocamlPackages, opaline }:

stdenv.mkDerivation rec {
  name = "dune-${version}";
  version = "1.4.0";
  src = fetchurl {
    url = "https://github.com/ocaml/dune/releases/download/${version}/dune-${version}.tbz";
    sha256 = "1fz1jx1d48yb40qan4hw25h8ia55vs7mp94a3rr7cf5gb5ap2zkj";
  };

  buildInputs = with ocamlPackages; [ ocaml findlib ];

  buildFlags = "release";

  dontAddPrefix = true;

  installPhase = "${opaline}/bin/opaline -prefix $out -libdir $OCAMLFIND_DESTDIR";

  meta = {
    homepage = "https://github.com/ocaml/dune";
    description = "A composable build system";
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    license = stdenv.lib.licenses.mit;
    inherit (ocamlPackages.ocaml.meta) platforms;
  };
}
