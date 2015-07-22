{ stdenv, fetchFromGitHub, cmake, pkgconfig, SDL2, SDL2_image, SDL2_mixer
, curl, gettext, libogg, libvorbis, mesa, openal, physfs, boost, glew
, libiconv }:

stdenv.mkDerivation rec {
  name = "supertux-${version}";
  version = "0.3.5a";

  src = fetchFromGitHub {
    owner = "SuperTux";
    repo = "supertux";
    rev = "v${version}";
    sha256 = "0f522wsv0gx7v1h70x8xznklaqr5bm2l9h7ls9vjywy0z4iy1ahp";
  };

  buildInputs = [ pkgconfig cmake SDL2 SDL2_image SDL2_mixer curl gettext
                  libogg libvorbis mesa openal physfs boost glew libiconv ];

  preConfigure = ''
    patchShebangs configure
  '';

  postInstall = ''
    mkdir $out/bin
    ln -s $out/games/supertux2 $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Classic 2D jump'n run sidescroller game";
    homepage = http://supertux.github.io/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
  };
}
