{ stdenv, fetchzip, ocaml }:

stdenv.mkDerivation {

  name = "camlp5-7.12";

  src = fetchzip {
    url = "https://github.com/camlp5/camlp5/archive/rel712.tar.gz";
    sha256 = "12ix5g15bys932hyf9gs637iz76m0ji9075d83jfdmx85q30llgf";
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
