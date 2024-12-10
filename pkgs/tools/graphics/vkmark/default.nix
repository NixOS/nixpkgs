{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  vulkan-headers,
  vulkan-loader,
  mesa,
  wayland-protocols,
  wayland,
  glm,
  assimp,
  libxcb,
  xcbutilwm,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "vkmark";
  version = "2017.08-unstable-2023-04-12";

  src = fetchFromGitHub {
    owner = "vkmark";
    repo = "vkmark";
    rev = "ab6e6f34077722d5ae33f6bd40b18ef9c0e99a15";
    sha256 = "sha256-X1Y2U1aJymKrv3crJLN7tvXHG2W+w0W5gB2g00y4yvc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
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

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "An extensible Vulkan benchmarking suite";
    homepage = "https://github.com/vkmark/vkmark";
    license = with licenses; [ lgpl21Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ muscaln ];
    mainProgram = "vkmark";
  };
}
