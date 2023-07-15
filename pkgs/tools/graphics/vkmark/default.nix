{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, meson
, ninja
, vulkan-headers
, vulkan-loader
, mesa
, wayland-protocols
, wayland
, glm
, assimp
, libxcb
, xcbutilwm
}:

stdenv.mkDerivation rec {
  pname = "vkmark";
  version = "unstable-2022-09-09";

  src = fetchFromGitHub {
    owner = "vkmark";
    repo = "vkmark";
    rev = "30d2cd37f0566589d90914501fc7c51a4e51f559";
    sha256 = "sha256-/awEJbmSiNJT71bijI5mrJkKN4DhRNxXO/qYpQECFnA=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [
    vulkan-headers
    vulkan-loader
    mesa
    glm
    assimp
    libxcb
    xcbutilwm
    wayland
    wayland-protocols
  ];

  meta = with lib; {
    description = "An extensible Vulkan benchmarking suite";
    homepage = "https://github.com/vkmark/vkmark";
    license = with licenses; [ lgpl21Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ muscaln ];
  };
}
