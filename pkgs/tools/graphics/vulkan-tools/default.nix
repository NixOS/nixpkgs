{ lib
, stdenv
, fetchFromGitHub
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
, wayland
, wayland-protocols
, moltenvk
, AppKit
, Cocoa
}:

stdenv.mkDerivation rec {
  pname = "vulkan-tools";
  version = "1.3.254";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Tools";
    rev = "v${version}";
    hash = "sha256-MyYngyoIGpGu1jFN1GDm9BcFye1JRz1cN6SaZue1ZGQ=";
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

  patches = [
    # Vulkan-Tools expects to find the MoltenVK ICD and `libMoltenVK.dylib` in its source repo.
    # Patch it to use the already-built binaries and ICD in nixpkgs.
    ./use-nix-moltenvk.patch
  ];

  # vkcube.app and vkcubepp.app require `ibtool`, but the version in `xib2nib` is not capable of
  # building these apps. Build them using `ibtool` from Xcode, but don’t allow any other binaries
  # into the sandbox. Note that the CLT are not supported because `ibtool` requires Xcode.
  sandboxProfile = lib.optionalString stdenv.isDarwin ''
    (allow process-exec
      (literal "/usr/bin/ibtool")
      (regex "/Xcode.app/Contents/Developer/usr/bin/ibtool")
      (regex "/Xcode.app/Contents/Developer/usr/bin/xcodebuild"))
    (allow file-read*)
    (deny file-read* (subpath "/usr/local") (with no-log))
    (allow file-write* (subpath "/private/var/folders"))
  '';

  dontPatchELF = true;

  cmakeFlags = [
    # Don't build the mock ICD as it may get used instead of other drivers, if installed
    "-DBUILD_ICD=OFF"
    # vulkaninfo loads libvulkan using dlopen, so we have to add it manually to RPATH
    "-DCMAKE_INSTALL_RPATH=${libraryPath}"
    "-DPKG_CONFIG_EXECUTABLE=${pkg-config}/bin/pkg-config"
    # Hide dev warnings that are useless for packaging
    "-Wno-dev"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DMOLTENVK_REPO_ROOT=${moltenvk}/share/vulkan/icd.d"
    "-DIBTOOL=/usr/bin/ibtool"
  ];

  meta = with lib; {
    description = "Khronos official Vulkan Tools and Utilities";
    longDescription = ''
      This project provides Vulkan tools and utilities that can assist
      development by enabling developers to verify their applications correct
      use of the Vulkan API.
    '';
    homepage    = "https://github.com/KhronosGroup/Vulkan-Tools";
    hydraPlatforms = [ "x86_64-linux" "i686-linux" ];
    platforms   = platforms.unix;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
