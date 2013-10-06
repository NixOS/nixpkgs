{ stdenv, fetchurl
, freeglut, freealut, mesa, libICE, libjpeg, openal, openscenegraph, plib
, libSM, libunwind, libX11, xproto, libXext, xextproto, libXi, inputproto
, libXmu, libXt, simgear, zlib, boost, cmake, libpng, udev, fltk13, apr
}:

stdenv.mkDerivation rec {
  version = "2.12.0";
  name = "flightgear-${version}";

  src = fetchurl {
    url = "http://ftp.linux.kiev.ua/pub/fgfs/Source/${name}.tar.bz2";
    sha256 = "0h9ka4pa2njxbvy5jlmnsjy5ynzms504ygqn7hd80g3c58drsjc4";
  };

  datasrc = fetchurl {
    url = "http://ftp.igh.cnrs.fr/pub/flightgear/ftp/Shared/FlightGear-data-${version}.tar.bz";
    sha256 = "0qjvcj2cz7ypa91v95lws44fg8c1p0pazv24ljkai2m2r0jgsv8k";
  };

  buildInputs = [
    freeglut freealut mesa libICE libjpeg openal openscenegraph plib
    libSM libunwind libX11 xproto libXext xextproto libXi inputproto
    libXmu libXt simgear zlib boost cmake libpng udev fltk13 apr
  ];

  preConfigure = ''
    export cmakeFlagsArray=(-DFG_DATA_DIR="$out/share/FlightGear/")
  '';

  postInstall = ''
    mkdir -p "$out/share/FlightGear"
    tar xvf "${datasrc}" -C "$out/share/FlightGear/" --strip-components=1
  '';

  meta = with stdenv.lib; {
    description = "Flight simulator";
    maintainers = with maintainers; [ raskin ];
    #platforms = platforms.linux; # disabled from hydra because it's so big
    license = licenses.gpl2;
  };
}
