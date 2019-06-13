{ stdenv, fetchFromGitHub, ocaml, findlib }:
let
  version = "0.14.0";
in
stdenv.mkDerivation {
  name = "ocamlbuild-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "ocamlbuild";
    rev = version;
    sha256 = "1hb5mcdz4wv7sh1pj7dq9q4fgz5h3zg7frpiya6s8zd3ypwzq0kh";
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
