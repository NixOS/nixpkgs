{ stdenv, lib, fetchgit, cmake, pkgconfig, git
, qt5, openal, glew, vulkan-loader, libpng, ffmpeg, libevdev, python27
, pulseaudioSupport ? true, libpulseaudio
, waylandSupport ? true, wayland
, alsaSupport ? true, alsaLib
}:

stdenv.mkDerivation rec {
  name = "rpcs3-${version}";
  version = "0.0.5-6938";

  src = fetchgit {
    url = "https://github.com/RPCS3/rpcs3";
    rev = "4db0cf005bbd030dc001b41e480a739db77db601";
    sha256 = "1hcafhlz6y1hkbfklszf4hbdiciwgswkwwdpw9j3kvyvgs2bwhfl";
    branchName = "master";  # Prevent default 'fetchgit' branch from appearing in version info
    deepClone = true;       # Required for git describe to return commit count in version info
    leaveDotGit = true;     # Required for version header file generation
  };

  cmakeFlags = [
    "-DUSE_SYSTEM_LIBPNG=ON"
    "-DUSE_SYSTEM_FFMPEG=ON"
    "-DUSE_NATIVE_INSTRUCTIONS=OFF"
  ];

  nativeBuildInputs = [ cmake pkgconfig git ];

  buildInputs = [
    qt5.qtbase qt5.qtquickcontrols openal glew vulkan-loader libpng ffmpeg libevdev python27
  ] ++ lib.optional pulseaudioSupport libpulseaudio
    ++ lib.optional alsaSupport alsaLib
    ++ lib.optional waylandSupport wayland;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "PS3 emulator/debugger";
    homepage = "https://rpcs3.net/";
    maintainers = with maintainers; [ abbradar nocent ];
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
  };
}
