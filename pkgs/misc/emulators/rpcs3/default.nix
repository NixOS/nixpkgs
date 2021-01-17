{ mkDerivation, lib, fetchgit, cmake, pkg-config, git
, qtbase, qtquickcontrols, openal, glew, vulkan-headers, vulkan-loader, libpng
, ffmpeg, libevdev, python3
, pulseaudioSupport ? true, libpulseaudio
, waylandSupport ? true, wayland
, alsaSupport ? true, alsaLib
}:

let
  majorVersion = "0.0.12";
  gitVersion = "10811-a86a3d2fe"; # echo $(git rev-list HEAD --count)-$(git rev-parse --short HEAD)
in
mkDerivation {
  pname = "rpcs3";
  version = "${majorVersion}-${gitVersion}";

  src = fetchgit {
    url = "https://github.com/RPCS3/rpcs3";
    rev = "v${majorVersion}";
    sha256 = "182rkmbnnlcfzam4bwas7lwv10vqiqvvaw3299a3hariacd7rq8x";
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
    "-DUSE_SYSTEM_LIBPNG=ON"
    "-DUSE_SYSTEM_FFMPEG=ON"
    "-DUSE_NATIVE_INSTRUCTIONS=OFF"
  ];

  nativeBuildInputs = [ cmake pkg-config git ];

  buildInputs = [
    qtbase qtquickcontrols openal glew vulkan-headers vulkan-loader libpng ffmpeg
    libevdev python3
  ] ++ lib.optional pulseaudioSupport libpulseaudio
    ++ lib.optional alsaSupport alsaLib
    ++ lib.optional waylandSupport wayland;

  meta = with lib; {
    description = "PS3 emulator/debugger";
    homepage = "https://rpcs3.net/";
    maintainers = with maintainers; [ abbradar neonfuz ilian ];
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
  };
}
