{stdenv, fetchurl, ocaml, findlib, ocaml_data_notation, type_conv, camlp4,
 ocamlmod, ocamlify, ounit, expect}:

stdenv.mkDerivation {
  name = "ocaml-oasis-0.4.6";

  src = fetchurl {
    url = http://forge.ocamlcore.org/frs/download.php/1604/oasis-0.4.6.tar.gz;
    sha256 = "1yxv3ckkf87nz0cyll0yy1kd295j5pv3jqwkfrr1y65wkz5vw90k";
  };

  createFindlibDestdir = true;

  buildInputs =
    [
      ocaml findlib type_conv ocamlmod ocamlify ounit camlp4
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
