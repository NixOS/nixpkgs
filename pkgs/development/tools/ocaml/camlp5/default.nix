{stdenv, fetchurl, ocaml, transitional ? false}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  metafile = ./META;
in

stdenv.mkDerivation {

  name = "camlp5${if transitional then "_transitional" else ""}-6.14";

  src = fetchurl {
    url = http://camlp5.gforge.inria.fr/distrib/src/camlp5-6.14.tgz;
    sha256 = "1ql04iyvclpyy9805kpddc4ndjb5d0qg4shhi2fc6bixi49fvy89";
  };

  buildInputs = [ ocaml ];

  prefixKey = "-prefix ";

  preConfigure = "configureFlagsArray=(" +  (if transitional then "--transitional" else "--strict") +
                  " --libdir $out/lib/ocaml/${ocaml_version}/site-lib)";

  buildFlags = "world.opt";

  postInstall = "cp ${metafile} $out/lib/ocaml/${ocaml_version}/site-lib/camlp5/META";

  meta = with stdenv.lib; {
    description = "Preprocessor-pretty-printer for OCaml";
    longDescription = ''
      Camlp5 is a preprocessor and pretty-printer for OCaml programs.
      It also provides parsing and printing tools.
    '';
    homepage = http://pauillac.inria.fr/~ddr/camlp5/;
    license = licenses.bsd3;
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    maintainers = with maintainers; [
      z77z vbgl
    ];
  };
}
