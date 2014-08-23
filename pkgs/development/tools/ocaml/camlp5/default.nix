{stdenv, fetchurl, ocaml, transitional ? false}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  metafile = ./META;
in

stdenv.mkDerivation {

  name = "camlp5${if transitional then "_transitional" else ""}-6.11";

  src = fetchurl {
    url = http://pauillac.inria.fr/~ddr/camlp5/distrib/src/camlp5-6.11.tgz;
    sha256 = "0dxb5id6imq502sic75l786q94dhplqx6yyhjkkw19kf64fiqlk5";
  };

  buildInputs = [ ocaml ];

  prefixKey = "-prefix ";

  preConfigure = "configureFlagsArray=(" +  (if transitional then "--transitional" else "--strict") +
                  " --libdir $out/lib/ocaml/${ocaml_version}/site-lib)";

  buildFlags = "world.opt";

  postInstall = "cp ${metafile} $out/lib/ocaml/${ocaml_version}/site-lib/camlp5/META";

  meta = {
    description = "Preprocessor-pretty-printer for OCaml";
    longDescription = ''
      Camlp5 is a preprocessor and pretty-printer for OCaml programs.
      It also provides parsing and printing tools.
    '';
    homepage = http://pauillac.inria.fr/~ddr/camlp5/;
    license = stdenv.lib.licenses.bsd3;
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
