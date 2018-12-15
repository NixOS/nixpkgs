{ fetchurl, stdenv, cmake, pkgconfig, makeWrapper, python, alsaLib
, libX11, libGLU, SDL, lua5, zlib, freetype, wavpack
}:

stdenv.mkDerivation rec {
  name = "teeworlds-0.6.5";

  src = fetchurl {
    url = "https://downloads.teeworlds.com/teeworlds-0.6.5-src.tar.gz";
    sha256 = "07llxjc47d1gd9jqj3vf08cmw26ha6189mwcix1khwa3frfbilqb";
  };

  postPatch = ''
    # we always want to use system libs instead of these
    rm -r other/{freetype,sdl}/{include,mac,windows}

    # set compiled-in DATA_DIR so resources can be found
    substituteInPlace src/engine/shared/storage.cpp \
      --replace '#define DATA_DIR "data"' \
                '#define DATA_DIR "${placeholder "out"}/share/teeworlds/data"'
  '';

  nativeBuildInputs = [ cmake pkgconfig ];


  buildInputs = [
    python alsaLib libX11 libGLU SDL lua5 zlib freetype wavpack
  ];

  postInstall = ''
    mkdir -p $out/share/doc/teeworlds
    cp -v *.txt $out/share/doc/teeworlds/
  '';

  meta = {
    description = "Retro multiplayer shooter game";

    longDescription = ''
      Teeworlds is a free online multiplayer game, available for all
      major operating systems.  Battle with up to 12 players in a
      variety of game modes, including Team Deathmatch and Capture The
      Flag.  You can even design your own maps!
    '';

    homepage = https://teeworlds.com/;
    license = "BSD-style, see `license.txt'";
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
