{ fetchFromGitHub, stdenv, makeWrapper, pkgconfig, ncurses, lua, SDL2, SDL2_image, SDL2_ttf,
SDL2_mixer, freetype, gettext }:

stdenv.mkDerivation rec {
  version = "2017-12-09";
  name = "cataclysm-dda-git-${version}";

  src = fetchFromGitHub {
    owner = "CleverRaven";
    repo = "Cataclysm-DDA";
    rev = "24e92956db5587809750283873c242cc0796d7e6";
    sha256 = "1a7kdmx76na4g65zra01qaq98lxp9j2dl9ddv09r0p5yxaizw68z";
  };

  nativeBuildInputs = [ makeWrapper pkgconfig ];

  buildInputs = [ ncurses lua SDL2 SDL2_image SDL2_ttf SDL2_mixer freetype gettext ];

  postPatch = ''
    patchShebangs .
    sed -i Makefile \
      -e 's,-Werror,,g' \
      -e 's,\(DATA_PREFIX=$(PREFIX)/share/\)cataclysm-dda/,\1,g'

    sed '1i#include <cmath>' \
      -i src/{crafting,skill,weather_data,melee,vehicle,overmap,iuse_actor}.cpp
  '';

  makeFlags = "PREFIX=$(out) LUA=1 TILES=1 SOUND=1 RELEASE=1 USE_HOME_DIR=1";

  postInstall = ''
    wrapProgram $out/bin/cataclysm-tiles \
      --add-flags "--datadir $out/share/cataclysm-dda/"
  '';

  # https://hydra.nixos.org/build/65193254
  # src/weather_data.cpp:203:1: fatal error: opening dependency file obj/tiles/weather_data.d: No such file or directory
  # make: *** [Makefile:687: obj/tiles/weather_data.o] Error 1
  enableParallelBuilding = false;

  meta = with stdenv.lib; {
    description = "A free, post apocalyptic, zombie infested rogue-like";
    longDescription = ''
      Cataclysm: Dark Days Ahead is a roguelike set in a post-apocalyptic world.
      Surviving is difficult: you have been thrown, ill-equipped, into a
      landscape now riddled with monstrosities of which flesh eating zombies are
      neither the strangest nor the deadliest.

      Yet with care and a little luck, many things are possible. You may try to
      eke out an existence in the forests silently executing threats and
      providing sustenance with your longbow. You can ride into town in a
      jerry-rigged vehicle, all guns blazing, to settle matters in a fug of
      smoke from your molotovs. You could take a more measured approach and
      construct an impregnable fortress, surrounded by traps to protect you from
      the horrors without. The longer you survive, the more skilled and adapted
      you will get and the better equipped and armed to deal with the threats
      you are presented with.

      In the course of your ordeal there will be opportunities and temptations
      to improve or change your very nature. There are tales of survivors fitted
      with extraordinary cybernetics giving great power and stories too of
      gravely mutated survivors who, warped by their ingestion of exotic
      substances or radiation, now more closely resemble insects, birds or fish
      than their original form.
    '';
    homepage = http://en.cataclysmdda.com/;
    license = licenses.cc-by-sa-30;
    platforms = platforms.linux;
  };
}
