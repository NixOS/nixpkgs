{ stdenv, fetchzip, ocaml, transitional ? false }:

let
  metafile = ./META;
in

stdenv.mkDerivation {

  name = "camlp5${if transitional then "_transitional" else ""}-7.02";

  src = fetchzip {
    url = https://github.com/camlp5/camlp5/archive/rel702.tar.gz;
    sha256 = "1m2d55zrgllidhgslvzgmr27f56qzdahz2sv56bvjs3bg7grmhnc";
  };

  buildInputs = [ ocaml ];

  prefixKey = "-prefix ";

  preConfigure = "configureFlagsArray=(" +  (if transitional then "--transitional" else "--strict") +
                  " --libdir $out/lib/ocaml/${ocaml.version}/site-lib)";

  buildFlags = "world.opt";

  postInstall = "cp ${metafile} $out/lib/ocaml/${ocaml.version}/site-lib/camlp5/META";

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "Preprocessor-pretty-printer for OCaml";
    longDescription = ''
      Camlp5 is a preprocessor and pretty-printer for OCaml programs.
      It also provides parsing and printing tools.
    '';
    homepage = https://camlp5.github.io/;
    license = licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [
      z77z vbgl
    ];
  };
}
