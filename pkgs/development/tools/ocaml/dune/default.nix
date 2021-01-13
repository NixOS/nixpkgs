{ stdenv, lib, fetchurl, ocaml, findlib }:

if !lib.versionAtLeast ocaml.version "4.02"
then throw "dune is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "dune";
  version = "1.11.4";
  src = fetchurl {
    url = "https://github.com/ocaml/dune/releases/download/${version}/dune-build-info-${version}.tbz";
    sha256 = "1rkc8lqw30ifjaz8d81la6i8j05ffd0whpxqsbg6dci16945zjvp";
  };

  buildInputs = [ ocaml findlib ];

  buildFlags = [ "release" ];
  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "LIBDIR=$(OCAMLFIND_DESTDIR)"
  ];

  dontAddPrefix = true;

  meta = with lib; {
    homepage = "https://dune.build/";
    description = "A composable build system";
    maintainers = [ maintainers.vbgl maintainers.marsam ];
    license = licenses.mit;
    inherit (ocaml.meta) platforms;
  };
}
