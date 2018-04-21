{ stdenv, fetchFromGitHub, pkgconfig
, python
, alsaLib, glew, libGL, libpng
, libogg, libtheora, libvorbis
, SDL, SDL_image, SDL_ttf
, freetype, tcl, zlib
}:

stdenv.mkDerivation rec {

  name = "openmsx-${version}";
  version = "git-2017-11-02";

  src = fetchFromGitHub {
    owner = "openMSX";
    repo = "openMSX";
    rev = "eeb74206ae347a3b17e9b99f91f2b4682c5db22c";
    sha256 = "170amj7k6wjhwx6psbplqljvckvhxxbv3aw72jrdxl1fb8zlnq3s";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig python ];

  buildInputs = [ alsaLib glew libGL libpng
    libogg libtheora libvorbis freetype
    SDL SDL_image SDL_ttf tcl zlib ];

  postPatch = ''
    cp ${./custom-nixos.mk} build/custom.mk
  '';

  dontAddPrefix = true;

  # Many thanks @mthuurne from OpenMSX project
  # for providing support to Nixpkgs :)
  TCL_CONFIG="${tcl}/lib/";

  meta = with stdenv.lib; {
    description = "A MSX emulator";
    longDescription = ''
      OpenMSX is an emulator for the MSX home computer system. Its goal is
      to emulate all aspects of the MSX with 100% accuracy.
    '';
    homepage = https://openmsx.org;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
