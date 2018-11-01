{ stdenv, fetchFromGitHub, cmake, python3, vulkan-loader,
  glslang, pkgconfig, xlibsWrapper, libxcb, libXrandr, wayland }:

stdenv.mkDerivation rec {
  name = "vulkan-tools-${version}";
  version = "1.1.85.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Tools";
    rev = "sdk-${version}";
    sha256 = "0f4dfr8g0vy7y1hvs6z9lw52kissailzisby4qnz4akv0zz5y5s5";
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
