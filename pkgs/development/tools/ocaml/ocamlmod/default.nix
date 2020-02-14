{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, ounit }:

stdenv.mkDerivation {
  pname = "ocamlmod";
  version = "0.0.9";

  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/1702/ocamlmod-0.0.9.tar.gz";
    sha256 = "0cgp9qqrq7ayyhddrmqmq1affvfqcn722qiakjq4dkywvp67h4aa";
  };

  buildInputs = [ ocaml findlib ocamlbuild ounit ];

  configurePhase = "ocaml setup.ml -configure --prefix $out --enable-tests";
  buildPhase     = "ocaml setup.ml -build";
  installPhase   = "ocaml setup.ml -install";

  doCheck = true;

  checkPhase = "ocaml setup.ml -test";

  dontStrip = true;

  meta = {
    homepage = http://forge.ocamlcore.org/projects/ocamlmod/ocamlmod;
    description = "Generate OCaml modules from source files";
    platforms = ocaml.meta.platforms or [];
    maintainers = with stdenv.lib.maintainers; [
      maggesi
    ];
  };
}
