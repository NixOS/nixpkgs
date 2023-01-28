{ lib, stdenv, fetchFromGitHub, ocaml, writeText }:

lib.throwIfNot (lib.versionAtLeast ocaml.version "4.03")
  "camlidl is not available for OCaml ${ocaml.version}"

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-camlidl";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "xavierleroy";
    repo = "camlidl";
    rev = "camlidl111";
    sha256 = "sha256-8m0zem/6nvpEJtjJNP/+vafeVLlMvNQGdl8lyf/OeBg=";
  };

  nativeBuildInputs = [ ocaml ];

  # build fails otherwise
  enableParallelBuilding = false;

  preBuild = ''
    mv config/Makefile.unix config/Makefile
    substituteInPlace config/Makefile --replace BINDIR=/usr/local/bin BINDIR=$out
    substituteInPlace config/Makefile --replace 'OCAMLLIB=$(shell $(OCAMLC) -where)' OCAMLLIB=$out/lib/ocaml/${ocaml.version}/site-lib/camlidl
    substituteInPlace config/Makefile --replace CPP=cpp CPP=${stdenv.cc}/bin/cpp
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/camlidl/caml
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/camlidl/stublibs
  '';

  postInstall = ''
    cat >$out/lib/ocaml/${ocaml.version}/site-lib/camlidl/META <<EOF
    # Courtesy of GODI
    description = "Stub generator"
    version = "${version}"
    archive(byte) = "com.cma"
    archive(native) = "com.cmxa"
    EOF
    mkdir -p $out/bin
    ln -s $out/camlidl $out/bin
  '';

  setupHook = writeText "setupHook.sh" ''
    export NIX_CFLAGS_COMPILE+=" -isystem $1/lib/ocaml/${ocaml.version}/site-lib/camlidl"
    export NIX_LDFLAGS+=" -L $1/lib/ocaml/${ocaml.version}/site-lib/camlidl"
  '';

  meta = {
    description = "A stub code generator and COM binding for Objective Caml";
    homepage = "https://xavierleroy.org/camlidl/";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.roconnor ];
  };
}
