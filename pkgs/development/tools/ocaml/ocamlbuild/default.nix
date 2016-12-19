{stdenv, fetchFromGitHub, ocaml, findlib, buildOcaml, type_conv, camlp4,
 ocamlmod, ocamlify, ounit, expect}:
let
  version = "0.9.3";
in
stdenv.mkDerivation {
  name = "ocamlbuild-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "ocamlbuild";
    rev = version;
    sha256 = "1ikm51lx4jz5vmbvrdwsm5p59bwbz3pi22vqkyz5lmqcciyn69i3";
  };

  createFindlibDestdir = true;

  buildInputs = [ ocaml findlib ];

  configurePhase = ''
  make -f configure.make Makefile.config \
    "OCAMLBUILD_PREFIX=$out" \
    "OCAMLBUILD_BINDIR=$out/bin" \
    "OCAMLBUILD_LIBDIR=$OCAMLFIND_DESTDIR"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/ocaml/ocamlbuild/;
    description = "A build system with builtin rules to easily build most OCaml projects";
    license = licenses.lgpl2;
    inherit (ocaml.meta) platforms;
    maintainers = with maintainers; [ vbgl ];
  };
}

