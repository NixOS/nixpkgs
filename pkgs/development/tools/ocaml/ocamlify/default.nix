{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild }:

lib.throwIf (lib.versionAtLeast ocaml.version "5.0")
  "ocamlify is not available for OCaml ${ocaml.version}"

stdenv.mkDerivation rec {
  pname = "ocamlify";
  version = "0.0.2";

  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/1209/${pname}-${version}.tar.gz";
    sha256 = "1f0fghvlbfryf5h3j4as7vcqrgfjb4c8abl5y0y5h069vs4kp5ii";
  };

  strictDeps = true;

  nativeBuildInputs = [ ocaml findlib ocamlbuild ];

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
