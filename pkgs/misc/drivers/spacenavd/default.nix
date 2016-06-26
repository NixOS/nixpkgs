{stdenv, fetchurl, libX11}:

stdenv.mkDerivation rec {
  version = "0.6";
  name = "spacenavd-${version}";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/spacenav/${name}.tar.gz";
    sha256 = "1ayhi06pv5lx36m5abwbib1wbs75svjkz92605cmkaf5jszh7ln2";
  };

  buildInputs = [ libX11 ];

  configureFlags = [ "--disable-debug"];

  meta = {
    homepage = "http://spacenav.sourceforge.net/";
    description = "A free, compatible alternative, to the proprietary 3Dconnexion device driver and SDK, for their 3D input devices (called 'space navigator', 'space pilot', 'space traveller', etc).";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.flosse ];
  };
}
