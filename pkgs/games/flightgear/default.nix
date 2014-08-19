{ stdenv, fetchurl
, freeglut, freealut, mesa, libICE, libjpeg, openal, openscenegraph, plib
, libSM, libunwind, libX11, xproto, libXext, xextproto, libXi, inputproto
, libXmu, libXt, simgear, zlib, boost, cmake, libpng, udev, fltk13, apr
, makeDesktopItem
}:

stdenv.mkDerivation rec {
  version = "3.0.0";
  name = "flightgear-${version}";

  src = fetchurl {
    url = "http://ftp.linux.kiev.ua/pub/fgfs/Source/${name}.tar.bz2";
    sha256 = "1sd6ic9rrcgrqvc6ywkasj2pnmmmdv1i2rlyac2a882rh8i1kgz4";
  };

  datasrc = fetchurl {
    url = "http://ftp.igh.cnrs.fr/pub/flightgear/ftp/Shared/FlightGear-data-${version}.tar.bz2";
    sha256 = "0mq5hkh8zgm129mg1ij3rrk7h2xs9ijxa7d7hipjlp6mcyhlk0q4";
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
    libXmu libXt simgear zlib boost cmake libpng udev fltk13 apr
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
