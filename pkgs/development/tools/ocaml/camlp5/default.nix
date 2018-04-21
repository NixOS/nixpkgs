{ stdenv, fetchzip, ocaml, transitional ? false }:

let
  metafile = ./META;
in

stdenv.mkDerivation {

  name = "camlp5${if transitional then "_transitional" else ""}-7.05";

  src = fetchzip {
    url = https://github.com/camlp5/camlp5/archive/rel705.tar.gz;
    sha256 = "16igfyjl2jja4f1mibjfzk0c2jr09nxsz6lb63x1jkccmy6430q2";
  };

  buildInputs = [ ocaml ];

  postPatch = ''
    for p in compile/compile.sh config/Makefile.tpl test/Makefile test/check_ocaml_versions.sh
    do
      substituteInPlace $p --replace '/bin/rm' rm
    done
  '';

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
