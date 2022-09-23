{ lib, stdenv, fetchurl, ocaml, ncurses }:

stdenv.mkDerivation rec {

  pname = "omake";
  version = "0.10.3";

  src = fetchurl {
    url = "http://download.camlcity.org/download/${pname}-${version}.tar.gz";
    sha256 = "07bdg1h5i7qnlv9xq81ad5hfypl10hxm771h4rjyl5cn8plhfcgz";
  };

  buildInputs = [ ocaml ncurses ];

  meta = {
    description = "A build system designed for scalability and portability";
    homepage = "http://projects.camlcity.org/projects/omake.html";
    license = with lib.licenses; [
      mit /* scripts */
      gpl2 /* program */
    ];
    inherit (ocaml.meta) platforms;
  };
}
