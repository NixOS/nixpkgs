{ lib, stdenv, fetchurl, ocaml, writeText }:

let
  pname = "camlidl";
  webpage = "https://caml.inria.fr/pub/old_caml_site/camlidl/";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "1.05";

  src = fetchurl {
    url = "http://caml.inria.fr/pub/old_caml_site/distrib/bazar-ocaml/${pname}-${version}.tar.gz";
    sha256 = "0483cs66zsxsavcllpw1qqvyhxb39ddil3h72clcd69g7fyxazl5";
  };

  nativeBuildInputs = [ ocaml ];

  # build fails otherwise
  enableParallelBuilding = false;

  preBuild = ''
    mv config/Makefile.unix config/Makefile
    substituteInPlace config/Makefile --replace BINDIR=/usr/local/bin BINDIR=$out
    substituteInPlace config/Makefile --replace OCAMLLIB=/usr/local/lib/ocaml OCAMLLIB=$out/lib/ocaml/${ocaml.version}/site-lib/camlidl
    substituteInPlace config/Makefile --replace CPP=/lib/cpp CPP=${stdenv.cc}/bin/cpp
    substituteInPlace config/Makefile --replace "OCAMLC=ocamlc -g" "OCAMLC=ocamlc -g -warn-error -31"
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/camlidl/caml
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
    export CAML_LD_LIBRARY_PATH="''${CAML_LD_LIBRARY_PATH-}''${CAML_LD_LIBRARY_PATH:+:}''$1/lib/ocaml/${ocaml.version}/site-lib/${name}/"
    export NIX_CFLAGS_COMPILE+=" -isystem $1/lib/ocaml/${ocaml.version}/site-lib/camlidl"
    export NIX_LDFLAGS+=" -L $1/lib/ocaml/${ocaml.version}/site-lib/camlidl"
  '';

  meta = {
    description = "A stub code generator and COM binding for Objective Caml";
    homepage = webpage;
    license = "LGPL";
    maintainers = [ lib.maintainers.roconnor ];
  };
}
