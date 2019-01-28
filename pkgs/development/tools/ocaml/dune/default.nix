{ stdenv, fetchurl, ocamlPackages, opaline }:

stdenv.mkDerivation rec {
  name = "dune-${version}";
  version = "1.6.3";
  src = fetchurl {
    url = "https://github.com/ocaml/dune/releases/download/${version}/dune-${version}.tbz";
    sha256 = "0dmf0wbfmgdy5plz1bjiisc2hjgblvxsnrqjmw2c8y45v1h23mdz";
  };

  buildInputs = with ocamlPackages; [ ocaml findlib ];

  buildFlags = "release";

  dontAddPrefix = true;

  installPhase = ''
    runHook preInstall
    ${opaline}/bin/opaline -prefix $out -libdir $OCAMLFIND_DESTDIR
    runHook postInstall
  '';

  meta = {
    homepage = https://github.com/ocaml/dune;
    description = "A composable build system";
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    license = stdenv.lib.licenses.mit;
    inherit (ocamlPackages.ocaml.meta) platforms;
  };
}
