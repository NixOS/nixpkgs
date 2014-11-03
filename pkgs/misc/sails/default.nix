{ stdenv, fetchurl, cmake, pkgconfig, gtk3, librsvg }:

stdenv.mkDerivation rec {
  version = "0.1.1";
  name = "sails-${version}";
  src = fetchurl {
    url = "https://github.com/kragniz/sails/archive/v${version}.tar.gz";
    sha256 = "0k55ib6cb78filgq3yrdib69qrzsny0209bq6h0v1yigry0sa62v";
  };

  buildInputs = [ cmake pkgconfig gtk3 librsvg ];

  meta = with stdenv.lib; {
    description = "Simulator for autonomous sailing boats";
    homepage = https://github.com/kragniz/sails;
    license = licenses.gpl3;
    longDescription = ''
      Sails is a simulator designed to test the AI of autonomous sailing
      robots. It emulates the basic physics of sailing a small single sail
      boat'';
    maintainers = maintainers.kragniz;
    platforms = platforms.all;
  };
}
