{ stdenv, fetchurl, cmake, pkgconfig, SDL2, SDL2_image, SDL2_mixer
, curl, gettext, libogg, libvorbis, mesa, openal, physfs, boost, glew
, libiconv }:

stdenv.mkDerivation rec {
  name = "supertux-${version}";
  version = "0.4.0";

  src = fetchurl {
    url = https://github.com/SuperTux/supertux/releases/download/v0.4.0/supertux-0.4.0.tar.bz2;
    sha256 = "10ppmy6w77lxj8bdzjahc9bidgl4qgzr9rimn15rnqay84ydx3fi";
  };

  buildInputs = [ pkgconfig cmake SDL2 SDL2_image SDL2_mixer curl gettext
                  libogg libvorbis mesa openal physfs boost glew libiconv ];

  postInstall = ''
    mkdir $out/bin
    ln -s $out/games/supertux2 $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Classic 2D jump'n run sidescroller game";
    homepage = http://supertux.github.io/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
  };
}
