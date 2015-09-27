{ stdenv, fetchurl
, freeglut, freealut, mesa, libICE, libjpeg, openal, openscenegraph, plib
, libSM, libunwind, libX11, xproto, libXext, xextproto, libXi, inputproto
, libXmu, libXt, simgear, zlib, boost, cmake, libpng, udev, fltk13, apr
, makeDesktopItem, qtbase
}:

stdenv.mkDerivation rec {
  version = "3.4.0";
  name = "flightgear-${version}";

  src = fetchurl {
    url = "http://ftp.igh.cnrs.fr/pub/flightgear/ftp/Source/${name}.tar.bz2";
    sha256 = "102pg7mahgxzypvyp76x363qy3a4gxavr4hj16gsha07nl2msr5m";
  };

  datasrc = fetchurl {
    url = "http://ftp.igh.cnrs.fr/pub/flightgear/ftp/Shared/FlightGear-data-${version}.tar.bz2";
    sha256 = "12qjvycizg693g5jj5qyp1jiwwywg6p9fg6j3zjxhx6r4g1sgvwc";
  };

  # Of all the files in the source and data archives, there doesn't seem to be
  # a decent icon :-)
  iconsrc = fetchurl {
    url = "http://wiki.flightgear.org/images/6/62/FlightGear_logo.png";
    sha256 = "1ikz413jia55vfnmx8iwrlxvx8p16ggm81mbrj66wam3q7s2dm5p";
  };

  desktopItem = makeDesktopItem {
    name = "flightgear";
    exec = "fgfs";
    icon = "${iconsrc}";
    comment = "FlightGear Flight Simulator";
    desktopName = "FlightGear";
    genericName = "Flight simulator";
    categories = "Game;Simulation";
  };

  buildInputs = [
    freeglut freealut mesa libICE libjpeg openal openscenegraph plib
    libSM libunwind libX11 xproto libXext xextproto libXi inputproto
    libXmu libXt simgear zlib boost cmake libpng udev fltk13 apr qtbase
  ];

  preConfigure = ''
    export cmakeFlagsArray=(-DFG_DATA_DIR="$out/share/FlightGear/")
  '';

  postInstall = ''
    mkdir -p "$out/share/applications/"
    cp "${desktopItem}"/share/applications/* "$out/share/applications/"

    mkdir -p "$out/share/FlightGear"
    tar xvf "${datasrc}" -C "$out/share/FlightGear/" --strip-components=1
  '';

  meta = with stdenv.lib; {
    description = "Flight simulator";
    maintainers = with maintainers; [ raskin the-kenny ];
    platforms = platforms.linux;
    hydraPlatforms = []; # disabled from hydra because it's so big
    license = licenses.gpl2;
  };
}
