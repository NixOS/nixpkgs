{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, camlp4
, ocaml_data_notation, type_conv, ocamlmod, ocamlify, ounit, expect
}:

stdenv.mkDerivation rec {
  version = "0.4.10";
  name = "ocaml-oasis-${version}";

  # You must manually update the url, not just the version. OCamlforge keys off
  # the number after download.php, not the filename.
  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/1694/oasis-0.4.10.tar.gz;
    sha256 = "13ah03pbcvrjv5lmx971hvkm9rvbvimska5wmjfvgvd20ca0gn8w";
  };

  createFindlibDestdir = true;

  buildInputs =
    [
      ocaml findlib ocamlbuild type_conv ocamlmod ocamlify ounit camlp4
    ];

  propagatedBuildInputs = [ ocaml_data_notation ];

  configurePhase = "ocaml setup.ml -configure --prefix $out";
  buildPhase     = "ocaml setup.ml -build";
  installPhase   = "ocaml setup.ml -install";

  meta = with stdenv.lib; {
    homepage = http://oasis.forge.ocamlcore.org/;
    description = "Configure, build and install system for OCaml projects";
    license = licenses.lgpl21;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [
      vbgl z77z
    ];
  };
}
