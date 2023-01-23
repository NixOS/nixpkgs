{ lib, stdenv
, fetchFromGitHub
, fetchurl
, cmake
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
    rev = "22d39cd684d136a81778cc17a0226ffad40d1cee";
    hash = "sha256-6LplxN7HOMK1NfeD32P5JAMpCBlouttxLEOT/XTVpLw=";
  };
  spirv-tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "b930e734ea198b7aabbbf04ee1562cf6f57962f0";
    hash = "sha256-NWpFSRoxtYWi+hLUt9gpw0YScM3shcUwv9yUmbivRb0=";
  };
  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "36c0c1596225e728bd49abb7ef56a3953e7ed468";
    hash = "sha256-t1UMJnYONWOtOxc9zUgxr901QFNvqkgurjpFA8UzhYc=";
  };
  vulkan-docs = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Docs";
    rev = "135da3a538263ef0d194cab25e2bb091119bdc42";
    hash = "sha256-VZ8JxIuOEG7IjsVcsJOcC+EQeZbd16/+czLcO9t7dY4=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vulkan-cts";
  version = "1.3.4.1";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "VK-GL-CTS";
    rev = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-XUFlYdudyRqa6iupB8N5QkUpumasyLLQEWcr4M4uP1g=";
  };

  outputs = [ "out" "lib" ];

  prePatch = ''
    mkdir -p external/renderdoc/src external/spirv-headers external/vulkan-docs

    cp -r ${renderdoc} external/renderdoc/src/renderdoc_app.h

    cp -r ${amber} external/amber/src
    cp -r ${jsoncpp} external/jsoncpp/src
    cp -r ${glslang} external/glslang/src
    cp -r ${spirv-tools} external/spirv-tools/src
    cp -r ${spirv-headers} external/spirv-headers/src
    cp -r ${vulkan-docs} external/vulkan-docs/src
    chmod u+w -R external
  '';

  buildInputs = [
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
