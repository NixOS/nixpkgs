{ stdenv
, lib
, cairo
, cmake
, fetchFromGitHub
, ffmpeg
, gettext
, libGLU, libGL
, openal
, pkgconfig
, SDL2
, sfml
, zip
, zlib
, enableWx ? false
, gtk2
, wxGTK
}:

stdenv.mkDerivation rec {
  pname = "visualboyadvance-m";
  version = "2019-12-26";
  src = fetchFromGitHub {
    owner = "visualboyadvance-m";
    repo = "visualboyadvance-m";
    rev = "d3397e6a1a777ca037c014510689b75da9e197db";
    sha256 = "079cn76sif5jzdl5xpa4rv6iyx4z3xp9fv2nzdbxqgdwi8dh0dr8";
  };

  patches = lib.optionals enableWx [ ./wx-cmake-fix-prefix.patch ];

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    cairo
    ffmpeg
    gettext
    libGLU libGL
    openal
    SDL2
    sfml
    zip
    zlib
  ] ++ lib.optionals enableWx [ gtk2 wxGTK ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE='Release'"
    "-DENABLE_FFMPEG='true'"
    "-DENABLE_LINK='true'"
    "-DSYSCONFDIR=etc"
  ] ++ (if !enableWx
        then [ "-DENABLE_WX='false'"
               "-DENABLE_SDL='true'"
             ]
        else [ "-DENABLE_WX='true'" ]);

  meta =  with lib; {
    description = "A merge of the original Visual Boy Advance forks";
    license = licenses.gpl2;
    maintainers = with maintainers; [ lassulus ];
    homepage = http://vba-m.com/;
    platforms = lib.platforms.linux;
    badPlatforms = [ "aarch64-linux" ];
  };
}
