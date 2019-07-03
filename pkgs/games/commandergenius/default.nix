{ stdenv, fetchFromGitLab, SDL2, SDL2_image, pkgconfig
, libvorbis, libGL, boost, cmake, zlib, curl, SDL2_mixer, python3
}:

stdenv.mkDerivation rec {
  name = "commandergenius-${version}";
  version = "2.3.3";

  src = fetchFromGitLab {
    owner = "Dringgstein";
    repo = "Commander-Genius";
    rev = "v${version}";
    sha256 = "04nb23wwvc3yywz3cr6gvn02fa7psfs22ssg4wk12s08z1azvz3h";
  };

  buildInputs = [ SDL2 SDL2_image SDL2_mixer libGL boost libvorbis zlib curl python3 ];

  preConfigure = ''
    export cmakeFlags="$cmakeFlags -DCMAKE_INSTALL_PREFIX=$out -DSHAREDIR=$out/share"
    export makeFlags="$makeFlags DESTDIR=$(out)"
  '';

  nativeBuildInputs = [ cmake pkgconfig ];

  postPatch = ''
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(sdl2-config --cflags)"
    sed -i 's,APPDIR games,APPDIR bin,' src/install.cmake
  '';

  meta = with stdenv.lib; {
    description = "Modern Interpreter for the Commander Keen Games";
    longDescription = ''
      Commander Genius is an open-source clone of
      Commander Keen which allows you to play
      the games, and some of the mods
      made for it. All of the original data files
      are required to do so
    '';
    homepage = https://github.com/gerstrong/Commander-Genius;
    maintainers = with maintainers; [ hce ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
