{ stdenv, fetchFromGitHub, cmake, python3, vulkan-loader,
  glslang, pkgconfig, xlibsWrapper, libxcb, libXrandr, wayland }:

stdenv.mkDerivation rec {
  name = "vulkan-tools-${version}";
  version = "1.1.77.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Tools";
    rev = "sdk-${version}";
    sha256 = "1c827n0xz8d7ydqpjchd58as943acyi182a0p4aq3bdsaxlmmpkg";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake python3 vulkan-loader xlibsWrapper libxcb libXrandr wayland ];
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
