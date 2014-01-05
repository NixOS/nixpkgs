{stdenv, fetchurl, libX11, libXinerama, imlib2}:

stdenv.mkDerivation rec {

  name = "bgs-${version}";
  version = "0.5";

  src = fetchurl {
    url = "https://github.com/Gottox/bgs/archive/${version}.tar.gz";
    sha256 = "67fe16e3483f30f940005856fbb3246e1f99cf58371470e0d6668a27acbaefb9";
  };

  buildInputs = [ libX11 libXinerama imlib2 ];

  preConfigure = ''sed -i "s@PREFIX = /usr/local@PREFIX = $out@g" config.mk'';

  meta = {
      description = "Extremely fast and small background setter for X";
      license = "MIT";
      hydraPlatforms = stdenv.lib.platforms.linux;
      maintainers = with stdenv.lib.maintainers; [pSub];
  };
}
