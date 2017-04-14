{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, camlp4, ocaml_react
, lambdaTerm, ocaml_lwt, makeWrapper, camomile, zed, cppo, ppx_tools
}:

stdenv.mkDerivation rec {
  version = "1.19.3";
  name = "utop-${version}";

  src = fetchurl {
    url = "https://github.com/diml/utop/archive/${version}.tar.gz";
    sha256 = "16z02vp9n97iax4fqpbi7v86r75vbabxvnd1rirh8w2miixs1g4x";
  };

  buildInputs = [ ocaml findlib ocamlbuild makeWrapper cppo camlp4 ppx_tools ];

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
   let p = p: "${p}/lib/ocaml/${ocaml.version}/site-lib"; in
   ''
   pushd $out/bin
   for prog in *
   do
    mv $prog .$prog-wrapped
    cat > $prog <<EOF
#!/bin/sh
export CAML_LD_LIBRARY_PATH=${p ocaml_lwt}/lwt:${p lambdaTerm}/lambda-term:'\$CAML_LD_LIBRARY_PATH'
export OCAMLPATH=${p ocaml_lwt}:${p ocaml_react}:${p camomile}:${p zed}:${p lambdaTerm}:"$out"/lib/ocaml/${ocaml.version}/site-lib:'\$OCAMLPATH'
${ocaml}/bin/ocamlrun $out/bin/.$prog-wrapped \$*
EOF
    chmod +x $prog
   done
   popd
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
