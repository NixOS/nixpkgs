{ stdenv, fetchurl, ocamlPackages, opaline }:

stdenv.mkDerivation rec {
  name = "dune-${version}";
  version = "1.3.0";
  src = fetchurl {
    url = "https://github.com/ocaml/dune/releases/download/${version}/dune-${version}.tbz";
    sha256 = "15bzakiclipsyjgcfrj83xdpwwww3aaijyw01bn5cx96cmcqyjad";
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
