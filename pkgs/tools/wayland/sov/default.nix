{ lib
, stdenv
, fetchFromGitHub
, cmake
, meson
, ninja
, pkg-config
, wayland
, wayland-protocols
, wayland-scanner
, freetype
, linuxHeaders
}:

stdenv.mkDerivation rec {
  pname = "sov";
  version = "0.63";

  src = fetchFromGitHub {
    owner = "milgra";
    repo = "sov";
    rev = "${version}";
    sha256 = "0qi0xhi47rmagcxzqcvfhbr3jp5ir24q3lahbdikv894yl85774i";
  };

  # Need <linux/limits.h> in addition to <limits.h>
  patchPhase = ''
    find . -type f -iname "*.c" -exec sed -i.bak '/limits.h/a #include <linux/limits.h>' "{}" +;
  '';

  outPath = [ "bin" "share" ];

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    linuxHeaders
    freetype
    wayland
    wayland-protocols
  ];

  postInstall = ''
    install -v -m0755 ../config $out/share/config
  '';

  meta = with lib; {
    homepage = "https://github.com/milgra/sov";
    description = "An overlay that shows schemas for all workspaces to make navigation in sway easier.";
    license = licenses.mit;
    maintainers = with maintainers; [ twitchyliquid64 ];
    platforms = platforms.linux;
  };
}
