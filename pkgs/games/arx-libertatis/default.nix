{ stdenv, fetchgit, cmake, zlib, boost,
  openal, glm, freetype, mesa, glew, SDL2,
  dejavu_fonts, inkscape, optipng, imagemagick }:

stdenv.mkDerivation rec {
  name = "arx-libertatis-${version}";
  version = "2016-07-27";

  src = fetchgit {
    url = "https://github.com/arx/ArxLibertatis";
    rev = "e3aa6353f90886e7e9db2f4350ad9a232dd01c1e";
    sha256 = "1hkkf0z607z8wxdikxq1ji120b3w7pxixq9qapdj1p54dzgbhgza";
  };

  buildInputs = [
    cmake zlib boost openal glm
    freetype mesa glew SDL2 inkscape
    optipng imagemagick
  ];

  cmakeFlags = [
    "-DDATA_DIR_PREFIXES=$out/share"
    "-DImageMagick_convert_EXECUTABLE=${imagemagick.out}/bin/convert"
    "-DImageMagick_mogrify_EXECUTABLE=${imagemagick.out}/bin/mogrify"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    ln -sf \
      ${dejavu_fonts}/share/fonts/truetype/DejaVuSansMono.ttf \
      $out/share/games/arx/misc/dejavusansmono.ttf
  '';
  
  meta = with stdenv.lib; {
    description = ''
      A cross-platform, open source port of Arx Fatalis, a 2002
      first-person role-playing game / dungeon crawler
      developed by Arkane Studios.
    '';
    homepage = "http://arx-libertatis.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms = platforms.linux;
  };

}
