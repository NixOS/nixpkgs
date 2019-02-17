{ stdenv, fetchFromGitHub, cmake, nvidia_x11, cudatoolkit, ncurses }:

stdenv.mkDerivation rec {
  name = "nvtop-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Syllo";
    repo  = "nvtop";
    rev = version;
    sha256 = "1b6yz54xddip1r0k8cbqg41dpyhds18fj29bj3yf40xvysklb0f4";
  };

  cmakeFlags = [
    "-DNVML_INCLUDE_DIRS=${cudatoolkit}/include"
    "-DNVML_LIBRARIES=${nvidia_x11}/lib/libnvidia-ml.so"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ ncurses nvidia_x11 cudatoolkit ];

  meta = with stdenv.lib; {
    description = "A (h)top like like task monitor for NVIDIA GPUs";
    homepage = https://github.com/Syllo/nvtop;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ willibutz ];
  };
}
