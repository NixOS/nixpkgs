{ stdenv, fetchFromGitHub, ocaml, findlib }:
let
  version = "0.12.0";
in
stdenv.mkDerivation {
  name = "ocamlbuild-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "ocamlbuild";
    rev = version;
    sha256 = "1shyim50ms0816fphc4mk0kldcx3pnba2i6m10q0cbm18m9d7chq";
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
