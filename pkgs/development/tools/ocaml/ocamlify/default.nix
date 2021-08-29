{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild }:

stdenv.mkDerivation {
  name = "ocamlify-0.0.2";

  src = fetchurl {
    url = "http://forge.ocamlcore.org/frs/download.php/1209/ocamlify-0.0.2.tar.gz";
    sha256 = "1f0fghvlbfryf5h3j4as7vcqrgfjb4c8abl5y0y5h069vs4kp5ii";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];

  configurePhase = ''
    substituteInPlace src/ocamlify.ml --replace 'OCamlifyConfig.version' '"0.0.2"'
  '';

  buildPhase = "ocamlbuild src/ocamlify.native";

  installPhase = ''
    mkdir -p $out/bin
    mv _build/src/ocamlify.native $out/bin/ocamlify
  '';

  dontStrip = true;

  meta = {
    homepage = "https://forge.ocamlcore.org/projects/ocamlmod/ocamlmod";
    description = "Generate OCaml modules from source files";
    platforms = ocaml.meta.platforms or [];
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [
      maggesi
    ];
  };
}
