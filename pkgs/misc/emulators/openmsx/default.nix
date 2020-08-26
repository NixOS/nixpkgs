{ stdenv, fetchFromGitHub, pkgconfig
, python
, alsaLib, glew, libGL, libpng
, libogg, libtheora, libvorbis
, SDL, SDL_image, SDL_ttf
, freetype, tcl, zlib
}:

with stdenv.lib;
stdenv.mkDerivation rec {

  pname = "openmsx";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "openMSX";
    repo = "openMSX";
    rev = "RELEASE_0_15_0";
    sha256 = "1lv5kdw0812mkf7k20z2djzk0pbs792xq2mibbnz9rfjf02whi7l";
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

  meta = {
    description = "A MSX emulator";
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
