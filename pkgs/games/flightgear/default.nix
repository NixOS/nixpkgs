{ stdenv, fetchurl, makeWrapper
, freeglut, freealut, libGLU_combined, libICE, libjpeg, openal, openscenegraph, plib
, libSM, libunwind, libX11, xorgproto, libXext, libXi
, libXmu, libXt, simgear, zlib, boost, cmake, libpng, udev, fltk13, apr
, makeDesktopItem, qtbase, qtdeclarative, glew
}:

let
  version = "2018.2.2";
  shortVersion = "2018.2";
  data = stdenv.mkDerivation rec {
    name = "flightgear-base-${version}";

    src = fetchurl {
      url = "mirror://sourceforge/flightgear/release-${shortVersion}/FlightGear-${version}-data.tar.bz2";
      sha256 = "c89b94e4cf3cb7eda728daf6cca6dd051f7a47863776c99fd2f3fe0054400ac4";
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
    sha256 = "61f809ef0a3f6908d156f0c483ed5313d31b5a6ac74761955d0b266751718147";
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
    freeglut freealut libGLU_combined libICE libjpeg openal openscenegraph plib
    libSM libunwind libX11 xorgproto libXext libXi
    libXmu libXt simgear zlib boost cmake libpng udev fltk13 apr qtbase
    glew qtdeclarative
  ];

  postInstall = ''
    mkdir -p "$out/share/applications/"
    cp "${desktopItem}"/share/applications/* "$out/share/applications/" #*/

    for f in $out/bin/* #*/
    do
      wrapProgram $f --set FG_ROOT "${data}/share/FlightGear"
    done
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Flight simulator";
    maintainers = with maintainers; [ raskin the-kenny ];
    platforms = platforms.linux;
    hydraPlatforms = []; # disabled from hydra because it's so big
    license = licenses.gpl2;
  };
}
