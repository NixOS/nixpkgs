{ stdenv, fetchFromGitHub, cmake, python3, vulkan-loader, vulkan-headers,
  glslang, pkgconfig, xlibsWrapper, libxcb, libXrandr, wayland }:

stdenv.mkDerivation rec {
  name = "vulkan-tools-${version}";
  version = "1.1.106.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Tools";
    rev = "sdk-${version}";
    sha256 = "0swqyk16mbkivyk79dpqbhpw05a7yrakqynywznr5zgqbc0z4gj8";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ python3 vulkan-headers vulkan-loader xlibsWrapper libxcb libXrandr wayland ];
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
