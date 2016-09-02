{ stdenv, fetchurl, gnutls33, autoreconfHook }:

let
  version = "1.99.15";
in
stdenv.mkDerivation {
  name = "inadyn-${version}";

  src = fetchurl {
    url = "https://github.com/troglobit/inadyn/releases/download/${version}/inadyn-${version}.tar.xz";
    sha256 = "05f7k9wpr0fn44y0pvdrv8xyilygmq3kjhvrwlj6dgg9ackdhkmm";
  };

  preConfigure = ''
    export makeFlags=prefix=$out
  '';

  buildInputs = [ gnutls33 autoreconfHook ];

  NIX_CFLAGS_COMPILE = "-Wno-error=cpp";

  meta = {
    homepage = http://inadyn.sourceforge.net/;
    description = "Free dynamic DNS client";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
