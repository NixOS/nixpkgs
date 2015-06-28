{ stdenv, fetchFromGitHub, which, sqlite, lua5_1, perl, zlib, pkgconfig, ncurses
, dejavu_fonts, libpng, SDL2, SDL2_image, mesa, freetype
, tileMode ? true
}:

let version = "0.16.1";
in
stdenv.mkDerivation rec {
  name = "crawl-${version}" + (if tileMode then "-tiles" else "");
  src = fetchFromGitHub {
    owner = "crawl-ref";
    repo = "crawl-ref";
    rev = version;
    sha256 = "0gciqaij05qr5bwkk5mblvk5k0p6bzjd58czk1b6x5xx5qcp6mmh";
  };

  patches = [ ./crawl_purify.patch ];

  nativeBuildInputs = [ pkgconfig which perl ];

  # Still unstable with luajit
  buildInputs = [ lua5_1 zlib sqlite ncurses ]
             ++ stdenv.lib.optionals tileMode
                [ libpng SDL2 SDL2_image freetype mesa ];

  preBuild = ''
    cd crawl-ref/source
    echo "${version}" > util/release_ver
    # Related to issue #1963
    sed -i 's/-fuse-ld=gold//g' Makefile
    for i in util/*; do
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
    license = with licenses; [ gpl2Plus bsd2 bsd3 mit licenses.zlib cc0 ];
    maintainers = [ maintainers.abbradar ];
  };
}
