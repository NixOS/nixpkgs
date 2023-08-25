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
  amber = fetchFromGitHub {
    owner = "google";
    repo = "amber";
    rev = "933ecb4d6288675a92eb1650e0f52b1d7afe8273";
    hash = "sha256-v9z4gv/mTjaCkByZn6uDpMteQuIf0FzZXeKyoXfFjXo=";
  };
  esextractor = fetchFromGitHub {
    owner = "Igalia";
    repo = "ESExtractor";
    rev = "v0.2.5";
    hash = "sha256-A3lyTTarR1ZJrXcrLDR5D7H1kBwJNyrPPjEklRM9YBY=";
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
    rev = "cd2082e0584d4e39d11e3f401184e0d558ab304f";
    hash = "sha256-j7O0j4E8lQ9tqAiuhnD/t6VL45OUvntsoKlhiuCXet4=";
  };
  spirv-tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "01828dac778d08f4ebafd2e06bd419f6c84e5984";
    hash = "sha256-i1rDMVpUiNdacDe20DsN67/rzK5V434EzfSv97y+xGU=";
  };
  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "1feaf4414eb2b353764d01d88f8aa4bcc67b60db";
    hash = "sha256-VOq3r6ZcbDGGxjqC4IoPMGC5n1APUPUAs9xcRzxdyfk=";
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
    rev = "9fff8b252a3688c0231fa78709084bbe677d3bf7";
    hash = "sha256-KpKsKTY5xCSZ5Y92roa0fq/iqc1hVJNS7l87RFcxyRQ=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vulkan-cts";
  version = "1.3.6.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "VK-GL-CTS";
    rev = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-PWkY5PFoxKosteRgbo6aRqGFHBkoEPFcg6NN8EquD8U=";
  };

  outputs = [ "out" "lib" ];

  prePatch = ''
    mkdir -p external/ESExtractor external/renderdoc/src external/spirv-headers external/video-parser external/vulkan-docs

    cp -r ${renderdoc} external/renderdoc/src/renderdoc_app.h

    cp -r ${amber} external/amber/src
    cp -r ${esextractor} external/ESExtractor/src
    cp -r ${jsoncpp} external/jsoncpp/src
    cp -r ${glslang} external/glslang/src
    cp -r ${spirv-tools} external/spirv-tools/src
    cp -r ${spirv-headers} external/spirv-headers/src
    cp -r ${video-parser} external/video-parser/src
    cp -r ${vulkan-docs} external/vulkan-docs/src
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

  meta = with lib; {
    description = "Khronos Vulkan Conformance Tests";
    homepage = "https://github.com/KhronosGroup/VK-GL-CTS/blob/main/external/vulkancts/README.md";
    changelog = "https://github.com/KhronosGroup/VK-GL-CTS/releases/tag/${finalAttrs.pname}-${finalAttrs.version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ Flakebi ];
  };
})
