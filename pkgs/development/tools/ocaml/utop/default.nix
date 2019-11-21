{ stdenv, fetchurl, ocaml, findlib, dune
, lambdaTerm, cppo, makeWrapper
}:

if !stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "utop is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "utop";
  version = "2.4.2";

  src = fetchurl {
    url = "https://github.com/ocaml-community/utop/releases/download/${version}/utop-${version}.tbz";
    sha256 = "0y2v8rkfz19nlz8gh0lkh5wx5hyvw5gl4nw1kg8j2pw9jnilq5nb";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ ocaml findlib cppo dune ];

  propagatedBuildInputs = [ lambdaTerm ];

  inherit (dune) installPhase;

  postFixup =
   let
     path = "etc/utop/env";

     # derivation of just runtime deps so env vars created by
     # setup-hooks can be saved for use at runtime
     runtime = stdenv.mkDerivation {
       pname = "utop-runtime-env";
       inherit version;

       buildInputs = [ findlib ] ++ propagatedBuildInputs;

       phases = [ "installPhase" ];

       installPhase = ''
         mkdir -p "$out"/${path}
         for e in OCAMLPATH CAML_LD_LIBRARY_PATH; do
           [[ -v "$e" ]] || continue
           printf %s "''${!e}" > "$out"/${path}/$e
         done
       '';
     };

     get = key: ''$(cat "${runtime}/${path}/${key}")'';
   in ''
   for prog in "$out"/bin/*
   do

    # Note: wrapProgram by default calls 'exec -a $0 ...', but this
    # breaks utop on Linux with OCaml 4.04, and is disabled with
    # '--argv0 ""' flag. See https://github.com/NixOS/nixpkgs/issues/24496
    wrapProgram "$prog" \
      --argv0 "" \
      --prefix CAML_LD_LIBRARY_PATH ":" "${get "CAML_LD_LIBRARY_PATH"}" \
      --prefix OCAMLPATH ":" "${get "OCAMLPATH"}" \
      --prefix OCAMLPATH ":" $(unset OCAMLPATH; addOCamlPath "$out"; printf %s "$OCAMLPATH") \
      --add-flags "-I ${findlib}/lib/ocaml/${stdenv.lib.getVersion ocaml}/site-lib"
   done
   '';

  meta = {
    description = "Universal toplevel for OCaml";
    longDescription = ''
    utop is an improved toplevel for OCaml. It can run in a terminal or in Emacs. It supports line edition, history, real-time and context sensitive completion, colors, and more.

    It integrates with the tuareg mode in Emacs.
    '';
    homepage = https://github.com/diml/utop;
    license = stdenv.lib.licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.gal_bolle
    ];
  };
}
