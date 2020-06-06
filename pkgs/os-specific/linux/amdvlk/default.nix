{ stdenv, cmake, pkgconfig, wayland, python3, fetchRepoProject, libffi, perl, xorg, openssl }:

stdenv.mkDerivation rec {
  pname = "amdvlk";
  version = "v-2020.Q2.4";

  src = fetchRepoProject {
    name = "amdvlk-src";
    manifest = "https://github.com/GPUOpen-Drivers/AMDVLK.git";
    rev = "fc576d9b331e8b86c1881f4b2385af8a093baef0";
    sha256 = "0bbpbyxnnl3pxx8aycv59kgilw5m6ddrida1gqfjblhc30mr0ivg";
  };

  preConfigure = ''
    cd drivers/xgl
  '';

  cmakeFlags = [
    "-DBUILD_WAYLAND_SUPPORT=ON"
  ];

  buildInputs = [
    wayland
    libffi
    xorg.libX11
    xorg.libxshmfence
    openssl
  ];

  nativeBuildInputs = [
    cmake
    pkgconfig
    python3
    perl
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/GPUOpen-Drivers/AMDVLK.git";
    description = "AMD Open Source Driver for Vulkan®";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ alexarice ];
  };
}
