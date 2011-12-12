{stdenv, fetchurl, ocaml, transitional ? false}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  pname = "camlp5";
  version = "6.02.3";
  webpage = http://pauillac.inria.fr/~ddr/camlp5/;
  metafile = ./META;
in

stdenv.mkDerivation {

  name = "${pname}${if transitional then "_transitional" else ""}-${version}";

  src = fetchurl {
    url = "${webpage}/distrib/src/${pname}-${version}.tgz";
    sha256 = "1z9bwh267117br0vlhirv9yy2niqp2n25zfnl14wg6kgg9bqx7rj";
  };

  patches = fetchurl {
    url = "${webpage}/distrib/src/patch-${version}-1";
    sha256 = "159qpvr07mnn72yqwx24c6mw7hs6bl77capsii7apg9dcxar8w7v";
  };

  patchFlags = "-p 0";

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
    homepage = "${webpage}";
    license = "BSD";
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
