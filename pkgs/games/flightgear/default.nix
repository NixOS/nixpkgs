{ stdenv, fetchurl, makeWrapper
, freeglut, freealut, mesa, libICE, libjpeg, openal, openscenegraph, plib
, libSM, libunwind, libX11, xproto, libXext, xextproto, libXi, inputproto
, libXmu, libXt, simgear, zlib, boost, cmake, libpng, udev, fltk13, apr
, makeDesktopItem, qtbase
}:

let
  version = "2016.4.4";
  shortVersion = "2016.4";
  data = stdenv.mkDerivation rec {
    name = "flightgear-base-${version}";

    src = fetchurl {
      url = "mirror://sourceforge/flightgear/release-${shortVersion}/FlightGear-${version}-data.tar.bz2";
      sha256 = "0s4nlkwi9jfc408agsl0w5xl3vajrvplc66k3nwg92wsr614pz9x";
    };

    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p "$out/share/FlightGear"
      tar xf "${src}" -C "$out/share/FlightGear/" --strip-components=1
    '';
  };
in
stdenv.mkDerivation rec {
  name = "flightgear-${version}";
   # inheriting data for `nix-prefetch-url -A pkgs.flightgear.data.src`
  inherit version data;

  src = fetchurl {
    url = "mirror://sourceforge/flightgear/release-${shortVersion}/${name}.tar.bz2";
    sha256 = "1z7s9m2g85g8q9zxawhpal84rq2jin1ppchshbwi460gwk5r46fm";
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
    makeWrapper
    freeglut freealut mesa libICE libjpeg openal openscenegraph plib
    libSM libunwind libX11 xproto libXext xextproto libXi inputproto
    libXmu libXt simgear zlib boost cmake libpng udev fltk13 apr qtbase
  ];

  postInstall = ''
    mkdir -p "$out/share/applications/"
    cp "${desktopItem}"/share/applications/* "$out/share/applications/" #*/

    for f in $out/bin/* #*/
    do
      wrapProgram $f --set FG_ROOT "${data}/share/FlightGear"
    done


  '';

  meta = with stdenv.lib; {
    description = "Flight simulator";
    maintainers = with maintainers; [ raskin the-kenny ];
    platforms = platforms.linux;
    hydraPlatforms = []; # disabled from hydra because it's so big
    license = licenses.gpl2;
  };
}
