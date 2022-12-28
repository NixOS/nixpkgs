{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "traceroute";
  version = "2.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/traceroute/${pname}-${version}.tar.gz";
    sha256 = "3669d22a34d3f38ed50caba18cd525ba55c5c00d5465f2d20d7472e5d81603b6";
  };

  makeFlags = [ "prefix=$(out)" "LDFLAGS=-lm" "env=yes" ];

  preConfigure = ''
    sed -i 's@LIBS := \(.*\) -lm \(.*\)@LIBS := \1 \2@' Make.rules
  '';

  meta = with lib; {
    homepage = "http://traceroute.sourceforge.net/";
    description = "Tracks the route taken by packets over an IP network";
    license = lib.licenses.gpl2;
    maintainers = [ maintainers.koral ];
    platforms = platforms.linux;
  };
}
