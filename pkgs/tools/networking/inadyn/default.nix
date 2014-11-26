{ stdenv, fetchurl, gnutls }:

let
  ver = "1.99.10";
in
stdenv.mkDerivation {
  name = "inadyn-${ver}";

  src = fetchurl {
    url = "https://github.com/troglobit/inadyn/archive/${ver}.tar.gz";
    sha256 = "0m3qnnq99siwf1ybcvbzdawk68lxf61vd13fw1f2ssl2m07hfxg3";
  };

  preConfigure = ''
    export makeFlags=prefix=$out
  '';

  buildInputs = [ gnutls ];

  NIX_CFLAGS_COMPILE = "-Wno-error=cpp";

  meta = {
    homepage = http://inadyn.sourceforge.net/;
    description = "Free dynamic DNS client";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
