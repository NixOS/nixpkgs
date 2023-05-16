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
<<<<<<< HEAD
  version = "2.1.0";
=======
  version = "1.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "deathkiller";
    repo = "jazz2-native";
    rev = version;
<<<<<<< HEAD
    sha256 = "nJha7+geP2Ov7ciEDzJ+XWdiF1jzv4Oeis1DwxcpJXo=";
=======
    sha256 = "fi1waoLAcnZB0lX+8+wQFoBYOSvVXYK3JKiu81GGF4U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
