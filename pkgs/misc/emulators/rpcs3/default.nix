{ mkDerivation, lib, fetchFromGitHub, cmake, pkg-config, git
, qtbase, qtquickcontrols, openal, glew, vulkan-headers, vulkan-loader, libpng
, ffmpeg, libevdev, libusb1, zlib, curl, python3
, sdl2Support ? true, SDL2
, pulseaudioSupport ? true, libpulseaudio
, waylandSupport ? true, wayland
, alsaSupport ? true, alsa-lib
}:

let
  majorVersion = "0.0.16";
  gitVersion = "12235-a4f4b81e6"; # echo $(git rev-list HEAD --count)-$(git rev-parse --short HEAD)
in
mkDerivation {
  pname = "rpcs3";
  version = "${majorVersion}-${gitVersion}";

  src = fetchFromGitHub {
    owner = "RPCS3";
    repo = "rpcs3";
    rev = "a4f4b81e6b0c00f4c30f9f5f182e5fe56f9fb03c";
    fetchSubmodules = true;
    sha256 = "1d70nljl1kmpbk50jpjki7dglw1bbxd7x4qzg6nz5np2sdsbpckd";
  };

  preConfigure = ''
    cat > ./rpcs3/git-version.h <<EOF
    #define RPCS3_GIT_VERSION "${gitVersion}"
    #define RPCS3_GIT_FULL_BRANCH "RPCS3/rpcs3/master"
    #define RPCS3_GIT_BRANCH "HEAD"
    #define RPCS3_GIT_VERSION_NO_UPDATE 1
    EOF
  '';

  cmakeFlags = [
    "-DUSE_SYSTEM_ZLIB=ON"
    "-DUSE_SYSTEM_LIBUSB=ON"
    "-DUSE_SYSTEM_LIBPNG=ON"
    "-DUSE_SYSTEM_FFMPEG=ON"
    "-DUSE_SYSTEM_CURL=ON"
    # NB: Can't use this yet, our CMake doesn't include FindWolfSSL.cmake
    #"-DUSE_SYSTEM_WOLFSSL=ON"
    "-DUSE_NATIVE_INSTRUCTIONS=OFF"
  ];

  nativeBuildInputs = [ cmake pkg-config git ];

  buildInputs = [
    qtbase qtquickcontrols openal glew vulkan-headers vulkan-loader libpng ffmpeg
    libevdev zlib libusb1 curl python3
  ] ++ lib.optional sdl2Support SDL2
    ++ lib.optional pulseaudioSupport libpulseaudio
    ++ lib.optional alsaSupport alsa-lib
    ++ lib.optional waylandSupport wayland;

  meta = with lib; {
    description = "PS3 emulator/debugger";
    homepage = "https://rpcs3.net/";
    maintainers = with maintainers; [ abbradar neonfuz ilian ];
    license = licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
  };
}
