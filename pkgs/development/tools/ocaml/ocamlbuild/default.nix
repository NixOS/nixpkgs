{stdenv, fetchFromGitHub, ocaml, findlib, buildOcaml, type_conv, camlp4,
 ocamlmod, ocamlify, ounit, expect}:
let
  version = "0.11.0";
in
stdenv.mkDerivation {
  name = "ocamlbuild-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "ocamlbuild";
    rev = version;
    sha256 = "0c8lv15ngmrc471jmkv0jp3d573chibwnjlavps047d9hd8gwxak";
  };

  createFindlibDestdir = true;

  buildInputs = [ ocaml findlib ];

  configurePhase = ''
  make -f configure.make Makefile.config \
    "OCAMLBUILD_PREFIX=$out" \
    "OCAMLBUILD_BINDIR=$out/bin" \
    "OCAMLBUILD_MANDIR=$out/share/man" \
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
