{ stdenv, fetchurl, ocaml, findlib, opaline }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
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

  dontAddPrefix = true;

  installPhase = ''
    runHook preInstall
    ${opaline}/bin/opaline -prefix $out -libdir $OCAMLFIND_DESTDIR
    runHook postInstall
  '';

  meta = {
    homepage = "https://dune.build/";
    description = "A composable build system";
    maintainers = [ stdenv.lib.maintainers.vbgl stdenv.lib.maintainers.marsam ];
    license = stdenv.lib.licenses.mit;
    inherit (ocaml.meta) platforms;
  };
}
