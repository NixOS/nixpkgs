{ stdenv, fetchurl, ocaml, ncurses }:

stdenv.mkDerivation rec {

  name = "omake-${version}";
  version = "0.10.2";

  src = fetchurl {
    url = "http://download.camlcity.org/download/${name}.tar.gz";
    sha256 = "1znnlkpz89hk44byvnl1pr92ym6hwfyyw2qm9clq446r6l2z4m64";
  };

  buildInputs = [ ocaml ncurses ];

  meta = {
    description = "A build system designed for scalability and portability";
    homepage = http://projects.camlcity.org/projects/omake.html;
    license = with stdenv.lib.licenses; [
      mit /* scripts */
      gpl2 /* program */
    ];
    inherit (ocaml.meta) platforms;
  };
}
