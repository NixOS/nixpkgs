{ fetchFromGitHub, stdenv, pkgconfig, ncurses, lua, SDL2, SDL2_image, SDL2_ttf,
SDL2_mixer, freetype, gettext, CoreFoundation, Cocoa,
tiles ? true }:

stdenv.mkDerivation rec {
  version = "2017-12-09";
  name = "cataclysm-dda-git-${version}";

  src = fetchFromGitHub {
    owner = "CleverRaven";
    repo = "Cataclysm-DDA";
    rev = "24e92956db5587809750283873c242cc0796d7e6";
    sha256 = "1a7kdmx76na4g65zra01qaq98lxp9j2dl9ddv09r0p5yxaizw68z";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = with stdenv.lib; [ ncurses lua gettext ]
    ++ optionals stdenv.isDarwin [ CoreFoundation ]
    ++ optionals tiles [ SDL2 SDL2_image SDL2_ttf SDL2_mixer freetype ]
    ++ optionals (tiles && stdenv.isDarwin) [ Cocoa ];

  patches = [ ./patches/fix_locale_dir_git.patch ];

  postPatch = ''
    patchShebangs .
    sed -i data/xdg/com.cataclysmdda.cataclysm-dda.desktop \
        -e "s,\(Exec=\)\(cataclysm-tiles\),\1$out/bin/\2,"
  '';

  makeFlags = with stdenv.lib; [
    "PREFIX=$(out)"
    "LUA=1"
    "RELEASE=1"
    "USE_HOME_DIR=1"
    "LANGUAGES=all"
    "VERSION=git-${version}-${substring 0 8 src.rev}"
  ] ++ optionals tiles [
    "TILES=1"
    "SOUND=1"
  ] ++ optionals stdenv.isDarwin [
    "NATIVE=osx"
    "CLANG=1"
  ];

  postInstall = with stdenv.lib; optionalString (tiles && !stdenv.isDarwin) ''
    install -D -m 444 data/xdg/com.cataclysmdda.cataclysm-dda.desktop -T $out/share/applications/cataclysm-dda.desktop
    install -D -m 444 data/xdg/cataclysm-dda.svg -t $out/share/icons/hicolor/scalable/apps
  '' + optionalString (tiles && stdenv.isDarwin) ''
    app=$out/Applications/Cataclysm.app
    install -D -m 444 data/osx/Info.plist -t $app/Contents
    install -D -m 444 data/osx/AppIcon.icns -t $app/Contents/Resources
    mkdir $app/Contents/MacOS
    launcher=$app/Contents/MacOS/Cataclysm.sh
    cat << SCRIPT > $launcher
    #!/bin/sh
    $out/bin/cataclysm-tiles
    SCRIPT
    chmod 555 $launcher
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
    homepage = https://cataclysmdda.org/;
    license = licenses.cc-by-sa-30;
    platforms = platforms.unix;
  };
}
