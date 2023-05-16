{ lib, stdenv, fetchurl, wrapQtAppsHook
, freeglut, freealut, libGLU, libGL, libICE, libjpeg, openal, openscenegraph, plib
, libSM, libunwind, libX11, xorgproto, libXext, libXi
, libXmu, libXt, simgear, zlib, boost, cmake, libpng, udev, fltk13, apr
, makeDesktopItem, qtbase, qtdeclarative, glew, curl
}:

let
<<<<<<< HEAD
  version = "2020.3.18";
=======
  version = "2020.3.17";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  shortVersion = builtins.substring 0 6 version;
  data = stdenv.mkDerivation rec {
    pname = "flightgear-data";
    inherit version;

    src = fetchurl {
      url = "mirror://sourceforge/flightgear/release-${shortVersion}/FlightGear-${version}-data.txz";
<<<<<<< HEAD
      sha256 = "sha256-U8lsHrw40Xo6a3jZw6GiPnOALvvg9PdecVAdkZewUjg=";
=======
      sha256 = "sha256-Kl66K5rmejaRKFgzps4/a73z8gIp9YcdfJQOFR1U2Og=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  # inheriting data for `nix-prefetch-url -A pkgs.flightgear.data.src`
=======
   # inheriting data for `nix-prefetch-url -A pkgs.flightgear.data.src`
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  inherit version data;

  src = fetchurl {
    url = "mirror://sourceforge/flightgear/release-${shortVersion}/${pname}-${version}.tar.bz2";
<<<<<<< HEAD
    sha256 = "sha256-OajjGj/Bgqg8H/6PjXkwJHwbSQqtzbQ1b3Xwk3aI3jc=";
=======
    sha256 = "sha256-ZnDe3qyiaDrKd/nwa/nR2AYq4yoqVFnd3IqgmJxfGFQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    glew qtdeclarative curl
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
