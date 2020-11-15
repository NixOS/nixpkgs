{ fetchurl, stdenv, pkgconfig, gettext, python3, SDL, SDL_image, SDL_gfx, SDL_mixer, libogg, libvorbis, lua5_3, libjpeg, libpng, zlib, libiconv }:

let
  version = "0.16.1";
in stdenv.mkDerivation {
  pname = "freedroidrpg";
  inherit version;

  src = fetchurl {
    url = "ftp://ftp.osuosl.org/pub/freedroid/freedroidRPG-${stdenv.lib.versions.majorMinor version}/freedroidRPG-${version}.tar.gz";
    sha256 = "0n4kn38ncmcy3lrxmq8fjry6c1z50z4q1zcqfig0j4jb0dsz2va2";
  };

  nativeBuildInputs = [ pkgconfig gettext python3 ];

  buildInputs = [
    SDL SDL_image SDL_gfx SDL_mixer libogg libvorbis lua5_3 libjpeg libpng zlib
  ] ++ stdenv.lib.optional stdenv.isDarwin libiconv;

  meta = with stdenv.lib; {
    description = "Isometric 3D RPG similar to game Diablo";

    longDescription = ''
      <para>
        FreedroidRPG is an original isometric 3D role playing game
        taking place in the future, on Earth. It features action and
        dialogs.
      </para>
      <para>
        The game tells the story of a world destroyed by a conflict between
        robots and their human masters. Play as Tux in a quest to save the
        world from the murderous rebel bots who know no mercy. You get to
        choose which path you wish to follow, and freedom of choice is
        everywhere in the game.
      </para>
      <para>
        FreedroidRPG features a real time combat system with melee and
        ranged weapons, fairly similar to the proprietary game Diablo.
        There is an innovative system of programs that can be run in order
        to take control of enemy robots, alter their behavior, or improve one's
        characteristics. You can use over 50 different kinds of items and
        fight countless enemies on your way to your destiny. An advanced
        dialog system provides story background and immersive role
        playing situations.
      </para>
      <para>
        The game is complete, fully playable, and can provide about
        12 hours of fun. It is still being actively developed, and
        help is welcome in many areas. People having - or trying to acquire -
        programming, map editing, or writing skills will find FreedroidRPG
        to be an exciting, fast-moving project in which they can fully
        express their creativity.
      </para>
    '';

    homepage = "http://www.freedroid.org/";

    license = licenses.gpl2Plus;

    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
    hydraPlatforms = platforms.linux; # sdl-config times out on darwin
  };
}
