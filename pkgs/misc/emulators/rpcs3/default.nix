{ stdenv, lib, fetchgit, cmake, pkgconfig, git
, qt5, openal, glew, vulkan-loader, libpng, ffmpeg, libevdev, python27
, pulseaudioSupport ? true, libpulseaudio
, waylandSupport ? true, wayland
, alsaSupport ? true, alsaLib
}:

stdenv.mkDerivation rec {
  name = "rpcs3-${version}";
  version = "0.0.5-6884";

  src = fetchgit {
    url = "https://github.com/RPCS3/rpcs3";
    rev = "dcd7f442fac3b9b45ecaddf5460ecb8f7238df2e";
    sha256 = "1zjkv7vj110r19vjwhnzqz9l92cv00z02vkwi2fhi26m7avbhr3y";
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
