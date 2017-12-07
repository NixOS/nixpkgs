{ stdenv, fetchurl, bash, ocaml, findlib, ocamlbuild, camlp4, ocaml_react
, lambdaTerm, ocaml_lwt, camomile, zed, cppo, ppx_tools, makeWrapper
}:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "utop is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "1.19.3";
  name = "utop-${version}";

  src = fetchurl {
    url = "https://github.com/diml/utop/archive/${version}.tar.gz";
    sha256 = "16z02vp9n97iax4fqpbi7v86r75vbabxvnd1rirh8w2miixs1g4x";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ ocaml findlib ocamlbuild cppo camlp4 ppx_tools ];

  propagatedBuildInputs = [ lambdaTerm ocaml_lwt ];

  createFindlibDestdir = true;

  configureFlags = [ "--enable-camlp4" ]
  ++ stdenv.lib.optional (ppx_tools != null && !stdenv.lib.versionAtLeast ocaml.version "4.04") "--enable-interact";

  buildPhase = ''
    make
    make doc
    '';

  dontStrip = true;

  postFixup =
   let
     path = "etc/utop/env";

     # derivation of just runtime deps so env vars created by
     # setup-hooks can be saved for use at runtime
     runtime = stdenv.mkDerivation rec {
       name = "utop-runtime-env-${version}";

       buildInputs = [ findlib ] ++ propagatedBuildInputs;

       phases = [ "installPhase" ];

       installPhase = ''
         mkdir -p "$out"/${path}
         for e in OCAMLPATH CAML_LD_LIBRARY_PATH; do
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
