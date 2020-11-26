{ stdenv, fetchzip, ocaml }:

stdenv.mkDerivation {

  name = "camlp5-7.13";

  src = fetchzip {
    url = "https://github.com/camlp5/camlp5/archive/rel713.tar.gz";
    sha256 = "1d9spy3f5ahixm8nxxk086kpslzva669a5scn49am0s7vx4i71kp";
  };

  buildInputs = [ ocaml ];

  prefixKey = "-prefix ";

  preConfigure = "configureFlagsArray=(--strict" +
                  " --libdir $out/lib/ocaml/${ocaml.version}/site-lib)";

  buildFlags = [ "world.opt" ];

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "Preprocessor-pretty-printer for OCaml";
    longDescription = ''
      Camlp5 is a preprocessor and pretty-printer for OCaml programs.
      It also provides parsing and printing tools.
    '';
    homepage = "https://camlp5.github.io/";
    license = licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [
      maggesi vbgl
    ];
  };
}
