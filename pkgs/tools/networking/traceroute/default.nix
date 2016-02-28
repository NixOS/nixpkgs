{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "traceroute-${version}";
  version = "2.0.21";

  src = fetchurl {
    url = "mirror://sourceforge/traceroute/${name}.tar.gz";
    sha256 = "1q4n9s42nfcc4fmnwmrsiabvqrcaagiagmmqj9r5hfmi63pr7b7p";
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
