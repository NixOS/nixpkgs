{ lib, stdenv, fetchurl, ocaml, ncurses }:

stdenv.mkDerivation rec {

  pname = "omake";
  version = "0.10.5";

  src = fetchurl {
    url = "http://download.camlcity.org/download/${pname}-${version}.tar.gz";
    sha256 = "sha256-VOFq2KLBbmZCRgHzfpD7p0iyF8yU1tTbyvTiOcpm98Q=";
  };

  strictDeps = true;

  nativeBuildInputs = [ ocaml ];
  buildInputs = [ ncurses ];

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
