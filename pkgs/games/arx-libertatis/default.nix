{ stdenv, fetchFromGitHub, cmake, zlib, boost
, openal, glm, freetype, libGLU, SDL2, epoxy
, dejavu_fonts, inkscape, optipng, imagemagick
, withCrashReporter ? !stdenv.isDarwin
,   qt5  ? null
,   curl ? null
,   gdb  ? null
}:

with stdenv.lib;

stdenv.mkDerivation {
  pname = "arx-libertatis";
  version = "2019-07-22";

  src = fetchFromGitHub {
    owner = "arx";
    repo = "ArxLibertatis";
    rev = "db77aa26bb8612f711b65e72b1cd8cf6481700c7";
    sha256 = "0c88djyzjna17wjcvkgsfx3011m1rba5xdzdldy1hjmafpqgb4jj";
  };


  nativeBuildInputs = [
    cmake inkscape imagemagick optipng
  ];

  buildInputs = [
    zlib boost openal glm
    freetype libGLU SDL2 epoxy
  ] ++ optionals withCrashReporter [ qt5.qtbase curl ]
    ++ optionals stdenv.isLinux    [ gdb ];

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
  
  meta = {
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
