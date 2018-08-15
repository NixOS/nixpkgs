{ stdenv, lib, fetchFromGitHub, which, sqlite, lua5_1, perl, zlib, pkgconfig, ncurses
, dejavu_fonts, libpng, SDL2, SDL2_image, libGLU_combined, freetype, pngcrush, advancecomp
, tileMode ? false
}:

stdenv.mkDerivation rec {
  name = "crawl-${version}${lib.optionalString tileMode "-tiles"}";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "crawl-ref";
    repo = "crawl-ref";
    rev = version;
    sha256 = "1bzhqrc944rgpdnnid3c5h2r3dvyw70cs70hazzm0cv5aipdkhbl";
  };

  # Patch hard-coded paths in the makefile
  patches = [ ./crawl_purify.patch ];

  nativeBuildInputs = [ pkgconfig which perl pngcrush advancecomp ];

  # Still unstable with luajit
  buildInputs = [ lua5_1 zlib sqlite ncurses ]
                ++ lib.optionals tileMode [ libpng SDL2 SDL2_image freetype libGLU_combined ];

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
              ] ++ lib.optional tileMode "TILES=y";

  postInstall = lib.optionalString tileMode "mv $out/bin/crawl $out/bin/crawl-tiles";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Open-source, single-player, role-playing roguelike game";
    homepage = http://crawl.develz.org/;
    longDescription = ''
      Open-source, single-player, role-playing roguelike game of exploration and
      treasure-hunting in dungeons filled with dangerous and unfriendly monsters
      in a quest to rescue the mystifyingly fabulous Orb of Zot.
    '';
    platforms = platforms.linux;
    license = with licenses; [ gpl2Plus bsd2 bsd3 mit licenses.zlib cc0 ];
    maintainers = [ maintainers.abbradar ];
  };
}
