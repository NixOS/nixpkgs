{stdenv, fetchurl, ocaml, findlib, ocaml_data_notation, ocaml_typeconv,
 ocamlmod, ocamlify, ounit, expect}:

stdenv.mkDerivation {
  name = "ocaml-oasis-0.4.4";

  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/1391/oasis-0.4.4.tar.gz;
    sha256 = "0vsjpjsavxrc60xsnwl08wkxwlr10bpzn4hbrjpn7z628airpach";
  };

  createFindlibDestdir = true;

  buildInputs =
    [
      ocaml findlib ocaml_typeconv ocamlmod ocamlify ounit
    ];

  propagatedBuildInputs = [ ocaml_data_notation ];

  configurePhase = "ocaml setup.ml -configure --prefix $out";
  buildPhase     = "ocaml setup.ml -build";
  installPhase   = "ocaml setup.ml -install";

  meta = {
    homepage = http://oasis.forge.ocamlcore.org/;
    description = "Configure, build and install system for OCaml projects";
    license = stdenv.lib.licenses.lgpl21;
    platforms = ocaml.meta.platforms;
    maintainers = with stdenv.lib.maintainers; [
      z77z
    ];
  };
}
