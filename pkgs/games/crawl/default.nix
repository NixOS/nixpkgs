{ stdenv, lib, fetchFromGitHub, fetchpatch, which, sqlite, lua5_1, perl, python3, zlib, pkg-config, ncurses
, dejavu_fonts, libpng, SDL2, SDL2_image, SDL2_mixer, libGLU, libGL, freetype, pngcrush, advancecomp
, tileMode ? false, enableSound ? tileMode, buildPackages

# MacOS / Darwin builds
, darwin ? null
}:

stdenv.mkDerivation rec {
  pname = "crawl${lib.optionalString tileMode "-tiles"}";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "crawl";
    repo = "crawl";
    rev = version;
    sha256 = "sha256-SM8dSDV+88QGMqoFkITop1PHh9EakdgiV4tkXCw9pjM=";
  };

  # Patch hard-coded paths and remove force library builds
  patches = [ ./crawl_purify.patch ];

  nativeBuildInputs = [ pkg-config which perl pngcrush advancecomp ];

  # Still unstable with luajit
  buildInputs = [ lua5_1 zlib sqlite ncurses ]
                ++ (with python3.pkgs; [ pyyaml ])
                ++ lib.optionals tileMode [ libpng SDL2 SDL2_image freetype libGLU libGL ]
                ++ lib.optional enableSound SDL2_mixer
                ++ (lib.optionals stdenv.isDarwin (
                  assert (lib.assertMsg (darwin != null) "Must have darwin frameworks available for darwin builds");
                  with darwin.apple_sdk.frameworks; [
                    AppKit AudioUnit CoreAudio ForceFeedback Carbon IOKit OpenGL
                   ]
                ));

  preBuild = ''
    cd crawl-ref/source
    echo "${version}" > util/release_ver
    patchShebangs 'util'
    patchShebangs util/gen-mi-enum
    rm -rf contrib
  '';

  fontsPath = lib.optionalString tileMode dejavu_fonts;

  makeFlags = [ "prefix=${placeholder "out"}" "FORCE_CC=${stdenv.cc.targetPrefix}cc" "FORCE_CXX=${stdenv.cc.targetPrefix}c++" "HOSTCXX=${buildPackages.stdenv.cc.targetPrefix}c++"
                "FORCE_PKGCONFIG=y"
                "SAVEDIR=~/.crawl" "sqlite=${sqlite.dev}"
                "DATADIR=${placeholder "out"}"
              ] ++ lib.optional tileMode "TILES=y"
                ++ lib.optional enableSound "SOUND=y";

  postInstall = ''
    ${lib.optionalString tileMode "mv $out/bin/crawl $out/bin/crawl-tiles"}
    sed -i 's#/usr/games/##' debian/crawl${lib.optionalString tileMode "-tiles"}.desktop
    install -m 444 -D debian/crawl${lib.optionalString tileMode "-tiles"}.desktop \
      $out/share/applications/crawl${lib.optionalString tileMode "-tiles"}.desktop
    install -m 444 -D dat/tiles/stone_soup_icon-512x512.png $out/share/icons/hicolor/512x512/apps/crawl.png
  '';

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
