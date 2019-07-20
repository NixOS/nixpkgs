{ stdenv, fetchurl, ocaml, findlib, opaline }:

stdenv.mkDerivation rec {
  pname = "dune";
  version = "1.11.0";
  src = fetchurl {
    url = "https://github.com/ocaml/dune/releases/download/${version}/dune-build-info-${version}.tbz";
    sha256 = "11jl2vavypbgvwblch25q10hsd16myik9b3cd4d64zhxk1fzbzdw";
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
