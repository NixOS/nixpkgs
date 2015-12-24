{stdenv, fetchurl, ocaml, findlib}:

stdenv.mkDerivation {
  name = "ocamlify-0.0.2";

  src = fetchurl {
    url = http://forge.ocamlcore.org/frs/download.php/1209/ocamlify-0.0.2.tar.gz;
    sha256 = "1f0fghvlbfryf5h3j4as7vcqrgfjb4c8abl5y0y5h069vs4kp5ii";
  };

  buildInputs = [ocaml findlib];

  configurePhase = "ocaml setup.ml -configure --prefix $out";
  buildPhase     = "ocaml setup.ml -build";
  installPhase   = "ocaml setup.ml -install";

  meta = {
    homepage = http://forge.ocamlcore.org/projects/ocamlmod/ocamlmod;
    description = "Generate OCaml modules from source files";
    platforms = ocaml.meta.platforms or [];
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [
      z77z
    ];
  };
}
