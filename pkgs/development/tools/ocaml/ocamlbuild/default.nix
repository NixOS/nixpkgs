{stdenv, fetchFromGitHub, ocaml, findlib, buildOcaml, type_conv, camlp4,
 ocamlmod, ocamlify, ounit, expect}:
let
  version = "0.9.2";
in
stdenv.mkDerivation {
  name = "ocamlbuild";
  inherit version;

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "ocamlbuild";
    rev = version;
    sha256 = "0q4bvik08v444g1pill9zgwal48xs50jf424lbryfvqghhw5xjjc";
  };

  createFindlibDestdir = true;

  buildInputs = [ ocaml findlib ];

  configurePhase = ''
  make -f configure.make Makefile.config \
    "OCAMLBUILD_PREFIX=$out" \
    "OCAMLBUILD_BINDIR=$out/bin" \
    "OCAMLBUILD_LIBDIR=$OCAMLFIND_DESTDIR"
  '';

  # configurePhase = "ocaml setup.ml -configure --prefix $out";
  # buildPhase     = "ocaml setup.ml -build";
  # installPhase   = "ocaml setup.ml -install";

  # meta = with stdenv.lib; {
  #   homepage = http://oasis.forge.ocamlcore.org/;
  #   description = "Configure, build and install system for OCaml projects";
  #   license = licenses.lgpl21;
  #   platforms = ocaml.meta.platforms or [];
  #   maintainers = with maintainers; [
  #     vbgl z77z
  #   ];
  # };
}

