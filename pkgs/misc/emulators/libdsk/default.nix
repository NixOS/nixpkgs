{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libdsk-${version}";
  version = "1.5.9";

  src = fetchurl {
    url = "https://www.seasip.info/Unix/LibDsk/${name}.tar.gz";
    sha256 = "1r0y07qd3zixi53vql5yqakvv77qm86s6qjwypk9ckggrp5r3w60";
  };

  meta = with stdenv.lib; {
    description = "A library for accessing discs and disc image files";
    homepage = http://www.seasip.info/Unix/LibDsk/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };
}
