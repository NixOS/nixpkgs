{ lib, stdenv
, fetchFromGitHub
, fetchurl
, cmake
, ffmpeg_4
, libdrm
, libglvnd
, libffi
, libpng
, libX11
, libXau
, libXdmcp
, libxcb
, makeWrapper
, ninja
, pkg-config
, python3
, vulkan-loader
, wayland
, wayland-protocols
, wayland-scanner
, zlib
}:
let
  renderdoc = fetchurl {
    url = "https://raw.githubusercontent.com/baldurk/renderdoc/v1.1/renderdoc/api/app/renderdoc_app.h";
    hash = "sha256-57XwqlsbDq3GOhxiTAyn9a8TOqhX1qQnGw7z0L22ho4=";
  };

  # The build system expects all these dependencies inside the external folder and
  # does not search for system-wide installations.
  # It also expects the version specified in the repository, which can be incompatible
  # with the version in nixpkgs (e.g. for SPIRV-Headers), so we don't want to patch in our packages.
  # The revisions are extracted from https://github.com/KhronosGroup/VK-GL-CTS/blob/main/external/fetch_sources.py#L290
  # with the vk-cts-sources.py script.
  sources = import ./sources.nix { inherit fetchurl fetchFromGitHub; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vulkan-cts";
  version = "1.3.6.3";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "VK-GL-CTS";
    rev = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-jpKPmUduH3IuUYzBAZJFl/w1FqjGC8sXSTnet8YEZ0I=";
  };

  outputs = [ "out" "lib" ];

  prePatch = ''
    mkdir -p external/renderdoc/src

    cp -r ${renderdoc} external/renderdoc/src/renderdoc_app.h

    ${sources.prePatch}

    chmod u+w -R external
  '';

  buildInputs = [
    ffmpeg_4
    libdrm
    libffi
    libglvnd
    libpng
    libX11
    libXau
    libXdmcp
    libxcb
    wayland
    wayland-protocols
    zlib
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
    ninja
    pkg-config
    python3
    wayland-scanner
  ];

  cmakeFlags = [
    # Fix cts cmake not coping with absolute install dirs
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"

    "-DWAYLAND_SCANNER=wayland-scanner"
  ];

  postInstall = ''
    mv $out $lib

    mkdir -p $out/bin $out/archive-dir
    cp -a external/vulkancts/modules/vulkan/deqp-vk external/vulkancts/modules/vulkan/deqp-vksc $out/bin/
    cp -a external/vulkancts/modules/vulkan/vulkan $out/archive-dir/
    cp -a external/vulkancts/modules/vulkan/vk-default $out/

    wrapProgram $out/bin/deqp-vk \
      --add-flags '--deqp-vk-library-path=${vulkan-loader}/lib/libvulkan.so' \
      --add-flags "--deqp-archive-dir=$out/archive-dir"
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Khronos Vulkan Conformance Tests";
    homepage = "https://github.com/KhronosGroup/VK-GL-CTS/blob/main/external/vulkancts/README.md";
    changelog = "https://github.com/KhronosGroup/VK-GL-CTS/releases/tag/${finalAttrs.pname}-${finalAttrs.version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ Flakebi ];
  };
})
