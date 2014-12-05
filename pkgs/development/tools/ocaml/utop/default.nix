{stdenv, fetchurl, ocaml, findlib, lambdaTerm, ocaml_lwt, makeWrapper,
 ocaml_react, camomile, zed
}:

stdenv.mkDerivation rec {
  version = "1.15";
  name = "utop-${version}";

  src = fetchurl {
    url = https://github.com/diml/utop/archive/1.15.tar.gz;
    sha256 = "106v0x6sa2x10zgmjf73mpzws7xiqanxswivd00iqnpc0bcpkmrr";
  };

  buildInputs = [ ocaml findlib makeWrapper];

  propagatedBuildInputs = [ lambdaTerm ocaml_lwt ];

  createFindlibDestdir = true;

  buildPhase = ''
    make
    make doc
    '';

  postFixup =
  let ocamlVersion = (builtins.parseDrvName (ocaml.name)).version;
  in
   ''
    wrapProgram "$out"/bin/utop --set CAML_LD_LIBRARY_PATH "${ocaml_lwt}"/lib/ocaml/${ocamlVersion}/site-lib/lwt/:"${lambdaTerm}"/lib/ocaml/${ocamlVersion}/site-lib/lambda-term/:'$CAML_LD_LIBRARY_PATH' --set OCAMLPATH "${ocaml_lwt}"/lib/ocaml/${ocamlVersion}/site-lib:${ocaml_react}/lib/ocaml/${ocamlVersion}/site-lib:${camomile}/lib/ocaml/${ocamlVersion}/site-lib:${zed}/lib/ocaml/${ocamlVersion}/site-lib:${lambdaTerm}/lib/ocaml/${ocamlVersion}/site-lib:"$out"/lib/ocaml/${ocamlVersion}/site-lib:'$OCAMLPATH'
    '';

  meta = {
    description = "Universal toplevel for OCaml";
    longDescription = ''
    utop is an improved toplevel for OCaml. It can run in a terminal or in Emacs. It supports line edition, history, real-time and context sensitive completion, colors, and more.

    It integrates with the tuareg mode in Emacs.
    '';
    homepage = https://github.com/diml/utop;
    license = stdenv.lib.licenses.bsd3;
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.gal_bolle
    ];
  };
}
