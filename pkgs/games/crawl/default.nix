{ stdenv
, lib
, fetchFromGitHub
, which
, sqlite
, lua5_1
, perl
, python3
, zlib
, pkg-config
, ncurses
, dejavu_fonts
, libpng
, SDL2
, SDL2_image
, SDL2_mixer
, libGLU
, libGL
, freetype
, pngcrush
, advancecomp
, tileMode ? false
, enableSound ? tileMode
, buildPackages
  # MacOS / Darwin builds
, darwin
}:

stdenv.mkDerivation rec {
  pname = "crawl${lib.optionalString tileMode "-tiles"}";
  version = "0.32.1";

  src = fetchFromGitHub {
    owner = "crawl";
    repo = "crawl";
    rev = version;
    hash = "sha256-jhjFC8+A2dQomMwKZPSiEViXeQpty2Dk9alDcNsLvq0=";
  };

  # Patch hard-coded paths and remove force library builds
  postPatch = ''
    substituteInPlace crawl-ref/source/util/find_font \
      --replace '/usr/share/fonts /usr/local/share/fonts /usr/*/lib/X11/fonts' '${fontsPath}/share/fonts'
    substituteInPlace crawl-ref/source/windowmanager-sdl.cc \
      --replace 'SDL_image.h' 'SDL2/SDL_image.h'
  '';

  nativeBuildInputs = [ pkg-config which perl pngcrush advancecomp ];

  # Still unstable with luajit
  buildInputs = [ lua5_1 zlib sqlite ncurses ]
    ++ (with python3.pkgs; [ pyyaml ])
    ++ lib.optionals tileMode [ libpng SDL2 SDL2_image freetype libGLU libGL ]
    ++ lib.optional enableSound SDL2_mixer
    ++ (lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk.frameworks; [
      AppKit
      AudioUnit
      CoreAudio
      ForceFeedback
      Carbon
      IOKit
      OpenGL
    ]
  ));

  preBuild = ''
    cd crawl-ref/source
    echo "${version}" > util/release_ver
    patchShebangs 'util'
    patchShebangs util/gen-mi-enum
    rm -rf contrib
    mkdir -p $out/xdg-data
  ''
  + lib.optionalString tileMode "mv xdg-data/*_tiles.* $out/xdg-data"
  + lib.optionalString (!tileMode) "mv xdg-data/*_console.* $out/xdg-data";

  fontsPath = lib.optionalString tileMode dejavu_fonts;

  makeFlags = [
    "prefix=${placeholder "out"}"
    "FORCE_CC=${stdenv.cc.targetPrefix}cc"
    "FORCE_CXX=${stdenv.cc.targetPrefix}c++"
    "HOSTCXX=${buildPackages.stdenv.cc.targetPrefix}c++"
    "FORCE_PKGCONFIG=y"
    "SAVEDIR=~/.crawl"
    "sqlite=${sqlite.dev}"
    "DATADIR=${placeholder "out"}"
  ]
  ++ lib.optional tileMode "TILES=y"
  ++ lib.optional enableSound "SOUND=y";

  postInstall =
    lib.optionalString tileMode ''
      mv $out/bin/crawl $out/bin/crawl-tiles
      echo "Exec=crawl-tiles" >> $out/xdg-data/org.develz.Crawl_tiles.desktop
      echo "Icon=crawl" >> $out/xdg-data/org.develz.Crawl_tiles.desktop
      install -Dm444 $out/xdg-data/org.develz.Crawl_tiles.desktop -t $out/share/applications
      install -Dm444 $out/xdg-data/org.develz.Crawl_tiles.appdata.xml -t $out/share/metainfo
    ''
    +
    lib.optionalString (!tileMode) ''
      echo "Exec=crawl" >> $out/xdg-data/org.develz.Crawl_console.desktop
      echo "Icon=crawl" >> $out/xdg-data/org.develz.Crawl_console.desktop
      install -Dm444 $out/xdg-data/org.develz.Crawl_console.desktop -t $out/share/applications
      install -Dm444 $out/xdg-data/org.develz.Crawl_console.appdata.xml -t $out/share/metainfo
    ''
    + "install -Dm444 dat/tiles/stone_soup_icon-512x512.png $out/share/icons/hicolor/512x512/apps/crawl.png"
  ;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Open-source, single-player, role-playing roguelike game";
    homepage = "http://crawl.develz.org/";
    longDescription = ''
      Dungeon Crawl: Stone Soup, an open-source, single-player, role-playing
      roguelike game of exploration and treasure-hunting in dungeons filled
      with dangerous and unfriendly monsters in a quest to rescue the
      mystifyingly fabulous Orb of Zot.
    '';
    platforms = platforms.linux ++ platforms.darwin;
    license = with licenses; [ gpl2Plus bsd2 bsd3 mit licenses.zlib cc0 ];
    maintainers = [ maintainers.abbradar ];
  };
}
