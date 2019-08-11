{ stdenv, fetchurl, ocaml, findlib, opaline }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "dune is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "dune";
  version = "1.11.1";
  src = fetchurl {
    url = "https://github.com/ocaml/dune/releases/download/${version}/dune-build-info-${version}.tbz";
    sha256 = "0hizfaidl1bxl614i65yvyfhsjbp93y7y9qy1a8zw448w1js5bsp";
  };

  buildInputs = [ ocaml findlib ];

  buildFlags = "release";

  dontAddPrefix = true;

  installPhase = ''
    runHook preInstall
    ${opaline}/bin/opaline -prefix $out -libdir $OCAMLFIND_DESTDIR
    runHook postInstall
  '';

  meta = {
    homepage = "https://dune.build/";
    description = "A composable build system";
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    license = stdenv.lib.licenses.mit;
    inherit (ocaml.meta) platforms;
  };
}
