{stdenv, fetchurl, ocaml, findlib, ocaml_data_notation, type_conv, camlp4,
 ocamlmod, ocamlify, ounit, expect}:

stdenv.mkDerivation {
  name = "ocaml-oasis-0.4.5";

  src = fetchurl {
    url = http://forge.ocamlcore.org/frs/download.php/1475/oasis-0.4.5.tar.gz;
    sha256 = "0i1fifzig2slhb07d1djx6i690b8ys0avsx6ssnihisw841sc8v6";
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
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    maintainers = with maintainers; [
      vbgl z77z
    ];
  };
}
