{ stdenv, fetchurl, ocaml, findlib, ocaml_lwt, menhir, ocsigen_deriving, ppx_deriving, camlp4, ocamlbuild
, cmdliner, tyxml, reactivedata, cppo, which, base64, uchar
}:

let version = if stdenv.lib.versionAtLeast ocaml.version "4.02"
  then "2.8.3" else "2.7";
in

stdenv.mkDerivation {
  name = "js_of_ocaml-${version}";
  src = fetchurl {
    url = "https://github.com/ocsigen/js_of_ocaml/archive/${version}.tar.gz";
    sha256 = {
      "2.7" = "1dali1akyd4zmkwav0d957ynxq2jj6cc94r4xiaql7ca89ajz4jj";
      "2.8.3" = "0xrw215w5saqdcdd9ipjhvg8f982z63znsds9ih445s3jr49szm7";
    }."${version}";
  };

  buildInputs = [ ocaml findlib menhir ocsigen_deriving ocamlbuild
                 cmdliner reactivedata cppo which base64 ]
  ++ stdenv.lib.optional (stdenv.lib.versionAtLeast ocaml.version "4.02") tyxml;
  propagatedBuildInputs = [ ocaml_lwt camlp4 ppx_deriving ]
  ++ stdenv.lib.optional (version == "2.8.3") uchar;

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
