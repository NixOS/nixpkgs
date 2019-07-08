{ stdenv, lib, fetchFromGitHub, fetchpatch, which, sqlite, lua5_1, perl, python3, zlib, pkgconfig, ncurses
, dejavu_fonts, libpng, SDL2, SDL2_image, SDL2_mixer, libGLU_combined, freetype, pngcrush, advancecomp
, tileMode ? false, enableSound ? tileMode
}:

stdenv.mkDerivation rec {
  name = "crawl-${version}${lib.optionalString tileMode "-tiles"}";
  version = "0.23.2";

  src = fetchFromGitHub {
    owner = "crawl";
    repo = "crawl";
    rev = version;
    sha256 = "1d6mip4rvp81839yf2xm63hf34aza5wg4g5z5hi5275j94szaacs";
  };

  patches = [
    ./crawl_purify.patch  # Patch hard-coded paths
    (fetchpatch {         # Use a nice high-res app icon
      url = "https://github.com/crawl/crawl/commit/2aa1166087e44e6585b26cedf1fe81b3f3ba547f.patch";
      sha256 = "1jqrdv4wy18shg1fdabdb421232hg5micphkixcyzxd1lrmvadg0";
    })
  ];

  nativeBuildInputs = [ pkgconfig which perl pngcrush advancecomp ];

  # Still unstable with luajit
  buildInputs = [ lua5_1 zlib sqlite ncurses ]
                ++ (with python3.pkgs; [ pyyaml ])
                ++ lib.optionals tileMode [ libpng SDL2 SDL2_image freetype libGLU_combined ]
                ++ lib.optional enableSound SDL2_mixer;

  preBuild = ''
    cd crawl-ref/source
    echo "${version}" > util/release_ver
    patchShebangs 'util'
    patchShebangs util/gen-mi-enum
    rm -rf contrib
  '';

  fontsPath = lib.optionalString tileMode dejavu_fonts;

  makeFlags = [ "prefix=$(out)" "FORCE_CC=cc" "FORCE_CXX=c++" "HOSTCXX=c++"
                "SAVEDIR=~/.crawl" "sqlite=${sqlite.dev}"
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

  meta = with stdenv.lib; {
    description = "Open-source, single-player, role-playing roguelike game";
    homepage = http://crawl.develz.org/;
    longDescription = ''
      Dungeon Crawl: Stone Soup, an open-source, single-player, role-playing
      roguelike game of exploration and treasure-hunting in dungeons filled
      with dangerous and unfriendly monsters in a quest to rescue the
      mystifyingly fabulous Orb of Zot.
    '';
    platforms = platforms.linux;
    license = with licenses; [ gpl2Plus bsd2 bsd3 mit licenses.zlib cc0 ];
    maintainers = [ maintainers.abbradar ];
  };
}
