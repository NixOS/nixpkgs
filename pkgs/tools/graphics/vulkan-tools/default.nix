{ stdenv, lib, fetchFromGitHub, cmake, glslang, libX11, libxcb
, libXrandr, vulkan-headers, vulkan-loader, wayland }:

stdenv.mkDerivation rec {
  pname = "vulkan-tools";
  version = "1.2.189.1";

  # It's not strictly necessary to have matching versions here, however
  # since we're using the SDK version we may as well be consistent with
  # the rest of nixpkgs.
  src = (assert version == vulkan-headers.version;
    fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "Vulkan-Tools";
      rev = "sdk-${version}";
      sha256 = "0izmzyj6gb51d71vbdjcgd9qw34aidvbmz0mg4bkc13n48w8s9vj";
    });

  nativeBuildInputs = [ cmake ];
  buildInputs = [ glslang libX11 libxcb libXrandr vulkan-headers vulkan-loader wayland ];

  libraryPath = lib.strings.makeLibraryPath [ vulkan-loader ];

  dontPatchELF = true;

  cmakeFlags = [
    # Don't build the mock ICD as it may get used instead of other drivers, if installed
    "-DBUILD_ICD=OFF"
    # vulkaninfo loads libvulkan using dlopen, so we have to add it manually to RPATH
    "-DCMAKE_INSTALL_RPATH=${libraryPath}"
    # Hide dev warnings that are useless for packaging
    "-Wno-dev"
  ];

  meta = with lib; {
    description = "Khronos official Vulkan Tools and Utilities";
    longDescription = ''
      This project provides Vulkan tools and utilities that can assist
      development by enabling developers to verify their applications correct
      use of the Vulkan API.
    '';
    homepage    = "https://github.com/KhronosGroup/Vulkan-Tools";
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
