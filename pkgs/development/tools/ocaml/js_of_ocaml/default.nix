{stdenv, fetchurl, ocaml, findlib, ocaml_lwt, menhir, ocsigen_deriving, camlp4,
 cmdliner, tyxml, reactivedata, cppo, which, base64}:

stdenv.mkDerivation {
  name = "js_of_ocaml-2.7";
  src = fetchurl {
    url = https://github.com/ocsigen/js_of_ocaml/archive/2.7.tar.gz;
    sha256 = "1dali1akyd4zmkwav0d957ynxq2jj6cc94r4xiaql7ca89ajz4jj";
    };

  buildInputs = [ocaml findlib menhir ocsigen_deriving
                 cmdliner tyxml reactivedata cppo which base64];
  propagatedBuildInputs = [ ocaml_lwt camlp4 ];

  patches = [ ./Makefile.conf.diff ];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = http://ocsigen.org/js_of_ocaml/;
    description = "Compiler of OCaml bytecode to Javascript. It makes it possible to run Ocaml programs in a Web browser";
    license = licenses.lgpl2;
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      maintainers.gal_bolle
    ];
  };
}
