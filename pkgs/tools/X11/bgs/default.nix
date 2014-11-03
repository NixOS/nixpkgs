{stdenv, fetchurl, libX11, libXinerama, imlib2}:

stdenv.mkDerivation rec {

  name = "bgs-${version}";
  version = "0.6";

  src = fetchurl {
    url = "https://github.com/Gottox/bgs/archive/${version}.tar.gz";
    sha256 = "19xwslh74686qln0ylaql28z3ng45c7srrb3cxxvfp35lz7hjpf0";
  };

  buildInputs = [ libX11 libXinerama imlib2 ];

  preConfigure = ''sed -i "s@PREFIX = /usr/local@PREFIX = $out@g" config.mk'';

  meta = {
      description = "Extremely fast and small background setter for X";
      license = stdenv.lib.licenses.mit;
      hydraPlatforms = stdenv.lib.platforms.linux;
      maintainers = with stdenv.lib.maintainers; [pSub];
  };
}
