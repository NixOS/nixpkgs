{stdenv, fetchurl, ocaml, transitional ? false}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  metafile = ./META;
in

stdenv.mkDerivation {

  name = "camlp5${if transitional then "_transitional" else ""}-6.16";

  src = fetchurl {
    url = http://camlp5.gforge.inria.fr/distrib/src/camlp5-6.16.tgz;
    sha256 = "1caqa2rl7rav7pfwv1l1j0j18yr1qzyyqz0wa9519x91ckznqi7x";
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
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [
      z77z vbgl
    ];
  };
}
