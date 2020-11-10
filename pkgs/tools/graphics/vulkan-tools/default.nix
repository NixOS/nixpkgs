{ stdenv, lib, fetchFromGitHub, cmake, python3, vulkan-loader,
 vulkan-headers, glslang, pkgconfig, xlibsWrapper, libxcb,
 libXrandr, wayland }:

stdenv.mkDerivation rec {
  pname = "vulkan-tools";
  version = "1.2.141.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Tools";
    rev = "sdk-${version}";
    sha256 = "1ch56ihm7rmilipfyc4i4ww7l6i20fb3qikkpm1ch43kzn42zjaw";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ python3 vulkan-headers vulkan-loader xlibsWrapper libxcb libXrandr wayland ];
  enableParallelBuilding = true;

  libraryPath = lib.strings.makeLibraryPath [ vulkan-loader ];

  dontPatchELF = true;

  cmakeFlags = [
    # Don't build the mock ICD as it may get used instead of other drivers, if installed
    "-DBUILD_ICD=OFF"
    "-DGLSLANG_INSTALL_DIR=${glslang}"
    # vulkaninfo loads libvulkan using dlopen, so we have to add it manually to RPATH
    "-DCMAKE_INSTALL_RPATH=${libraryPath}"
  ];

  meta = with stdenv.lib; {
    description = "LunarG Vulkan loader";
    homepage    = "https://www.lunarg.com";
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
