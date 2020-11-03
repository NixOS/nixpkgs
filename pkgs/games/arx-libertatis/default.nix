{ stdenv, fetchFromGitHub, cmake, zlib, boost
, openal, glm, freetype, libGLU, SDL2, epoxy
, dejavu_fonts, inkscape_0, optipng, imagemagick
, withCrashReporter ? !stdenv.isDarwin
,   qtbase ? null
,   wrapQtAppsHook ? null
,   curl ? null
,   gdb  ? null
}:

with stdenv.lib;

stdenv.mkDerivation {
  pname = "arx-libertatis";
  version = "2020-10-20";

  src = fetchFromGitHub {
    owner = "arx";
    repo = "ArxLibertatis";
    rev = "21df2e37664de79e117eff2af164873f05600f4c";
    sha256 = "06plyyh0ddqv1j04m1vclz9j72609pgrp61v8wfjdcln8djm376i";
  };

  nativeBuildInputs = [
    cmake inkscape_0 imagemagick optipng
  ] ++ optionals withCrashReporter [ wrapQtAppsHook ];

  buildInputs = [
    zlib boost openal glm
    freetype libGLU SDL2 epoxy
  ] ++ optionals withCrashReporter [ qtbase curl ]
    ++ optionals stdenv.isLinux    [ gdb ];

  cmakeFlags = [
    "-DDATA_DIR_PREFIXES=$out/share"
    "-DImageMagick_convert_EXECUTABLE=${imagemagick.out}/bin/convert"
    "-DImageMagick_mogrify_EXECUTABLE=${imagemagick.out}/bin/mogrify"
  ];

  enableParallelBuilding = true;
  dontWrapQtApps = true;

  postInstall = ''
    ln -sf \
      ${dejavu_fonts}/share/fonts/truetype/DejaVuSansMono.ttf \
      $out/share/games/arx/misc/dejavusansmono.ttf
  '' + optionalString withCrashReporter ''
    wrapQtApp "$out/libexec/arxcrashreporter"
  '';

  meta = {
    description = ''
      A cross-platform, open source port of Arx Fatalis, a 2002
      first-person role-playing game / dungeon crawler
      developed by Arkane Studios.
    '';
    homepage = "https://arx-libertatis.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms = platforms.linux;
  };

}
