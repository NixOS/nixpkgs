{ lib, stdenv
, fetchFromGitHub
, fetchurl
, cmake
, ffmpeg
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
  amber = fetchFromGitHub {
    owner = "google";
    repo = "amber";
    rev = "8b145a6c89dcdb4ec28173339dd176fb7b6f43ed";
    hash = "sha256-+xFYlUs13khT6r475eJJ+XS875h2sb+YbJ8ZN4MOSAA=";
  };
  jsoncpp = fetchFromGitHub {
    owner = "open-source-parsers";
    repo = "jsoncpp";
    rev = "9059f5cad030ba11d37818847443a53918c327b1";
    hash = "sha256-m0tz8w8HbtDitx3Qkn3Rxj/XhASiJVkThdeBxIwv3WI=";
  };
  glslang = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "a0ad0d7067521fff880e36acfb8ce453421c3f25";
    hash = "sha256-ZKkFHGitLjw5LPJW1TswIJ+KulkrS8C4G3dUF5U/F2c=";
  };
  spirv-tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "f98473ceeb1d33700d01e20910433583e5256030";
    hash = "sha256-RSUmfp9QZ7yRbLdFygz9mDfrgUUT8og+ZD9/6VkghMo=";
  };
  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "87d5b782bec60822aa878941e6b13c0a9a954c9b";
    hash = "sha256-Bv10LM6YXaH2V64oqAcrps23higHzCjlIYYBob5zS4A=";
  };
  video-parser = fetchFromGitHub {
    owner = "nvpro-samples";
    repo = "vk_video_samples";
    rev = "7d68747d3524842afaf050c5e00a10f5b8c07904";
    hash = "sha256-L5IYDm0bLq+NlNrzozu0VQx8zL1na6AhrkjZKxOWSnU=";
  };
  vulkan-docs = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Docs";
    rev = "9a2e576a052a1e65a5d41b593e693ff02745604b";
    hash = "sha256-DBA2FeV0G/HI8GUMtGYO52jk7wM4HMlKLDA4b+Wmo+k=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vulkan-cts";
  version = "1.3.5.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "VK-GL-CTS";
    rev = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-RPuhcLJ5Ad41SFPjJBdghcNBPIGzZBeVWTjySWOp0KA=";
  };

  outputs = [ "out" "lib" ];

  prePatch = ''
    mkdir -p external/renderdoc/src external/spirv-headers external/video-parser external/vulkan-docs

    cp -r ${renderdoc} external/renderdoc/src/renderdoc_app.h

    cp -r ${amber} external/amber/src
    cp -r ${jsoncpp} external/jsoncpp/src
    cp -r ${glslang} external/glslang/src
    cp -r ${spirv-tools} external/spirv-tools/src
    cp -r ${spirv-headers} external/spirv-headers/src
    cp -r ${video-parser} external/video-parser/src
    cp -r ${vulkan-docs} external/vulkan-docs/src
    chmod u+w -R external
  '';

  buildInputs = [
    ffmpeg
    libdrm
    libffi
    libglvnd
    libpng
    libX11
    libXau
    libXdmcp
    libxcb
    spirv-headers
    spirv-tools
    wayland
    wayland-protocols
    zlib
  ];

  nativeBuildInputs = [
    cmake
    glslang
    makeWrapper
    ninja
    pkg-config
    python3
  ];

  # Fix cts cmake not coping with absolute install dirs
  cmakeFlags = [
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
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

  meta = with lib; {
    description = "Khronos Vulkan Conformance Tests";
    homepage = "https://github.com/KhronosGroup/VK-GL-CTS/blob/main/external/vulkancts/README.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ Flakebi ];
  };
})
