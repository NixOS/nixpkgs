{ stdenv, fetchurl, sqlite, lua, which, zlib, pkgconfig, dejavu_fonts,
  libpng, perl, SDL, SDL_image, ncurses, mesa}:

stdenv.mkDerivation rec {
   name = "crawl-0.14.1";
   src = fetchurl {
      url = "http://downloads.sourceforge.net/project/crawl-ref/Stone%20Soup/0.14.1/stone_soup-0.14.1-nodeps.tar.xz";
      sha256 = "91726d0224b93ba26b5d4bd3762bc5aabe1f02974ea6c937be89dc6c6ab7a4dd";
      };

   patches = [ ./makefile_fonts.patch ./makefile_sqlite.patch
               ./makefile_rltiles.patch ./makefile_rltiles2.patch
               ./makefile_misc.patch ./makefile_prefix.patch
   ];

   buildInputs = [stdenv pkgconfig lua zlib sqlite which libpng perl SDL
                  dejavu_fonts SDL_image ncurses mesa];

   preBuild = "cd source";

   makeFlags = "TILES=y";

   inherit dejavu_fonts sqlite SDL_image SDL;
}
