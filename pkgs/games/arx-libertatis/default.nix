{ stdenv, fetchFromGitHub, cmake, zlib, boost
, openal, glm, freetype, libGLU, SDL2, epoxy
, dejavu_fonts, inkscape, optipng, imagemagick
, withCrashReporter ? !stdenv.isDarwin
,   qtbase ? null
,   wrapQtAppsHook ? null
,   curl ? null
,   gdb  ? null
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "arx-libertatis";
  version = "2019-02-16";

  src = fetchFromGitHub {
    owner  = "arx";
    repo   = "ArxLibertatis";
    rev    = "fbce6ccbc7f58583f33f29b838c38ef527edc267";
    sha256 = "0qrygp09dqhpb5q6a1zl6l03qh9bi7xcahd8hy9177z1cix3k0kz";
  };

  nativeBuildInputs = [
    cmake inkscape imagemagick optipng
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
    homepage    = http://arx-libertatis.org/;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms   = platforms.linux;
  };

}
