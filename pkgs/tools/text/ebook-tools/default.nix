{ stdenv, fetchurl, cmake, libxml2, libzip }:

let
  pn = "ebook-tools";
in

stdenv.mkDerivation rec {
  name = "${pn}-0.2.0";

  src = fetchurl {
    url = "mirror://sf/${pn}/${name}.tar.gz";
    sha256 = "18jb6v20pzk0kxv2dgjqgzzrcg7qid569apr63phfq1as1h09x67";
  };

  buildInputs = [ cmake libxml2 libzip ];

  meta = {
    homepage = "http://${pn}.sourceforge.net";
    description = "Tools and libs for dealing with various ebook file formats";
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
