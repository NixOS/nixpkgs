{ stdenv, fetchFromGitHub, pkgconfig, gettext, ncurses, CoreFoundation
, tiles, SDL2, SDL2_image, SDL2_mixer, SDL2_ttf, freetype, Cocoa
, debug, runtimeShell
}:

let
  inherit (stdenv.lib) optionals optionalString;

  cursesDeps = [ gettext ncurses ]
    ++ optionals stdenv.isDarwin [ CoreFoundation ];

  tilesDeps = [ SDL2 SDL2_image SDL2_mixer SDL2_ttf freetype ]
    ++ optionals stdenv.isDarwin [ Cocoa ];

  common = {
    nativeBuildInputs = [ pkgconfig ];

    buildInputs = cursesDeps ++ optionals tiles tilesDeps;

    postPatch = ''
      patchShebangs .
    '';

    makeFlags = [
      "PREFIX=$(out)" "USE_HOME_DIR=1" "LANGUAGES=all"
    ] ++ optionals (!debug) [
      "RELEASE=1"
    ] ++ optionals tiles [
      "TILES=1" "SOUND=1"
    ] ++ optionals stdenv.isDarwin [
      "NATIVE=osx" "CLANG=1"
    ];

    postInstall = optionalString tiles
    ( if !stdenv.isDarwin
      then utils.installXDGAppLauncher
      else utils.installMacOSAppLauncher
    );

    dontStrip = debug;

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
      maintainers = with maintainers; [ mnacamura ];
      platforms = platforms.unix;
    };
  };

  utils = {
    fetchFromCleverRaven = { rev, sha256 }:
    fetchFromGitHub {
      owner = "CleverRaven";
      repo = "Cataclysm-DDA";
      inherit rev sha256;
    };

    installXDGAppLauncher = ''
      launcher="$out/share/applications/cataclysm-dda.desktop"
      install -D -m 444 data/xdg/*cataclysm-dda.desktop -T "$launcher"
      sed -i "$launcher" -e "s,\(Exec=\)\(cataclysm-tiles\),\1$out/bin/\2,"
      install -D -m 444 data/xdg/cataclysm-dda.svg -t $out/share/icons/hicolor/scalable/apps
    '';

    installMacOSAppLauncher = ''
      app=$out/Applications/Cataclysm.app
      install -D -m 444 data/osx/Info.plist -t $app/Contents
      install -D -m 444 data/osx/AppIcon.icns -t $app/Contents/Resources
      mkdir $app/Contents/MacOS
      launcher=$app/Contents/MacOS/Cataclysm.sh
      cat << EOF > $launcher
      #!${runtimeShell}
      $out/bin/cataclysm-tiles
      EOF
      chmod 555 $launcher
    '';
  };
in

{ inherit common utils; }
