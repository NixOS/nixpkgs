{stdenv, fetchurl, ocaml, findlib, ocaml_lwt, menhir, ocsigen_deriving, camlp4,
 cmdliner, tyxml, reactivedata, cppo, which, base64}:

let camlp4_patch = fetchurl {
    url = "https://github.com/FlorentBecker/js_of_ocaml/commit/3b511c5bb777d5049c49d7a04c01f142de7096b9.patch";
    sha256 = "c92eda8be504cd41eb242166fc815af496243b63d4d21b169f5b62ec5ace2d39";
    };
in
 
stdenv.mkDerivation {
  name = "js_of_ocaml-2.6";
  src = fetchurl {
    url = https://github.com/ocsigen/js_of_ocaml/archive/2.6.tar.gz;
    sha256 = "0q34lrn70dvz41m78bwgriyq6dxk97g8gcyg80nvxii4jp86dw61";
    };

  buildInputs = [ocaml findlib menhir ocsigen_deriving
                 cmdliner tyxml reactivedata cppo which base64];
  propagatedBuildInputs = [ ocaml_lwt camlp4 ];

  patches = [ ./Makefile.conf.diff camlp4_patch ];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = http://ocsigen.org/js_of_ocaml/;
    description = "Compiler of OCaml bytecode to Javascript. It makes it possible to run Ocaml programs in a Web browser";
    license = licenses.lgpl2;
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    maintainers = [
      maintainers.gal_bolle
    ];
  };
}
