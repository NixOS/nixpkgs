{ stdenv, fetchurl, ocamlPackages, opaline }:

stdenv.mkDerivation rec {
  name = "dune-${version}";
  version = "1.7.3";
  src = fetchurl {
    url = "https://github.com/ocaml/dune/releases/download/${version}/dune-${version}.tbz";
    sha256 = "0g08js93qkf4b7ibrzlxs73qrdglwy4c0z5gbs6xh710ja41f6l4";
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
