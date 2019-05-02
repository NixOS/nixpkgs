{ stdenv, fetchurl, ocaml, findlib, opaline }:

stdenv.mkDerivation rec {
  name = "dune-${version}";
  version = "1.9.1";
  src = fetchurl {
    url = "https://github.com/ocaml/dune/releases/download/${version}/dune-${version}.tbz";
    sha256 = "0z4jnj0a5vxjqlwksplhag9b3s3iqdcpcpjjzfazv5jdl5cf58f9";
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
    homepage = https://github.com/ocaml/dune;
    description = "A composable build system";
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    license = stdenv.lib.licenses.mit;
    inherit (ocaml.meta) platforms;
  };
}
