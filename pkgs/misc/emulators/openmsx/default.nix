{ lib, stdenv, fetchFromGitHub, pkg-config
, python
, alsa-lib, glew, libGL, libpng
, libogg, libtheora, libvorbis
, SDL2, SDL2_image, SDL2_ttf
, freetype, tcl, zlib
}:

stdenv.mkDerivation rec {
  pname = "openmsx";
  version = "16.0";

  src = fetchFromGitHub {
    owner = "openMSX";
    repo = "openMSX";
    rev = "RELEASE_${builtins.replaceStrings ["."] ["_"] version}";
    sha256 = "04sphn9ph378r0qv881riv90cgz58650jcqcwmi1mv6gbcb3img5";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config python ];

  buildInputs = [ alsa-lib glew libGL libpng
    libogg libtheora libvorbis freetype
    SDL2 SDL2_image SDL2_ttf tcl zlib ];

  postPatch = ''
    cp ${./custom-nix.mk} build/custom.mk
  '';

  dontAddPrefix = true;

  # Many thanks @mthuurne from OpenMSX project
  # for providing support to Nixpkgs :)
  TCL_CONFIG="${tcl}/lib/";

  meta = with lib;{
    description = "The MSX emulator that aims for perfection";
    longDescription = ''
      OpenMSX is an emulator for the MSX home computer system. Its goal is
      to emulate all aspects of the MSX with 100% accuracy.
    '';
    homepage = "https://openmsx.org";
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
    license = with licenses; [ bsd2 boost gpl2 ];
  };
}
