{ stdenv, fetchurl, which, sqlite, lua5_1, perl, zlib, pkgconfig, ncurses
, dejavu_fonts, libpng, SDL, SDL_image, mesa, freetype
, tileMode ? true
}:

let version = "0.15.2";
in
stdenv.mkDerivation rec {
  name = "crawl-${version}" + (if tileMode then "-tiles" else "");
  src = fetchurl {
    url = "mirror://sourceforge/crawl-ref/Stone%20Soup/${version}/stone_soup-${version}-nodeps.tar.xz";
    sha256 = "1qi1g8w0sxmwrv96hnay20gpwp1xn2xcq1cw9iwn1yq112484fp9";
  };

  patches = [ ./makefile_fonts.patch ./makefile_sqlite.patch ];

  nativeBuildInputs = [ pkgconfig which perl ];

  # Still unstable with luajit
  buildInputs = [ lua5_1 zlib sqlite ncurses ]
             ++ stdenv.lib.optionals tileMode
                [ libpng SDL SDL_image freetype mesa ];

  preBuild = ''
    cd source
    # Related to issue #1963
    sed -i 's/-fuse-ld=gold//g' Makefile
    for i in util/*.pl; do
      patchShebangs $i
    done
    patchShebangs util/gen-mi-enum
  '';

  makeFlags = [ "prefix=$(out)" "FORCE_CC=gcc" "FORCE_CXX=g++" "HOSTCXX=g++"
                "SAVEDIR=~/.crawl" "sqlite=${sqlite}" ]
           ++ stdenv.lib.optionals tileMode [ "TILES=y" "dejavu_fonts=${dejavu_fonts}" ];

  postInstall = if tileMode then "mv $out/bin/crawl $out/bin/crawl-tiles" else "";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Open-source, single-player, role-playing roguelike game";
    longDescription = ''
      Open-source, single-player, role-playing roguelike game of exploration and
      treasure-hunting in dungeons filled with dangerous and unfriendly monsters
      in a quest to rescue the mystifyingly fabulous Orb of Zot.
    '';
    platforms = platforms.linux;
    licenses = with licenses; [ gpl2Plus bsd2 bsd3 mit zlib cc0 ];
    maintainers = maintainers.abbradar;
  };
}
