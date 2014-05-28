{stdenv, fetchurl, ocaml, findlib, ocaml_lwt, menhir, ocsigen_deriving}:

stdenv.mkDerivation {
  name = "js_of_ocaml";
  src = fetchurl {
    url = https://github.com/ocsigen/js_of_ocaml/archive/2.2.tar.gz;
    sha256 = "1cp81gpvyxgvzxg0vzyl8aa2zvcixp6m433w8zjifrg6vb7lhp97";
    };
  
  buildInputs = [ocaml findlib ocaml_lwt menhir ocsigen_deriving];

  patches = [ ./Makefile.conf.diff ];  

  createFindlibDestdir = true;


  meta =  {
    homepage = http://ocsigen.org/js_of_ocaml/;
    description = "Compiler of OCaml bytecode to Javascript. It makes it possible to run Ocaml programs in a Web browser";
    license = "LGPL";
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.gal_bolle
    ];
  };


}
