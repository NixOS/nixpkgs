{ cmake
, fetchFromGitHub
, glew
, glfw
, jazz2-content
, lib
, libGL
, libopenmpt
, libvorbis
, openal
, SDL2
, stdenv
, xorg
, zlib
}:

stdenv.mkDerivation rec {
  pname = "jazz2";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "deathkiller";
    repo = "jazz2-native";
    rev = version;
    sha256 = "75CGpFEdk+vFrlGC20Ciniw6CHBmP43TsCQmb4r70DI=";
  };

  patches = [ ./nocontent.patch ];

  buildInputs = [ libGL SDL2 zlib glew glfw openal libvorbis libopenmpt xorg.libSM xorg.libICE xorg.libXext ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DNCINE_DOWNLOAD_DEPENDENCIES=OFF"
    "-DGLFW_INCLUDE_DIR=${glfw}/include/GLFW"
    "-DLIBOPENMPT_INCLUDE_DIR=${libopenmpt.dev}/include/libopenmpt"
    "-DNCINE_OVERRIDE_CONTENT_PATH=${jazz2-content}"
  ];

  meta = with lib; {
    description = "Open-source Jazz Jackrabbit 2 reimplementation";
    homepage = "https://github.com/deathkiller/jazz2-native";
    license = licenses.gpl3;
    maintainers = with maintainers; [ surfaceflinger ];
    platforms = platforms.linux;
  };
}
