
{ stdenv, fetchurl, ncurses, mesa, freeglut, libzip, 
   ocaml, findlib, camomile, 
   dypgen, ocaml_sqlite3, camlzip, 
   lablgtk, camlimages, ocaml_cairo,
   lablgl, ocamlnet, cryptokit,
   ocaml_pcre }:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in

stdenv.mkDerivation {
  name = "patoline-0.1";

  src = fetchurl {
    url = "http://lama.univ-savoie.fr/patoline/patoline-0.1.tar.bz";
    sha256 = "c5ac8dcb87ceecaf11876bd0dd425bd0f04d43265adc2cbcb1f1e82a78846d49";
  };

  createFindlibDestdir = true;
   
   buildInputs = [ ocaml findlib dypgen camomile ocaml_sqlite3 camlzip 
   lablgtk camlimages ocaml_cairo
   lablgl ocamlnet cryptokit
   ocaml_pcre ncurses mesa freeglut libzip ];

  propagatedbuildInputs = [ camomile 
   dypgen ocaml_sqlite3 camlzip 
   lablgtk camlimages ocaml_cairo
   lablgl ocamlnet cryptokit
   ocaml_pcre ncurses mesa freeglut libzip ];

  buildPhase = ''
    ocaml configure.ml \
       --prefix $out \
       --ocaml-libs $out/lib/ocaml/${ocaml_version}/site-lib \
       --ocamlfind-dir $out/lib/ocaml/${ocaml_version}/site-lib \
       --fonts-dir $out/share/patoline/fonts \
       --grammars-dir $out/share/patoline/grammars \
       --hyphen-dir $out/share/patoline/hyphen

    make
  '';

  
  meta = {
    homepage = http://patoline.com;
    description = "Patoline ocaml based typesetting system";
  };
}
