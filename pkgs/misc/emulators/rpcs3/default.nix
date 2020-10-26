{ mkDerivation, lib, fetchgit, cmake, pkgconfig, git
, qtbase, qtquickcontrols, openal, glew, vulkan-headers, vulkan-loader, libpng
, ffmpeg, libevdev, python3
, pulseaudioSupport ? true, libpulseaudio
, waylandSupport ? true, wayland
, alsaSupport ? true, alsaLib
}:

let
  majorVersion = "0.0.8";
  gitVersion = "9300-341fdf7eb"; # echo $(git rev-list HEAD --count)-$(git rev-parse --short HEAD)
in
mkDerivation {
  pname = "rpcs3";
  version = "${majorVersion}-${gitVersion}";

  src = fetchgit {
    url = "https://github.com/RPCS3/rpcs3";
    rev = "v${majorVersion}";
    sha256 = "1qx97zkkjl6bmv5rhfyjqynbz0v8h40b2wxqnl59g287wj0yk3y1";
  };

  preConfigure = ''
    cat > ./rpcs3/git-version.h <<EOF
    #define RPCS3_GIT_VERSION "${gitVersion}"
    #define RPCS3_GIT_BRANCH "HEAD"
    #define RPCS3_GIT_VERSION_NO_UPDATE 1
    EOF
  '';

  cmakeFlags = [
    "-DUSE_SYSTEM_LIBPNG=ON"
    "-DUSE_SYSTEM_FFMPEG=ON"
    "-DUSE_NATIVE_INSTRUCTIONS=OFF"
  ];

  nativeBuildInputs = [ cmake pkgconfig git ];

  buildInputs = [
    qtbase qtquickcontrols openal glew vulkan-headers vulkan-loader libpng ffmpeg
    libevdev python3
  ] ++ lib.optional pulseaudioSupport libpulseaudio
    ++ lib.optional alsaSupport alsaLib
    ++ lib.optional waylandSupport wayland;

  enableParallelBuilding = true;

  meta = with lib; {
    broken = true;
    description = "PS3 emulator/debugger";
    homepage = "https://rpcs3.net/";
    maintainers = with maintainers; [ abbradar nocent ];
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
  };
}
