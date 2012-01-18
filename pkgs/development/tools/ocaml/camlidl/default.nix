{stdenv, fetchurl, makeWrapper, ocaml, ncurses}:
let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  pname = "camlidl";
  version = "1.05";
  webpage = "http://caml.inria.fr/pub/old_caml_site/camlidl/";
in
stdenv.mkDerivation {

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://caml.inria.fr/pub/old_caml_site/distrib/bazar-ocaml/${pname}-${version}.tar.gz";
    sha256 = "0483cs66zsxsavcllpw1qqvyhxb39ddil3h72clcd69g7fyxazl5";
  };

  buildInputs = [ ocaml ];

  preBuild = ''
    mv config/Makefile.unix config/Makefile
    substituteInPlace config/Makefile --replace BINDIR=/usr/local/bin BINDIR=$out
    substituteInPlace config/Makefile --replace OCAMLLIB=/usr/local/lib/ocaml OCAMLLIB=$out/lib/ocaml/${ocaml_version}/site-lib/camlidl
    mkdir -p $out/lib/ocaml/${ocaml_version}/site-lib/camlidl/caml
  '';

  meta = {
    description = "CamlIDL is a stub code generator and COM binding for Objective Caml";
    homepage = "${webpage}";
    license = "LGPL";
    maintainers = [ stdenv.lib.maintainers.roconnor ];
  };
}
