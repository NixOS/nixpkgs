{stdenv, fetchurl, ocaml, transitional ? false}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  metafile = ./META;
in

stdenv.mkDerivation {

  name = "camlp5${if transitional then "_transitional" else ""}-6.06";

  src = fetchurl {
    url = http://pauillac.inria.fr/~ddr/camlp5/distrib/src/camlp5-6.06.tgz;
    sha256 = "763f89ee6cde4ca063a50708c3fe252d55ea9f8037e3ae9801690411ea6180c5";
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
