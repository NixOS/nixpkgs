{ stdenv, fetchFromGitHub, ocaml, findlib }:
let
  version = "0.13.0";
in
stdenv.mkDerivation {
  name = "ocamlbuild-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "ocamlbuild";
    rev = version;
    sha256 = "13r9q8c209gkgcmbjhj9z4r5bmi90rxahdsiqm5jx8sr2pia5xbh";
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
