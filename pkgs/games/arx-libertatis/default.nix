{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  boost,
  openal,
  glm,
  freetype,
  libGLU,
  SDL2,
  libepoxy,
  dejavu_fonts,
  inkscape,
  optipng,
  imagemagick,
  withCrashReporter ? !stdenv.isDarwin,
  qtbase ? null,
  wrapQtAppsHook ? null,
  curl ? null,
  gdb ? null,
}:

let
  inherit (lib)
    licenses
    maintainers
    optionals
    optionalString
    platforms
    ;
in

stdenv.mkDerivation rec {
  pname = "arx-libertatis";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "arx";
    repo = "ArxLibertatis";
    rev = version;
    sha256 = "GBJcsibolZP3oVOTSaiVqG2nMmvXonKTp5i/0NNODKY=";
  };

  nativeBuildInputs = [
    cmake
    inkscape
    imagemagick
    optipng
  ] ++ optionals withCrashReporter [ wrapQtAppsHook ];

  buildInputs =
    [
      zlib
      boost
      openal
      glm
      freetype
      libGLU
      SDL2
      libepoxy
    ]
    ++ optionals withCrashReporter [
      qtbase
      curl
    ]
    ++ optionals stdenv.isLinux [ gdb ];

  cmakeFlags = [
    "-DDATA_DIR_PREFIXES=$out/share"
    "-DImageMagick_convert_EXECUTABLE=${imagemagick.out}/bin/convert"
    "-DImageMagick_mogrify_EXECUTABLE=${imagemagick.out}/bin/mogrify"
  ];

  dontWrapQtApps = true;

  postInstall =
    ''
      ln -sf \
        ${dejavu_fonts}/share/fonts/truetype/DejaVuSansMono.ttf \
        $out/share/games/arx/misc/dejavusansmono.ttf
    ''
    + optionalString withCrashReporter ''
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
