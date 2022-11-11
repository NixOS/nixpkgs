{ lib, stdenv, fetchurl, wrapQtAppsHook
, freeglut, freealut, libGLU, libGL, libICE, libjpeg, openal, openscenegraph, plib
, libSM, libunwind, libX11, xorgproto, libXext, libXi
, libXmu, libXt, simgear, zlib, boost, cmake, libpng, udev, fltk13, apr
, makeDesktopItem, qtbase, qtdeclarative, glew
}:

let
  version = "2020.3.13";
  shortVersion = builtins.substring 0 6 version;
  data = stdenv.mkDerivation rec {
    pname = "flightgear-data";
    inherit version;

    src = fetchurl {
      url = "mirror://sourceforge/flightgear/release-${shortVersion}/FlightGear-${version}-data.txz";
      sha256 = "sha256-C3iUVA7IJQ77OdXcaBnSpDphMFjmFZmn0nozQvdxSJM=";
    };

    dontUnpack = true;

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
    sha256 = "sha256-Zhq/r0davIz9G6tXVZRp76ZivG0D9Y6Nl3OFAD/lqow=";
  };

  # Of all the files in the source and data archives, there doesn't seem to be
  # a decent icon :-)
  iconsrc = fetchurl {
    url = "https://wiki.flightgear.org/w/images/6/62/FlightGear_logo.png";
    sha256 = "1ikz413jia55vfnmx8iwrlxvx8p16ggm81mbrj66wam3q7s2dm5p";
  };

  desktopItem = makeDesktopItem {
    name = "flightgear";
    exec = "fgfs";
    icon = iconsrc;
    comment = "FlightGear Flight Simulator";
    desktopName = "FlightGear";
    genericName = "Flight simulator";
    categories = [ "Game" "Simulation" ];
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

  meta = with lib; {
    description = "Flight simulator";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    hydraPlatforms = []; # disabled from hydra because it's so big
    license = licenses.gpl2;
  };
}
