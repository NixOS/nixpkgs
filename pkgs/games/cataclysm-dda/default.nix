{ fetchFromGitHub, stdenv, pkgconfig, ncurses, lua, SDL2, SDL2_image, SDL2_ttf,
SDL2_mixer, freetype, gettext, Cocoa, libicns,
tiles ? true }:

stdenv.mkDerivation rec {
  version = "0.C";
  name = "cataclysm-dda-${version}";

  src = fetchFromGitHub {
    owner = "CleverRaven";
    repo = "Cataclysm-DDA";
    rev = "${version}";
    sha256 = "03sdzsk4qdq99qckq0axbsvg1apn6xizscd8pwp5w6kq2fyj5xkv";
  };

  nativeBuildInputs = [ pkgconfig ]
    ++ stdenv.lib.optionals (tiles && stdenv.isDarwin) [ libicns ];

  buildInputs = with stdenv.lib; [ ncurses lua gettext ]
    ++ optionals tiles [ SDL2 SDL2_image SDL2_ttf SDL2_mixer freetype ]
    ++ optionals (tiles && stdenv.isDarwin) [ Cocoa ];

  patches = [ ./patches/fix_locale_dir.patch ];

  postPatch = ''
    patchShebangs .
  '';

  makeFlags = with stdenv.lib; [
    "PREFIX=$(out)"
    "LUA=1"
    "RELEASE=1"
    "USE_HOME_DIR=1"
    # "LANGUAGES=all"  # vanilla C:DDA installs all translations even without this flag!
  ] ++ optionals tiles [
    "TILES=1"
    "SOUND=1"
  ] ++ optionals stdenv.isDarwin [
    "NATIVE=osx"
    "CLANG=1"
    "OSX_MIN=10.6"  # SDL for macOS only supports deploying on 10.6 and above
  ] ++ optionals stdenv.cc.isGNU [
    "WARNINGS+=-Wno-deprecated-declarations"
    "WARNINGS+=-Wno-ignored-attributes"
  ] ++ optionals stdenv.cc.isClang [
    "WARNINGS+=-Wno-inconsistent-missing-override"
  ];

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.cc.isClang "-Wno-user-defined-warnings";

  postBuild = stdenv.lib.optionalString (tiles && stdenv.isDarwin) ''
    # iconutil on macOS is not available in nixpkgs
    png2icns data/osx/AppIcon.icns data/osx/AppIcon.iconset/*
  '';

  postInstall = stdenv.lib.optionalString (tiles && stdenv.isDarwin) ''
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

  # Disable, possible problems with hydra
  #enableParallelBuilding = true;

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
    maintainers = [ maintainers.skeidel ];
    platforms = platforms.unix;
  };
}
