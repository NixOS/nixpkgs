{stdenv, fetchurl, ocaml, findlib}:

stdenv.mkDerivation {
  name = "ocamlmod-0.0.7";

  src = fetchurl {
    url = http://forge.ocamlcore.org/frs/download.php/1350/ocamlmod-0.0.7.tar.gz;
    sha256 = "11kg7wh0gy492ma5c6bcjh6frv1a9lh9f26hiys2i0d1ky8s0ad3";
  };

  buildInputs = [ocaml findlib];

  configurePhase = "ocaml setup.ml -configure --prefix $out";
  buildPhase     = "ocaml setup.ml -build";
  installPhase   = "ocaml setup.ml -install";

  meta = {
    homepage = http://forge.ocamlcore.org/projects/ocamlmod/ocamlmod;
    description = "Generate OCaml modules from source files";
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    maintainers = with stdenv.lib.maintainers; [
      z77z
    ];
  };
}
