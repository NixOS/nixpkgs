{ lib
, stdenv
, fetchFromGitHub
, buildPackages
, cmake
, pkg-config
, python3
, glslang
, libffi
, libX11
, libXau
, libxcb
, libXdmcp
, libXrandr
, vulkan-headers
, vulkan-loader
, vulkan-volk
, wayland
, wayland-protocols
, moltenvk
, AppKit
, Cocoa
}:

stdenv.mkDerivation rec {
  pname = "vulkan-tools";
  version = "1.3.283.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Tools";
    rev = "vulkan-sdk-${version}";
    hash = "sha256-IAlqFCenv5e70XyLSYh2fE84JZQFJwg+YKTGaK7ShKA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  buildInputs = [
    glslang
    vulkan-headers
    vulkan-loader
    vulkan-volk
  ] ++ lib.optionals (!stdenv.isDarwin) [
    libffi
    libX11
    libXau
    libxcb
    libXdmcp
    libXrandr
    wayland
    wayland-protocols
  ] ++ lib.optionals stdenv.isDarwin [
    moltenvk
    moltenvk.dev
    AppKit
    Cocoa
  ];

  libraryPath = lib.strings.makeLibraryPath [ vulkan-loader ];

  dontPatchELF = true;

  env.PKG_CONFIG_WAYLAND_SCANNER_WAYLAND_SCANNER="${buildPackages.wayland-scanner}/bin/wayland-scanner";

  cmakeFlags = [
    # Don't build the mock ICD as it may get used instead of other drivers, if installed
    "-DBUILD_ICD=OFF"
    # vulkaninfo loads libvulkan using dlopen, so we have to add it manually to RPATH
    "-DCMAKE_INSTALL_RPATH=${libraryPath}"
    "-DPKG_CONFIG_EXECUTABLE=${buildPackages.pkg-config}/bin/${buildPackages.pkg-config.targetPrefix}pkg-config"
    "-DGLSLANG_INSTALL_DIR=${glslang}"
    # Hide dev warnings that are useless for packaging
    "-Wno-dev"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DMOLTENVK_REPO_ROOT=${moltenvk}/share/vulkan/icd.d"
    # Don’t build the cube demo because it requires `ibtool`, which is not available in nixpkgs.
    "-DBUILD_CUBE=OFF"
  ];

  meta = with lib; {
    description = "Khronos official Vulkan Tools and Utilities";
    longDescription = ''
      This project provides Vulkan tools and utilities that can assist
      development by enabling developers to verify their applications correct
      use of the Vulkan API.
    '';
    homepage    = "https://github.com/KhronosGroup/Vulkan-Tools";
    platforms   = platforms.unix;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
