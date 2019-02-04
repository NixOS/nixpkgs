{ stdenv, fetchFromGitHub, cmake, python3, vulkan-loader,
  glslang, pkgconfig, xlibsWrapper, libxcb, libXrandr, wayland }:

stdenv.mkDerivation rec {
  name = "vulkan-tools-${version}";
  version = "1.1.97";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Tools";
    rev = "sdk-${version}";
    sha256 = "1p70wk0x546w1dlvlghrqm4l4b6ql0x08pdybyagnwwph0gdvqy3";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ python3 vulkan-loader xlibsWrapper libxcb libXrandr wayland ];
  enableParallelBuilding = true;

  cmakeFlags = [ "-DBUILD_ICD=OFF" "-DGLSLANG_INSTALL_DIR=${glslang}" ];

  meta = with stdenv.lib; {
    description = "LunarG Vulkan loader";
    homepage    = https://www.lunarg.com;
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
