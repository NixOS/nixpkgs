{ lib, stdenv, fetchFromGitHub, ocaml, findlib }:
stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-ocamlbuild";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "ocamlbuild";
    rev = version;
    sha256 = "sha256-QAqIMdi6M9V7RIX0kppKPSkCJE/pLx2iMdh5XYXQCJs=";
  };

  createFindlibDestdir = true;

  nativeBuildInputs = [ ocaml findlib ];
  strictDeps = true;

  # x86_64-unknown-linux-musl-ld: -r and -pie may not be used together
  hardeningDisable = lib.optional stdenv.hostPlatform.isStatic "pie";

  configurePhase = ''
  runHook preConfigure

  make -f configure.make Makefile.config \
    "OCAMLBUILD_PREFIX=$out" \
    "OCAMLBUILD_BINDIR=$out/bin" \
    "OCAMLBUILD_MANDIR=$out/share/man" \
    "OCAMLBUILD_LIBDIR=$OCAMLFIND_DESTDIR"

  runHook postConfigure
  '';

  meta = with lib; {
    description = "A build system with builtin rules to easily build most OCaml projects";
    homepage = "https://github.com/ocaml/ocamlbuild/";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ vbgl ];
    mainProgram = "ocamlbuild";
    inherit (ocaml.meta) platforms;
  };
}
