{ stdenv, lib, fetchFromGitHub, which, sqlite, lua5_1, perl, zlib, pkgconfig, ncurses, python, pythonPackages
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

  # Patch hard-coded paths in the makefile
  patches = [ ./crawl_purify.patch ];

  nativeBuildInputs = [ pkgconfig which perl pngcrush advancecomp python pythonPackages.pyyaml ];

  # Still unstable with luajit
  buildInputs = [ lua5_1 zlib sqlite ncurses ]
                ++ lib.optionals tileMode [ libpng SDL2 SDL2_image freetype libGLU_combined ]
                ++ lib.optional enableSound SDL2_mixer;

  # A windows compatability patch removed the SDL2 prefix. Simplest thing is to
  # just add it back in the patch phase.
  # https://github.com/crawl/crawl/commit/e56fa010db5c8a24da55cafe5b21429c3ec65785
  postPatch = ''
    sed -i 's|SDL_image.h|SDL2/SDL_image.h|' crawl-ref/source/windowmanager-sdl.cc
  '';

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

  postInstall = lib.optionalString tileMode "mv $out/bin/crawl $out/bin/crawl-tiles";

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
