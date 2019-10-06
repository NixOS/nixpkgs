{ stdenv, fetchzip, ocaml }:

stdenv.mkDerivation {

  name = "camlp5-7.10";

  src = fetchzip {
    url = "https://github.com/camlp5/camlp5/archive/rel710.tar.gz";
    sha256 = "1a1lgsc8350afdwmsznsys7m0c0cks4nw6irqz2f92g8g4vkk9b7";
  };

  buildInputs = [ ocaml ];

  prefixKey = "-prefix ";

  preConfigure = "configureFlagsArray=(--strict" +
                  " --libdir $out/lib/ocaml/${ocaml.version}/site-lib)";

  buildFlags = "world.opt";

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
