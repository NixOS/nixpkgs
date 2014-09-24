{stdenv, fetchurl, ocaml, transitional ? false}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  metafile = ./META;
in

stdenv.mkDerivation {

  name = "camlp5${if transitional then "_transitional" else ""}-6.12";

  src = fetchurl {
    url = http://camlp5.gforge.inria.fr/distrib/src/camlp5-6.12.tgz;
    sha256 = "00jwgp6w4g64lfqjx77xziy532091fy00c42fsy0b4i892rch5mp";
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
    maintainers = with maintainers; [
      z77z vbgl
    ];
  };
}
