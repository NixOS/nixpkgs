{ stdenv, lib, fetchgit, cmake, pkgconfig
, qtbase, openal, glew, llvm_4, vulkan-loader, libpng, ffmpeg, libevdev
, pulseaudioSupport ? true, libpulseaudio
, waylandSupport ? true, wayland
, alsaSupport ? true, alsaLib
}:

stdenv.mkDerivation rec {
  name = "rpcs3-${version}";
  version = "2018-02-23";

  src = fetchgit {
    url = "https://github.com/RPCS3/rpcs3";
    rev = "41bd07274f15b8f1be2475d73c3c75ada913dabb";
    sha256 = "1v28m64ahakzj4jzjkmdd7y8q75pn9wjs03vprbnl0z6wqavqn0x";
  };

  cmakeFlags = [
    "-DUSE_SYSTEM_LIBPNG=ON"
    "-DUSE_SYSTEM_FFMPEG=ON"
    "-DUSE_NATIVE_INSTRUCTIONS=OFF"
  ];

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    qtbase openal glew llvm_4 vulkan-loader libpng ffmpeg libevdev
  ] ++ lib.optional pulseaudioSupport libpulseaudio
    ++ lib.optional alsaSupport alsaLib
    ++ lib.optional waylandSupport wayland;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "PS3 emulator/debugger";
    homepage = "https://rpcs3.net/";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
  };
}
