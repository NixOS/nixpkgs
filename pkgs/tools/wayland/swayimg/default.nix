{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, meson
, ninja
, pkg-config
, wayland-scanner
, wayland
, wayland-protocols
, json_c
, libxkbcommon
, fontconfig
, giflib
, libheif
, libjpeg
, libwebp
, libtiff
, librsvg
, libpng
, libjxl
, libexif
, bash-completion
}:
stdenv.mkDerivation rec {
  pname = "swayimg";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "artemsen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UwIufR3EwbpNVHD1GypV3qNgiqDRllwtxAM0CZPodn0=";
  };

  patches = [
    (fetchpatch {
      name = "link-libwebp-1.3.1.patch";
      url = "https://github.com/artemsen/swayimg/commit/bd3d6c838c699b876fd8c19b408c475eb47e17b6.patch";
      hash = "sha256-2aMq/GTqyKw+CQr8o8ij4P4yNjBXYKXShQUknStUb5c=";
    })
  ];

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner ];

  buildInputs = [
    bash-completion
    wayland
    wayland-protocols
    json_c
    libxkbcommon
    fontconfig
    giflib
    libheif
    libjpeg
    libwebp
    libtiff
    librsvg
    libpng
    libjxl
    libexif
  ];

  meta = with lib; {
    homepage = "https://github.com/artemsen/swayimg";
    description = "Image viewer for Sway/Wayland";
    changelog = "https://github.com/artemsen/swayimg/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
    platforms = platforms.linux;
  };
}
