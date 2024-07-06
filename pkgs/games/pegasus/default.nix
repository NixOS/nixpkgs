{ stdenv
, lib
, fetchFromGitHub
, cmake
, gnumake
, pkg-config
# qt
, qtbase
, qmake
, wrapQtAppsHook
, qtgamepad
, qtmultimedia
, qtsvg
# optionals
, withGit ? true
, git
, SDL2
}:

stdenv.mkDerivation rec {
  pname = "pegasus-frontend";
  # version = "weekly_2022w30";
  version = "02458df0e1efdf3effebb8e463dcbfce86fcee2a";

  src = fetchFromGitHub {
    owner = "mmatyas";
    repo = "pegasus-frontend";
    rev = version;
    # sha256 = "sha256-7tB1lWCDY9t2SujCgJps40ha/lgJ8XB3pGhd8UDddSM=";
    sha256 = "sha256-AZQWxLXDcNPnzdFk/FhIgfAXA2btGGRhPOHm6hUkFbA=";
    fetchSubmodules = true;
    deepClone = true;
    leaveDotGit = true;
  };

  doCheck = true;

  buildInputs = [ qtbase qtgamepad qtmultimedia qtsvg SDL2 ] ++ lib.optional withGit git;
  nativeBuildInputs = [ wrapQtAppsHook pkg-config qmake ];
}
