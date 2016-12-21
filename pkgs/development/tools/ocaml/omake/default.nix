{ stdenv, fetchurl, ocaml, ncurses }:

stdenv.mkDerivation rec {

  name = "omake-${version}";
  version = "0.10.1";

  src = fetchurl {
    url = "http://download.camlcity.org/download/${name}.tar.gz";
    sha256 = "093ansbppms90hiqvzar2a46fj8gm9iwnf8gn38s6piyp70lrbsj";
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
