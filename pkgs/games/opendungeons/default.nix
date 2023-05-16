<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, ogre_13
, cegui
, boost
, sfml
, openal
, ois
}:

let
  ogre' = ogre_13.overrideAttrs (old: {
    cmakeFlags = old.cmakeFlags ++ [
      "-DOGRE_RESOURCEMANAGER_STRICT=0"
    ];
  });
  cegui' = cegui.override {
    ogre = ogre';
  };
in
stdenv.mkDerivation {
  pname = "opendungeons";
  version = "unstable-2023-03-18";

  src = fetchFromGitHub {
    owner = "paroj";
    repo = "OpenDungeons";
    rev = "974378d75591214dccbe0fb26e6ec8a40c2156e0";
    hash = "sha256-vz9cT+rNcyKT3W9I9VRKcFol2SH1FhOhOALALjgKfIE=";
=======
{ lib, stdenv, fetchFromGitHub, ogre, cegui, boost, sfml, openal, cmake, ois, pkg-config }:

stdenv.mkDerivation rec {
  pname = "opendungeons";
  version = "unstable-2021-11-06";

  src = fetchFromGitHub {
    owner = "OpenDungeons";
    repo = "OpenDungeons";
    rev = "c180ed1864eab5fbe847d1dd5c5c936c4e45444e";
    sha256 = "0xf7gkpy8ll1h59wyaljf0hr8prg7p4ixz80mxqwcnm9cglpgn63";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    ./cmakepaths.patch
    ./fix_link_date_time.patch
  ];

  # source/utils/StackTraceUnix.cpp:122:2: error: #error Unsupported architecture.
  postPatch = lib.optionalString (!stdenv.isx86_64) ''
    cp source/utils/StackTrace{Stub,Unix}.cpp
  '';

<<<<<<< HEAD
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    ogre'
    cegui'
    boost
    sfml
    openal
    ois
  ];

  cmakeFlags = [
    "-DOD_TREAT_WARNINGS_AS_ERRORS=FALSE"
  ];
=======
  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ ogre cegui boost sfml openal ois ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "An open source, real time strategy game sharing game elements with the Dungeon Keeper series and Evil Genius";
    homepage = "https://opendungeons.github.io";
    license = with licenses; [ gpl3Plus zlib mit cc-by-sa-30 cc0 ofl cc-by-30 ];
    platforms = platforms.linux;
  };
}
