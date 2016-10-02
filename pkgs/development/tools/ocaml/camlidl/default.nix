{stdenv, fetchurl, makeWrapper, gcc, ocaml, ncurses}:

let
  pname = "camlidl";
  webpage = "http://caml.inria.fr/pub/old_caml_site/camlidl/";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "1.05";

  src = fetchurl {
    url = "http://caml.inria.fr/pub/old_caml_site/distrib/bazar-ocaml/${pname}-${version}.tar.gz";
    sha256 = "0483cs66zsxsavcllpw1qqvyhxb39ddil3h72clcd69g7fyxazl5";
  };

  buildInputs = [ ocaml ];

  preBuild = ''
    mv config/Makefile.unix config/Makefile
    substituteInPlace config/Makefile --replace BINDIR=/usr/local/bin BINDIR=$out
    substituteInPlace config/Makefile --replace OCAMLLIB=/usr/local/lib/ocaml OCAMLLIB=$out/lib/ocaml/${ocaml.version}/site-lib/camlidl
    substituteInPlace config/Makefile --replace CPP=/lib/cpp CPP=${gcc}/bin/cpp
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

  meta = {
    description = "A stub code generator and COM binding for Objective Caml";
    homepage = "${webpage}";
    license = "LGPL";
    maintainers = [ stdenv.lib.maintainers.roconnor ];
  };
}
