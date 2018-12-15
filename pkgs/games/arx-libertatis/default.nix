{ stdenv, fetchFromGitHub, cmake, zlib, boost,
  openal, glm, freetype, libGLU_combined, glew, SDL2,
  dejavu_fonts, inkscape, optipng, imagemagick }:

stdenv.mkDerivation rec {
  name = "arx-libertatis-${version}";
  version = "2018-08-26";

  src = fetchFromGitHub {
    owner  = "arx";
    repo   = "ArxLibertatis";
    rev    = "7b551739cc22fa25dae83bcc1a2b784ddecc729c";
    sha256 = "1ybv3p74rywn0ajdbw7pyk7pd7py1db9h6x2pav2d28ndkkj4z8n";
  };

  buildInputs = [
    cmake zlib boost openal glm
    freetype libGLU_combined glew SDL2 inkscape
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
    homepage = http://arx-libertatis.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms = platforms.linux;
  };

}
