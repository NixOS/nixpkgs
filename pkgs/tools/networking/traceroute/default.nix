{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "traceroute-${version}";
  version = "2.0.20";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/traceroute/${name}.tar.gz";
    sha256 = "0wf2xnh5hm81fdn6dbkqqqlwbn6gdvy178zkpzbjhm694navmb1g";
  };

  makeFlags = "prefix=$(out)";

  preConfigure = ''
    sed -i 's@LIBS := \(.*\) -lm \(.*\)@LIBS := \1 \2@' Make.rules
  '';

  meta = with stdenv.lib; {
    homepage = http://traceroute.sourceforge.net/;
    description = "Tracks the route taken by packets over an IP network";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ maintainers.koral ];
    platforms = platforms.linux;
  };
}
