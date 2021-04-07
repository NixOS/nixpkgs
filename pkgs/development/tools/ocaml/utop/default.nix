{ lib, stdenv, fetchurl, ocaml, findlib
, lambdaTerm, cppo, makeWrapper, buildDunePackage
}:

if !lib.versionAtLeast ocaml.version "4.03"
then throw "utop is not available for OCaml ${ocaml.version}"
else

buildDunePackage rec {
  pname = "utop";
  version = "2.7.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/ocaml-community/utop/releases/download/${version}/utop-${version}.tbz";
    sha256 = "sha256-4GisU98mfDzA8vabvCBEBPA2LMTmRyofxUfjJqY8P90=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ cppo ];

  propagatedBuildInputs = [ lambdaTerm ];

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
      --add-flags "-I ${findlib}/lib/ocaml/${lib.getVersion ocaml}/site-lib"
   done
   '';

  meta = {
    description = "Universal toplevel for OCaml";
    longDescription = ''
    utop is an improved toplevel for OCaml. It can run in a terminal or in Emacs. It supports line edition, history, real-time and context sensitive completion, colors, and more.

    It integrates with the tuareg mode in Emacs.
    '';
    homepage = "https://github.com/diml/utop";
    license = lib.licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      lib.maintainers.gal_bolle
    ];
  };
}
