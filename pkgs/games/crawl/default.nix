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

stdenv.mkDerivation (finalAttrs: {
  pname = "crawl${lib.optionalString tileMode "-tiles"}";
  version = "0.30.1";

  src = fetchFromGitHub {
    owner = "crawl";
    repo = "crawl";
    rev = finalAttrs.version;
    hash = "sha256-9IbuAXQCFZUDS0kNUcN3lwhsLYFkuaGUOjv+Y8NHl+Y=";
  };

  patches = [
    # Patch hard-coded paths and remove force library builds
    ./crawl_purify.patch
  ];

  nativeBuildInputs = [
    advancecomp
    perl
    pkg-config
    pngcrush
    which
  ];

  # Still unstable with luajit
  buildInputs = [ lua5_1 ncurses sqlite zlib ]
    ++ (with python3.pkgs; [ pyyaml ])
    ++ lib.optionals tileMode [ freetype libGL libGLU libpng SDL2 SDL2_image  ]
    ++ lib.optional enableSound SDL2_mixer
    ++ (lib.optionals stdenv.isDarwin (
    with darwin.apple_sdk.frameworks; [
      AppKit
      AudioUnit
      Carbon
      CoreAudio
      ForceFeedback
      IOKit
      OpenGL
    ]
  ));

  preBuild = ''
    cd crawl-ref/source
    echo "${finalAttrs.version}" > util/release_ver
    patchShebangs 'util'
    patchShebangs util/gen-mi-enum
    rm -rf contrib
  '';

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
  ] ++ lib.optional tileMode "TILES=y"
  ++ lib.optional enableSound "SOUND=y";

  postInstall = ''
    make install-xdg-data ${builtins.concatStringsSep " " finalAttrs.makeFlags}
    ${lib.optionalString tileMode ''
      mv $out/bin/crawl $out/bin/crawl-tiles
      sed -i 's/bin\/crawl/bin\/crawl-tiles/' \
        $out/share/applications/org.develz.Crawl_tiles.desktop
    ''}
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Open-source, single-player, role-playing roguelike game";
    homepage = "http://crawl.develz.org/";
    license = with lib.licenses; [ gpl2Plus bsd2 bsd3 mit zlib cc0 ];
    longDescription = ''
      Dungeon Crawl: Stone Soup, an open-source, single-player, role-playing
      roguelike game of exploration and treasure-hunting in dungeons filled
      with dangerous and unfriendly monsters in a quest to rescue the
      mystifyingly fabulous Orb of Zot.
    '';
    maintainers = with lib.maintainers; [ abbradar ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
