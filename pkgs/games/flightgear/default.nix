{ stdenv, fetchurl, wrapQtAppsHook
, freeglut, freealut, libGLU, libGL, libICE, libjpeg, openal, openscenegraph, plib
, libSM, libunwind, libX11, xorgproto, libXext, libXi
, libXmu, libXt, simgear, zlib, boost, cmake, libpng, udev, fltk13, apr
, makeDesktopItem, qtbase, qtdeclarative, glew
}:

let
  version = "2020.3.4";
  shortVersion = builtins.substring 0 6 version;
  data = stdenv.mkDerivation rec {
    pname = "flightgear-data";
    inherit version;

    src = fetchurl {
      url = "mirror://sourceforge/flightgear/release-${shortVersion}/FlightGear-${version}-data.tar.bz2";
      sha256 = "1cqikbqvidfaynml9bhqfr9yw5ga35gpqrbz62z94a1skdijkpkg";
    };

    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p "$out/share/FlightGear"
      tar xf "${src}" -C "$out/share/FlightGear/" --strip-components=1
    '';
  };
in
stdenv.mkDerivation rec {
  pname = "flightgear";
   # inheriting data for `nix-prefetch-url -A pkgs.flightgear.data.src`
  inherit version data;

  src = fetchurl {
    url = "mirror://sourceforge/flightgear/release-${shortVersion}/${pname}-${version}.tar.bz2";
    sha256 = "02d9h10p8hyn0a25csragj6pbwmrir1z8zb92023s9vi21j7bwy8";
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
    icon = iconsrc;
    comment = "FlightGear Flight Simulator";
    desktopName = "FlightGear";
    genericName = "Flight simulator";
    categories = "Game;Simulation";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook ];
  buildInputs = [
    freeglut freealut libGLU libGL libICE libjpeg openal openscenegraph plib
    libSM libunwind libX11 xorgproto libXext libXi
    libXmu libXt simgear zlib boost libpng udev fltk13 apr qtbase
    glew qtdeclarative
  ];

  postInstall = ''
    mkdir -p "$out/share/applications/"
    cp "${desktopItem}"/share/applications/* "$out/share/applications/" #*/
  '';

  qtWrapperArgs = [
    "--set FG_ROOT ${data}/share/FlightGear"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Flight simulator";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    hydraPlatforms = []; # disabled from hydra because it's so big
    license = licenses.gpl2;
  };
}
