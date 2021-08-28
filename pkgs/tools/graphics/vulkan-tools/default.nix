{ stdenv, lib, fetchFromGitHub, cmake, python3, vulkan-loader,
 vulkan-headers, glslang, pkg-config, xlibsWrapper, libxcb,
 libXrandr, wayland }:

stdenv.mkDerivation rec {
  pname = "vulkan-tools";
  version = "1.2.162.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Tools";
    rev = "sdk-${version}";
    sha256 = "088vqh956zma3p1qc3p6rsygf5s395b6cv8b1x0whp2a0a1y81xz";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ python3 vulkan-headers vulkan-loader xlibsWrapper libxcb libXrandr wayland ];

  libraryPath = lib.strings.makeLibraryPath [ vulkan-loader ];

  dontPatchELF = true;

  cmakeFlags = [
    # Don't build the mock ICD as it may get used instead of other drivers, if installed
    "-DBUILD_ICD=OFF"
    "-DGLSLANG_INSTALL_DIR=${glslang}"
    # vulkaninfo loads libvulkan using dlopen, so we have to add it manually to RPATH
    "-DCMAKE_INSTALL_RPATH=${libraryPath}"
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
