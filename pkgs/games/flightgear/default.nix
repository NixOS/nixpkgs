{
  lib,
  stdenv,
  fetchFromGitLab,
  wrapQtAppsHook,
  callPackage,
  libglut,
  freealut,
  libGLU,
  libGL,
  libICE,
  libjpeg,
  openal,
  plib,
  libSM,
  libunwind,
  libX11,
  xorgproto,
  libXext,
  libXi,
  libXmu,
  libXt,
  simgear,
  zlib,
  boost,
  cmake,
  libpng,
  udev,
  fltk13,
  apr,
  qtbase,
  qtquickcontrols2,
  qtdeclarative,
  glew,
  curl,
}:

let
  version = "2024.1.1";
  data = stdenv.mkDerivation rec {
    pname = "flightgear-data";
    inherit version;

    src = fetchFromGitLab {
      owner = "flightgear";
      repo = "fgdata";
      tag = "v${version}";
      hash = "sha256-PdqsIZw9mSrvnqqB/fVFjWPW9njhXLWR/2LQCMoBLQI=";
    };

    dontUnpack = true;

    installPhase = ''
      mkdir -p "$out/share/FlightGear"
      cp ${src}/* -a "$out/share/FlightGear/"
    '';
  };
  openscenegraph = callPackage ./openscenegraph-flightgear.nix { };
in
stdenv.mkDerivation rec {
  pname = "flightgear";
  # inheriting data for `nix-prefetch-url -A pkgs.flightgear.data.src`
  inherit version data;

  src = fetchFromGitLab {
    owner = "flightgear";
    repo = "flightgear";
    tag = "v${version}";
    hash = "sha256-h4N18VAbJGQSBKA+eEQxej5e5MEwAcZpvH+dpTypM+k=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];
  buildInputs = [
    libglut
    freealut
    libGLU
    libGL
    libICE
    libjpeg
    openal
    openscenegraph
    plib
    libSM
    libunwind
    libX11
    xorgproto
    libXext
    libXi
    libXmu
    libXt
    (simgear.override { openscenegraph = openscenegraph; })
    zlib
    boost
    libpng
    udev
    fltk13
    apr
    qtbase
    qtquickcontrols2
    glew
    qtdeclarative
    curl
  ];

  qtWrapperArgs = [ "--set FG_ROOT ${data}/share/FlightGear" ];

  meta = with lib; {
    description = "Flight simulator";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    hydraPlatforms = [ ]; # disabled from hydra because it's so big
    license = licenses.gpl2Plus;
    mainProgram = "fgfs";
  };
}
